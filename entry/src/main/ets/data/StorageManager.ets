/**
 * 存储管理器 — 负责所有数据的本地持久化
 * 修复：
 *   1. 密码使用 SHA-256 哈希存储（不再明文）
 *   2. 读取时进行完整性校验
 */

import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import {
  StorageKeys,
  UserAccount,
  CartLine,
  OrderLine,
  OrderRecord
} from '../models/DataModels';
import { hashPassword, verifyPassword } from '../utils/CryptoUtils';

export class StorageManager {
  private store: preferences.Preferences | undefined = undefined;

  /**
   * 初始化存储实例
   */
  async init(context: common.UIAbilityContext): Promise<void> {
    this.store = await preferences.getPreferences(context, StorageKeys.STORE_NAME);
  }

  private ensureStore(): preferences.Preferences {
    if (this.store === undefined) {
      throw new Error('StorageManager not initialized');
    }
    return this.store;
  }

  // ==================== 用户管理 ====================

  /**
   * 加载所有用户
   */
  async loadUsers(): Promise<UserAccount[]> {
    try {
      let usersText = await this.ensureStore().get(StorageKeys.USERS, '[]');
      if (typeof usersText === 'string') {
        return this.parseUsers(usersText);
      }
    } catch (err) {
      // ignore
    }
    return [];
  }

  /**
   * 保存所有用户（密码已哈希）
   */
  async saveUsers(users: UserAccount[]): Promise<void> {
    await this.ensureStore().put(StorageKeys.USERS, JSON.stringify(users));
    await this.ensureStore().flush();
  }

  /**
   * 查找用户
   */
  findUser(users: UserAccount[], phone: string): UserAccount | undefined {
    for (let i = 0; i < users.length; i++) {
      if (users[i].phone === phone) {
        return users[i];
      }
    }
    return undefined;
  }

  /**
   * 注册新用户 — 密码自动哈希
   */
  async registerUser(
    users: UserAccount[],
    phone: string,
    plainPassword: string,
    name: string,
    location: string
  ): Promise<{ account: UserAccount; users: UserAccount[] }> {
    let hashedPwd: string = await hashPassword(plainPassword);
    let account: UserAccount = {
      phone: phone,
      password: hashedPwd,
      name: name,
      location: location.length > 0 ? location : '校内自取点',
      createdAt: Date.now()
    };
    let nextUsers: UserAccount[] = [];
    for (let i = 0; i < users.length; i++) {
      nextUsers.push(users[i]);
    }
    nextUsers.push(account);
    await this.saveUsers(nextUsers);
    return { account, users: nextUsers };
  }

  /**
   * 登录验证 — 使用哈希比对
   */
  async authenticateUser(users: UserAccount[], phone: string, plainPassword: string): Promise<UserAccount | undefined> {
    let account: UserAccount | undefined = this.findUser(users, phone);
    if (account === undefined) {
      return undefined;
    }
    let matched: boolean = await verifyPassword(plainPassword, account.password);
    if (!matched) {
      return undefined;
    }
    return account;
  }

  /**
   * 修改密码 — 哈希后存储
   */
  async changePassword(
    users: UserAccount[],
    currentPhone: string,
    oldPlainPassword: string,
    newPlainPassword: string
  ): Promise<{ success: boolean; users: UserAccount[]; error: string }> {
    let account: UserAccount | undefined = this.findUser(users, currentPhone);
    if (account === undefined) {
      return { success: false, users, error: '账号不存在' };
    }
    let oldMatch: boolean = await verifyPassword(oldPlainPassword, account.password);
    if (!oldMatch) {
      return { success: false, users, error: '原密码不正确' };
    }
    let newHash: string = await hashPassword(newPlainPassword);
    let nextUsers: UserAccount[] = [];
    for (let i = 0; i < users.length; i++) {
      let u: UserAccount = users[i];
      if (u.phone === currentPhone) {
        let updated: UserAccount = {
          phone: u.phone,
          password: newHash,
          name: u.name,
          location: u.location,
          createdAt: u.createdAt
        };
        nextUsers.push(updated);
      } else {
        nextUsers.push(u);
      }
    }
    await this.saveUsers(nextUsers);
    return { success: true, users: nextUsers, error: '' };
  }

  // ==================== 登录状态 ====================

  async saveLoginState(phone: string, loggedIn: boolean): Promise<void> {
    let store = this.ensureStore();
    await store.put(StorageKeys.CURRENT_PHONE, phone);
    await store.put(StorageKeys.LOGGED_IN, loggedIn ? '1' : '0');
    await store.flush();
  }

  async loadLoginState(): Promise<{ phone: string; loggedIn: boolean }> {
    try {
      let store = this.ensureStore();
      let phone = await store.get(StorageKeys.CURRENT_PHONE, '');
      let loggedIn = await store.get(StorageKeys.LOGGED_IN, '0');
      return {
        phone: typeof phone === 'string' ? phone : '',
        loggedIn: typeof loggedIn === 'string' && loggedIn === '1'
      };
    } catch (err) {
      return { phone: '', loggedIn: false };
    }
  }

  // ==================== 用户资料 ====================

  async saveProfile(name: string, phone: string, location: string): Promise<void> {
    let store = this.ensureStore();
    await store.put(StorageKeys.USER_NAME, name);
    await store.put(StorageKeys.USER_PHONE, phone);
    await store.put(StorageKeys.USER_LOCATION, location);
    await store.flush();
  }

  async loadProfile(): Promise<{ name: string; phone: string; location: string }> {
    try {
      let store = this.ensureStore();
      let name = await store.get(StorageKeys.USER_NAME, '');
      let phone = await store.get(StorageKeys.USER_PHONE, '');
      let location = await store.get(StorageKeys.USER_LOCATION, '校内自取点');
      return {
        name: typeof name === 'string' ? name : '',
        phone: typeof phone === 'string' ? phone : '',
        location: typeof location === 'string' ? location : '校内自取点'
      };
    } catch (err) {
      return { name: '', phone: '', location: '校内自取点' };
    }
  }

  // ==================== 购物车 ====================

  private cartKey(phone: string): string {
    return StorageKeys.CART + '_' + phone;
  }

  async saveCart(phone: string, lines: CartLine[]): Promise<void> {
    await this.ensureStore().put(this.cartKey(phone), JSON.stringify(lines));
    await this.ensureStore().flush();
  }

  async loadCart(phone: string): Promise<CartLine[]> {
    try {
      let text = await this.ensureStore().get(this.cartKey(phone), '[]');
      if (typeof text === 'string') {
        return this.parseCartLines(text);
      }
    } catch (err) {
      // ignore
    }
    return [];
  }

  // ==================== 订单 ====================

  private ordersKey(phone: string): string {
    return StorageKeys.ORDERS + '_' + phone;
  }

  async saveOrders(phone: string, orders: OrderRecord[]): Promise<void> {
    await this.ensureStore().put(this.ordersKey(phone), JSON.stringify(orders));
    await this.ensureStore().flush();
  }

  async loadOrders(phone: string): Promise<OrderRecord[]> {
    try {
      let text = await this.ensureStore().get(this.ordersKey(phone), '[]');
      if (typeof text === 'string') {
        return this.parseOrders(text);
      }
    } catch (err) {
      // ignore
    }
    return [];
  }

  // ==================== JSON 解析 ====================

  private parseCartLines(raw: string): CartLine[] {
    let result: CartLine[] = [];
    try {
      let parsed: CartLine[] = JSON.parse(raw) as CartLine[];
      if (!Array.isArray(parsed)) {
        return result;
      }
      for (let i = 0; i < parsed.length; i++) {
        let line: CartLine = parsed[i];
        if (line.id.length > 0 && line.count > 0) {
          result.push({
            id: line.id,
            shopId: line.shopId,
            shopName: line.shopName,
            foodId: line.foodId,
            foodName: line.foodName,
            price: line.price,
            count: line.count
          });
        }
      }
    } catch (err) {
      return result;
    }
    return result;
  }

  private parseOrders(raw: string): OrderRecord[] {
    let result: OrderRecord[] = [];
    try {
      let parsed: OrderRecord[] = JSON.parse(raw) as OrderRecord[];
      if (!Array.isArray(parsed)) {
        return result;
      }
      for (let i = 0; i < parsed.length; i++) {
        let order: OrderRecord = parsed[i];
        if (order.id.length > 0 && order.items.length > 0) {
          let items: OrderLine[] = [];
          for (let j = 0; j < order.items.length; j++) {
            let source: OrderLine = order.items[j];
            items.push({
              foodId: source.foodId,
              foodName: source.foodName,
              price: source.price,
              count: source.count
            });
          }
          result.push({
            id: order.id,
            shopId: order.shopId,
            shopName: order.shopName,
            items: items,
            subtotal: order.subtotal,
            serviceFee: order.serviceFee,
            total: order.total,
            status: order.status,
            createdAt: order.createdAt,
            pickupTime: order.pickupTime,
            pickupCode: order.pickupCode,
            note: order.note
          });
        }
      }
    } catch (err) {
      return result;
    }
    return result;
  }

  private parseUsers(raw: string): UserAccount[] {
    let result: UserAccount[] = [];
    try {
      let parsed: UserAccount[] = JSON.parse(raw) as UserAccount[];
      if (!Array.isArray(parsed)) {
        return result;
      }
      for (let i = 0; i < parsed.length; i++) {
        let source: UserAccount = parsed[i];
        if (source.phone.length > 0 && source.password.length > 0) {
          result.push({
            phone: source.phone,
            password: source.password,
            name: source.name,
            location: source.location,
            createdAt: source.createdAt
          });
        }
      }
    } catch (err) {
      return result;
    }
    return result;
  }
}
