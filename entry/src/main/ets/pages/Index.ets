import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util } from '@kit.ArkTS';

enum AppView {
  Home = 0,
  Menu = 1,
  Cart = 2,
  Orders = 3,
  Pickup = 4,
  Profile = 5,
  Auth = 6,
  ProfileEdit = 7,
  ProfilePassword = 8
}

enum AuthMode {
  Login = 0,
  Register = 1
}

enum OrderStatus {
  Ready = 0,
  Completed = 1,
  Cancelled = 2
}

enum OrderFilter {
  All = 0,
  Ready = 1,
  Completed = 2,
  Cancelled = 3
}

interface ShopSeed {
  name: string;
  score: string;
  monthly: string;
  tags: string[];
  foodNames: string[];
}

interface FoodItem {
  id: string;
  shopId: string;
  name: string;
  price: number;
  category: string;
  desc: string;
  sold: number;
}

interface ShopItem {
  id: string;
  name: string;
  score: string;
  monthly: string;
  tags: string[];
  foods: FoodItem[];
}

interface CartLine {
  id: string;
  shopId: string;
  shopName: string;
  foodId: string;
  foodName: string;
  price: number;
  count: number;
}

interface OrderLine {
  foodId: string;
  foodName: string;
  price: number;
  count: number;
}

interface OrderRecord {
  id: string;
  shopId: string;
  shopName: string;
  items: OrderLine[];
  subtotal: number;
  serviceFee: number;
  total: number;
  status: OrderStatus;
  createdAt: number;
  pickupTime: number;
  pickupCode: string;
  note: string;
}

interface UserAccount {
  phone: string;
  password: string;
  name: string;
  location: string;
  createdAt: number;
}

class UiColors {
  static readonly PAGE: string = '#F7F8F5';
  static readonly SURFACE: string = '#FFFFFF';
  static readonly SURFACE_SOFT: string = '#FFF7ED';
  static readonly GREEN_SOFT: string = '#E8F7EE';
  static readonly GREEN: string = '#24A36A';
  static readonly PRIMARY: string = '#F97316';
  static readonly PRIMARY_DARK: string = '#EA580C';
  static readonly TEXT: string = '#1F2933';
  static readonly SUB_TEXT: string = '#6B7280';
  static readonly MUTED: string = '#9AA3AF';
  static readonly LINE: string = '#E9EDF2';
  static readonly DANGER: string = '#D94D39';
}

class StorageKeys {
  static readonly STORE_NAME: string = 'campus_canteen_user_cache';
  static readonly CART: string = 'cart_lines';
  static readonly ORDERS: string = 'orders';
  static readonly USER_NAME: string = 'user_name';
  static readonly USER_PHONE: string = 'user_phone';
  static readonly USER_LOCATION: string = 'user_location';
  static readonly USERS: string = 'users';
  static readonly CURRENT_PHONE: string = 'current_phone';
  static readonly LOGGED_IN: string = 'logged_in';
}

class SeedRepository {
  static readonly shopSeeds: ShopSeed[] = [
    {
      name: '土豆片夹馍',
      score: '4.8',
      monthly: '1280',
      tags: ['夹馍', '小吃加料'],
      foodNames: ['普通土豆片夹馍', '特色土豆片夹馍', '优质土豆片夹馍', '特优土豆片夹馍', '豪华土豆片夹馍', '全家福土豆片夹馍', '土豆片拌饼', '烤馍夹菜']
    },
    {
      name: '扬州干拌面',
      score: '4.7',
      monthly: '956',
      tags: ['面食', '特色推荐'],
      foodNames: ['麻酱干拌面', '麻辣干拌面', '番茄干拌面', '剁椒干拌面', '川香干拌面', '加面', '加小菜', '加卤蛋', '加花干', '加培根', '加火腿', '午餐肉', '加鸡柳']
    },
    {
      name: '山东美味杂粮煎饼',
      score: '4.8',
      monthly: '1146',
      tags: ['煎饼', '小吃加料'],
      foodNames: ['普通杂粮煎饼', '鸡蛋', '果子', '生菜', '烤肠', '肉排', '海带丝', '培根', '辣条', '鸡柳', '肉松', '卫龙小面筋']
    },
    {
      name: '老潼关肉夹馍',
      score: '4.6',
      monthly: '789',
      tags: ['夹馍', '热卖'],
      foodNames: ['肉夹馍', '牛舌饼', '千里香夹馍', '纯瘦肉夹馍', '卤蛋', '黄金豆干']
    },
    {
      name: '千里香馄饨',
      score: '4.7',
      monthly: '842',
      tags: ['汤面', '夜宵'],
      foodNames: ['馄饨小份', '馄饨大份', '米线', '酸辣粉', '飘香拌面', '卤蛋', '豆干']
    },
    {
      name: '老碗面',
      score: '4.8',
      monthly: '1038',
      tags: ['面食', '热卖'],
      foodNames: ['油泼面', '油泼干拌面', '西红柿鸡蛋面', '秘制肉干拌面', '炸酱面', '三合一', '四合一', '杨凌蘸水面', '碗汁', '面']
    },
    {
      name: '炸串夹馍',
      score: '4.5',
      monthly: '690',
      tags: ['炸串', '小吃加料'],
      foodNames: ['油饼卷菜', '八宝辣子夹馍', '馍', '素菜', '煎蛋', '培根', '蟹棒', '鱼豆腐', '大面筋', '鸡柳', '骨连', '淀粉肠', '鸡排', '牛排', '弹力肠', '五星串', '里脊肉', '鸡柳棒', '凉鱼']
    },
    {
      name: '稻粔茶泡饭',
      score: '4.6',
      monthly: '578',
      tags: ['米饭套餐', '清爽'],
      foodNames: ['孜然鸡茶泡饭', '椒麻鸡茶泡饭', '招牌茶泡饭', '金蒜紫茄茶泡饭']
    },
    {
      name: '元气煲饭',
      score: '4.7',
      monthly: '735',
      tags: ['米饭套餐', '热卖'],
      foodNames: ['奥尔良烤肉饭', '咖喱鸡肉饭', '元气绝味鸡', '元气酱香鸡', '元气小炒肉', '元气红烧肉', '双拼茶泡饭']
    }
  ];

  static createShops(): ShopItem[] {
    let shops: ShopItem[] = [];
    for (let i = 0; i < SeedRepository.shopSeeds.length; i++) {
      let seed: ShopSeed = SeedRepository.shopSeeds[i];
      let foods: FoodItem[] = [];
      for (let j = 0; j < seed.foodNames.length; j++) {
        let foodName: string = seed.foodNames[j];
        let food: FoodItem = {
          id: 'food_' + i + '_' + j,
          shopId: 'shop_' + i,
          name: foodName,
          price: SeedRepository.createPrice(foodName, j),
          category: SeedRepository.createCategory(foodName, seed.tags),
          desc: SeedRepository.createDesc(foodName),
          sold: 80 + i * 37 + j * 19
        };
        foods.push(food);
      }
      let shop: ShopItem = {
        id: 'shop_' + i,
        name: seed.name,
        score: seed.score,
        monthly: seed.monthly,
        tags: seed.tags,
        foods: foods
      };
      shops.push(shop);
    }
    return shops;
  }

  static createCategory(name: string, tags: string[]): string {
    if (name.indexOf('饭') >= 0 || tags.indexOf('米饭套餐') >= 0) {
      return '米饭套餐';
    }
    if (name.indexOf('面') >= 0 || name.indexOf('馄饨') >= 0 || name.indexOf('米线') >= 0 || name.indexOf('酸辣粉') >= 0) {
      return '面食';
    }
    if (name.indexOf('加') >= 0 || name.indexOf('蛋') >= 0 || name.indexOf('豆干') >= 0 || name.indexOf('小菜') >= 0 ||
      name.indexOf('肠') >= 0 || name.indexOf('培根') >= 0 || name.indexOf('鸡柳') >= 0 || name.indexOf('串') >= 0 ||
      name.indexOf('菜') >= 0 || name.indexOf('蟹棒') >= 0 || name.indexOf('鱼豆腐') >= 0 || name.indexOf('面筋') >= 0) {
      return '小吃加料';
    }
    return '特色推荐';
  }

  static createPrice(name: string, index: number): number {
    if (name.indexOf('加') >= 0 || name === '鸡蛋' || name === '果子' || name === '生菜' || name === '卤蛋' ||
      name === '豆干' || name === '碗汁' || name === '面' || name === '馍' || name === '素菜') {
      return 2 + index % 5;
    }
    if (name.indexOf('豪华') >= 0 || name.indexOf('全家福') >= 0 || name.indexOf('双拼') >= 0) {
      return 16 + index % 4;
    }
    if (name.indexOf('饭') >= 0) {
      return 12 + index % 6;
    }
    if (name.indexOf('面') >= 0 || name.indexOf('馄饨') >= 0 || name.indexOf('米线') >= 0 || name.indexOf('酸辣粉') >= 0) {
      return 8 + index % 7;
    }
    return 7 + index % 8;
  }

  static createDesc(name: string): string {
    if (name.indexOf('麻辣') >= 0 || name.indexOf('剁椒') >= 0 || name.indexOf('椒麻') >= 0) {
      return '香辣开胃，适合重口味';
    }
    if (name.indexOf('番茄') >= 0 || name.indexOf('西红柿') >= 0) {
      return '酸甜清爽，午餐更轻松';
    }
    if (name.indexOf('饭') >= 0) {
      return '现做热饭，取餐更省时';
    }
    if (name.indexOf('馄饨') >= 0 || name.indexOf('汤') >= 0 || name.indexOf('粉') >= 0) {
      return '汤底鲜香，热乎管饱';
    }
    return '现点现做，口味稳定';
  }
}

const MAX_FOOD_COUNT: number = 99;
const PICKUP_TIME_OPTIONS: number[] = [15, 30, 45];
const DEFAULT_PICKUP_MINUTES: number = 15;

function stringToUint8Array(s: string): Uint8Array { return new util.TextEncoder().encodeInto(s); }
function uint8ArrayToHex(b: Uint8Array): string { let p: string[] = []; for (let i=0;i<b.length;i++){let h=b[i].toString(16);if(h.length===1)h='0'+h; p.push(h);} return p.join(''); }
function rightRotate(v: number, a: number): number { return (v>>>a)|(v<<(32-a)); }
function toHexWord(v: number): string { let h=''; for(let i=7;i>=0;i--)h+=((v>>>(i*4))&0xF).toString(16); return h; }
function fallbackHash(i: string): string { let h1=0x67452301,h2=0xEFCDAB89,h3=0x98BADCFE,h4=0x10325476,h5=0xC3D2E1F0; let b:number[]=[]; for(let j=0;j<i.length;j++)b.push(i.charCodeAt(j)&0xFF); b.push(0x80); while((b.length+8)%64!==0)b.push(0); let bl=i.length*8; for(let j=7;j>=0;j--)b.push((bl>>>(j*8))&0xFF); for(let cs=0;cs<b.length;cs+=64){let w:number[]=[]; for(let j=0;j<16;j++){let o=cs+j*4; w[j]=(b[o]<<24)|(b[o+1]<<16)|(b[o+2]<<8)|b[o+3];} for(let j=16;j<80;j++){let s0=rightRotate(w[j-15],7)^rightRotate(w[j-15],18)^(w[j-15]>>>3); let s1=rightRotate(w[j-2],17)^rightRotate(w[j-2],19)^(w[j-2]>>>10); w[j]=(w[j-16]+s0+w[j-7]+s1)|0;} let a=0,b1=0,c1=0,d1=0,e1=0; a=h1;b1=h2;c1=h3;d1=h4;e1=h5; for(let j=0;j<80;j++){let f:number,k:number; if(j<20){f=(b1&c1)|((~b1)&d1);k=0x5A827999;} else if(j<40){f=b1^c1^d1;k=0x6ED9EBA1;} else if(j<60){f=(b1&c1)|(b1&d1)|(c1&d1);k=0x8F1BBCDC;} else{f=b1^c1^d1;k=0xCA62C1D6;} let t=(rightRotate(a,5)+f+e1+k+w[j])|0; e1=d1; d1=c1; c1=rightRotate(b1,30); b1=a; a=t;} h1=(h1+a)|0; h2=(h2+b1)|0; h3=(h3+c1)|0; h4=(h4+d1)|0; h5=(h5+e1)|0;} return toHexWord(h1)+toHexWord(h2)+toHexWord(h3)+toHexWord(h4)+toHexWord(h5); }
async function hashPassword(p: string): Promise<string> { try { let md = cryptoFramework.createMd('SHA256'); await md.update({ data: stringToUint8Array(p) }); let r = await md.digest(); return uint8ArrayToHex(r.data); } catch(e) { return fallbackHash(p); } }
async function verifyPassword(p: string, h: string): Promise<boolean> { return await hashPassword(p) === h; }
function isValidPhone(p: string): boolean { return /^1[3-9]\d{9}$/.test(p.trim()); }
function getPhoneError(p: string): string { if(p.trim().length===0)return '请输入手机号'; if(!isValidPhone(p))return '请输入正确的 11 位手机号'; return ''; }
function isValidPassword(p: string): boolean { return p.length>=6; }
function getPasswordError(p: string): string { if(p.length===0)return '请输入密码'; if(p.length<6)return '密码至少 6 位'; return ''; }
function clampFoodCount(c: number): number { if(c<0)return 0; if(c>MAX_FOOD_COUNT)return MAX_FOOD_COUNT; return c; }
function generateOrderId(): string { let n=Date.now(); return 'order_'+n.toString(36)+'_'+(n%100000).toString(); }
function generatePickupCode(): string { let n=Date.now(); return (1000+((n*31+7)%9000)).toString(); }

@Entry
@Component
struct Index {
  @State currentView: AppView = AppView.Auth;
  @State loggedIn: boolean = false;
  @State authMode: AuthMode = AuthMode.Login;
  @State authPhone: string = '';
  @State authPassword: string = '';
  @State registerName: string = '';
  @State registerPhone: string = '';
  @State registerPassword: string = '';
  @State registerLocation: string = '校内自取点';
  @State authMessage: string = '';
  @State currentPhone: string = '';
  @State users: UserAccount[] = [];
  @State selectedShopId: string = 'shop_0';
  @State selectedHomeCategory: string = '全部';
  @State selectedMenuCategory: string = '全部';
  @State searchText: string = '';
  @State cartLines: CartLine[] = [];
  @State orders: OrderRecord[] = [];
  @State orderFilter: OrderFilter = OrderFilter.All;
  @State orderNote: string = '';
  @State userName: string = '';
  @State userPhone: string = '';
  @State userLocation: string = '校内自取点';
  @State draftName: string = '';
  @State draftPhone: string = '';
  @State draftLocation: string = '校内自取点';
  @State profileMessage: string = '';
  @State oldPassword: string = '';
  @State newPassword: string = '';
  @State confirmPassword: string = '';
  @State passwordMessage: string = '';
  @State refreshKey: number = 0;

  private shops: ShopItem[] = SeedRepository.createShops();
  @State showOrderConfirm: boolean = false;
  @State selectedPickupMinutes: number = DEFAULT_PICKUP_MINUTES;
  @State countEditorVisible: boolean = false;
  @State countEditorTargetId: string = '';
  @State countEditorMode: string = 'food';
  @State countEditorValue: string = '';
  @State showCartPopup: boolean = false;

  private clearCart(): void { this.cartLines = []; this.updateAndSave(); this.showCartPopup = false; }
  private store: preferences.Preferences | undefined = undefined;
  private confirmOrder(): void { if (this.cartLines.length > 0) this.showOrderConfirm = true; }
  private formatPickupMinutes(m: number): string { if(m<60)return m.toString()+' 分钟'; let h=Math.floor(m/60); let mm=m%60; if(mm===0)return h.toString()+' 小时'; return h.toString()+' 小时 '+mm.toString()+' 分钟'; }

  aboutToAppear(): void {
    this.loadCache();
  }

  private async loadCache(): Promise<void> {
    try {
      let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
      this.store = await preferences.getPreferences(context, StorageKeys.STORE_NAME);
      let store: preferences.Preferences | undefined = this.store;
      if (store === undefined) {
        return;
      }
      let usersText: preferences.ValueType = await store.get(StorageKeys.USERS, '[]');
      let cachedPhone: preferences.ValueType = await store.get(StorageKeys.CURRENT_PHONE, '');
      let cachedLoggedIn: preferences.ValueType = await store.get(StorageKeys.LOGGED_IN, '0');
      if (typeof usersText === 'string') {
        this.users = this.parseUsers(usersText);
      }
      if (typeof cachedPhone === 'string' && typeof cachedLoggedIn === 'string' && cachedLoggedIn === '1') {
        let account: UserAccount | undefined = this.findUser(cachedPhone);
        if (account !== undefined) {
          await this.activateAccount(account, false);
        }
      }
      this.refreshKey++;
    } catch (error) {
      this.refreshKey++;
    }
  }

  private async saveCache(): Promise<void> {
    let store: preferences.Preferences | undefined = this.store;
    if (store === undefined) {
      return;
    }
    try {
      await store.put(StorageKeys.USERS, JSON.stringify(this.users));
      await store.put(StorageKeys.CURRENT_PHONE, this.currentPhone);
      await store.put(StorageKeys.LOGGED_IN, this.loggedIn ? '1' : '0');
      await store.put(StorageKeys.USER_NAME, this.userName);
      await store.put(StorageKeys.USER_PHONE, this.userPhone);
      await store.put(StorageKeys.USER_LOCATION, this.userLocation);
      if (this.currentPhone.length > 0) {
        await store.put(this.userCartKey(this.currentPhone), JSON.stringify(this.cartLines));
        await store.put(this.userOrdersKey(this.currentPhone), JSON.stringify(this.orders));
      }
      await store.flush();
    } catch (error) {
      return;
    }
  }

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
          let item: CartLine = {
            id: line.id,
            shopId: line.shopId,
            shopName: line.shopName,
            foodId: line.foodId,
            foodName: line.foodName,
            price: line.price,
            count: line.count
          };
          result.push(item);
        }
      }
    } catch (error) {
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
            let item: OrderLine = {
              foodId: source.foodId,
              foodName: source.foodName,
              price: source.price,
              count: source.count
            };
            items.push(item);
          }
          let record: OrderRecord = {
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
          };
          result.push(record);
        }
      }
    } catch (error) {
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
          let account: UserAccount = {
            phone: source.phone,
            password: source.password,
            name: source.name,
            location: source.location,
            createdAt: source.createdAt
          };
          result.push(account);
        }
      }
    } catch (error) {
      return result;
    }
    return result;
  }

  private userCartKey(phone: string): string {
    return StorageKeys.CART + '_' + phone;
  }

  private userOrdersKey(phone: string): string {
    return StorageKeys.ORDERS + '_' + phone;
  }

  private findUser(phone: string): UserAccount | undefined {
    for (let i = 0; i < this.users.length; i++) {
      if (this.users[i].phone === phone) {
        return this.users[i];
      }
    }
    return undefined;
  }

  private async activateAccount(account: UserAccount, shouldSave: boolean): Promise<void> {
    this.loggedIn = true;
    this.currentPhone = account.phone;
    this.userName = account.name;
    this.userPhone = account.phone;
    this.userLocation = account.location;
    this.draftName = account.name;
    this.draftPhone = account.phone;
    this.draftLocation = account.location;
    this.authPhone = '';
    this.authPassword = '';
    this.registerName = '';
    this.registerPhone = '';
    this.registerPassword = '';
    this.authMessage = '';
    this.profileMessage = '';
    this.passwordMessage = '';
    this.oldPassword = '';
    this.newPassword = '';
    this.confirmPassword = '';
    this.currentView = AppView.Home;

    let store: preferences.Preferences | undefined = this.store;
    if (store !== undefined) {
      try {
        let cartText: preferences.ValueType = await store.get(this.userCartKey(account.phone), '[]');
        let orderText: preferences.ValueType = await store.get(this.userOrdersKey(account.phone), '[]');
        if (typeof cartText === 'string') {
          this.cartLines = this.parseCartLines(cartText);
        } else {
          this.cartLines = [];
        }
        if (typeof orderText === 'string') {
          this.orders = this.parseOrders(orderText);
        } else {
          this.orders = [];
        }
      } catch (error) {
        this.cartLines = [];
        this.orders = [];
      }
    }
    if (shouldSave) {
      this.updateAndSave();
    }
  }

  private async login(): Promise<void> {
    let phone: string = this.authPhone.trim();
    let password: string = this.authPassword.trim();
    if (!isValidPhone(phone)) { this.authMessage = getPhoneError(phone); return; }
    if (password.length === 0) { this.authMessage = '请输入密码'; return; }
    let account: UserAccount | undefined = this.findUser(phone);
    if (account === undefined) { this.authMessage = '手机号或密码不正确'; return; }
    let matched: boolean = await verifyPassword(password, account.password);
    if (!matched) { this.authMessage = '手机号或密码不正确'; return; }
    this.activateAccount(account, true);
    console.info('[登录] ' + phone + ' 登录成功');
    console.info('[用户列表] 共' + this.users.length.toString() + '人: ' + this.users.map((u: UserAccount) => u.phone + '(' + u.name + ')[' + u.password.substring(0,8) + '...]').join(', '));
  }

  private async register(): Promise<void> {
    let name: string = this.registerName.trim();
    let phone: string = this.registerPhone.trim();
    let password: string = this.registerPassword.trim();
    let location: string = this.registerLocation.trim();
    if (name.length === 0 || phone.length === 0 || password.length === 0) { this.authMessage = '请填写姓名、手机号和密码'; return; }
    if (!isValidPhone(phone)) { this.authMessage = getPhoneError(phone); return; }
    if (!isValidPassword(password)) { this.authMessage = getPasswordError(password); return; }
    if (this.findUser(phone) !== undefined) { this.authMessage = '该手机号已注册，可直接登录'; return; }
    let hashedPwd: string = await hashPassword(password);
    let account: UserAccount = {
      phone: phone, password: hashedPwd, name: name,
      location: location.length > 0 ? location : '校内自取点', createdAt: Date.now()
    };
    let nextUsers: UserAccount[] = [];
    for (let i = 0; i < this.users.length; i++) { nextUsers.push(this.users[i]); }
    nextUsers.push(account);
    this.users = nextUsers;
    this.cartLines = [];
    this.orders = [];
    this.activateAccount(account, true);
    console.info('[注册] 新用户: ' + phone + ' | 密码已SHA-256哈希存储');
    console.info('[用户列表] 共' + this.users.length.toString() + '人: ' + this.users.map((u: UserAccount) => u.phone + '(' + u.name + ')').join(', '));
  }

  private logout(): void {
    this.loggedIn = false;
    this.currentPhone = '';
    this.userName = '';
    this.userPhone = '';
    this.userLocation = '校内自取点';
    this.cartLines = [];
    this.orders = [];
    this.orderNote = '';
    this.profileMessage = '';
    this.passwordMessage = '';
    this.oldPassword = '';
    this.newPassword = '';
    this.confirmPassword = '';
    this.currentView = AppView.Auth;
    this.authMode = AuthMode.Login;
    this.updateAndSave();
  }

  private syncCurrentAccount(): void {
    let next: UserAccount[] = [];
    for (let i = 0; i < this.users.length; i++) {
      let account: UserAccount = this.users[i];
      if (account.phone === this.currentPhone) {
        let updated: UserAccount = {
          phone: this.userPhone,
          password: account.password,
          name: this.userName,
          location: this.userLocation,
          createdAt: account.createdAt
        };
        next.push(updated);
      } else {
        next.push(account);
      }
    }
    this.users = next;
    this.currentPhone = this.userPhone;
  }

  private getShopImageResource(shopId: string): Resource {
    if (shopId === 'shop_0') {
      return $r('app.media.img_food_rougamo');
    }
    if (shopId === 'shop_1') {
      return $r('app.media.img_food_noodle');
    }
    if (shopId === 'shop_2') {
      return $r('app.media.img_food_jianbing');
    }
    if (shopId === 'shop_3') {
      return $r('app.media.img_food_ltg');
    }
    if (shopId === 'shop_4') {
      return $r('app.media.img_food_wonton');
    }
    if (shopId === 'shop_5') {
      return $r('app.media.img_food_youpo');
    }
    if (shopId === 'shop_6') {
      return $r('app.media.img_food_skewer');
    }
    if (shopId === 'shop_7') {
      return $r('app.media.img_food_chazuke');
    }
    return $r('app.media.img_food_claypot');
  }

  private findFoodById(foodId: string): FoodItem | undefined {
    for (let i = 0; i < this.shops.length; i++) {
      let shop: ShopItem = this.shops[i];
      for (let j = 0; j < shop.foods.length; j++) {
        if (shop.foods[j].id === foodId) {
          return shop.foods[j];
        }
      }
    }
    return undefined;
  }

  private getFoodImageResource(food: FoodItem): Resource {
    if (food.name.indexOf('馄饨') >= 0 || food.name.indexOf('米线') >= 0 || food.name.indexOf('酸辣粉') >= 0) {
      return $r('app.media.img_food_wonton');
    }
    if (food.name.indexOf('油泼') >= 0 || food.name.indexOf('炸酱') >= 0 || food.name.indexOf('面') >= 0) {
      return $r('app.media.img_food_noodle');
    }
    if (food.name.indexOf('煎饼') >= 0 || food.name.indexOf('果子') >= 0) {
      return $r('app.media.img_food_jianbing');
    }
    if (food.name.indexOf('炸') >= 0 || food.name.indexOf('串') >= 0 || food.name.indexOf('肠') >= 0 || food.name.indexOf('鸡柳') >= 0) {
      return $r('app.media.img_food_skewer');
    }
    if (food.name.indexOf('茶泡饭') >= 0) {
      return $r('app.media.img_food_chazuke');
    }
    if (food.name.indexOf('饭') >= 0 || food.name.indexOf('鸡') >= 0 || food.name.indexOf('肉') >= 0) {
      return $r('app.media.img_food_claypot');
    }
    return this.getShopImageResource(food.shopId);
  }

  private getCartLineImageResource(line: CartLine): Resource {
    let food: FoodItem | undefined = this.findFoodById(line.foodId);
    if (food !== undefined) {
      return this.getFoodImageResource(food);
    }
    return this.getShopImageResource(line.shopId);
  }

  private updateAndSave(): void {
    this.refreshKey++;
    this.saveCache();
  }

  private getHomeCategories(): string[] {
    return ['全部', '特色推荐', '面食', '米饭套餐', '小吃加料'];
  }

  private getVisibleShops(): ShopItem[] {
    let result: ShopItem[] = [];
    for (let i = 0; i < this.shops.length; i++) {
      let shop: ShopItem = this.shops[i];
      if (this.matchesSearch(shop) && this.matchesHomeCategory(shop)) {
        result.push(shop);
      }
    }
    return result;
  }

  private matchesSearch(shop: ShopItem): boolean {
    let keyword: string = this.searchText.trim();
    if (keyword.length === 0) {
      return true;
    }
    if (shop.name.indexOf(keyword) >= 0) {
      return true;
    }
    for (let i = 0; i < shop.foods.length; i++) {
      if (shop.foods[i].name.indexOf(keyword) >= 0) {
        return true;
      }
    }
    return false;
  }

  private matchesHomeCategory(shop: ShopItem): boolean {
    if (this.selectedHomeCategory === '全部') {
      return true;
    }
    if (shop.tags.indexOf(this.selectedHomeCategory) >= 0) {
      return true;
    }
    for (let i = 0; i < shop.foods.length; i++) {
      if (shop.foods[i].category === this.selectedHomeCategory) {
        return true;
      }
    }
    return false;
  }

  private getCurrentShop(): ShopItem {
    for (let i = 0; i < this.shops.length; i++) {
      if (this.shops[i].id === this.selectedShopId) {
        return this.shops[i];
      }
    }
    return this.shops[0];
  }

  private getMenuCategories(): string[] {
    let result: string[] = ['全部'];
    let shop: ShopItem = this.getCurrentShop();
    for (let i = 0; i < shop.foods.length; i++) {
      let category: string = shop.foods[i].category;
      if (result.indexOf(category) < 0) {
        result.push(category);
      }
    }
    return result;
  }

  private getVisibleFoods(): FoodItem[] {
    let result: FoodItem[] = [];
    let shop: ShopItem = this.getCurrentShop();
    for (let i = 0; i < shop.foods.length; i++) {
      let food: FoodItem = shop.foods[i];
      if (this.selectedMenuCategory === '全部' || food.category === this.selectedMenuCategory) {
        result.push(food);
      }
    }
    return result;
  }

  private getShopMinPrice(shop: ShopItem): number {
    let minPrice: number = 999;
    for (let i = 0; i < shop.foods.length; i++) {
      if (shop.foods[i].price < minPrice) {
        minPrice = shop.foods[i].price;
      }
    }
    return minPrice;
  }

  private openShop(shopId: string): void {
    this.selectedShopId = shopId;
    this.selectedMenuCategory = '全部';
    this.currentView = AppView.Menu;
  }

  private addFood(food: FoodItem): void {
    let shop: ShopItem = this.getCurrentShop();
    let next: CartLine[] = [];
    let found: boolean = false;
    for (let i = 0; i < this.cartLines.length; i++) {
      let line: CartLine = this.cartLines[i];
      if (line.foodId === food.id) {
        let updated: CartLine = {
          id: line.id,
          shopId: line.shopId,
          shopName: line.shopName,
          foodId: line.foodId,
          foodName: line.foodName,
          price: line.price,
          count: clampFoodCount(line.count + 1)
        };
        next.push(updated);
        found = true;
      } else {
        next.push(line);
      }
    }
    if (!found) {
      let added: CartLine = {
        id: 'cart_' + food.id,
        shopId: food.shopId,
        shopName: shop.name,
        foodId: food.id,
        foodName: food.name,
        price: food.price,
        count: 1
      };
      next.push(added);
    }
    this.cartLines = next;
    this.updateAndSave();
  }

  private changeFoodCount(foodId: string, delta: number): void {
    let next: CartLine[] = [];
    for (let i = 0; i < this.cartLines.length; i++) {
      let line: CartLine = this.cartLines[i];
      if (line.foodId === foodId) {
        let newCount: number = clampFoodCount(line.count + delta);
        if (newCount > 0) {
          let updated: CartLine = {
            id: line.id,
            shopId: line.shopId,
            shopName: line.shopName,
            foodId: line.foodId,
            foodName: line.foodName,
            price: line.price,
            count: newCount
          };
          next.push(updated);
        }
      } else {
        next.push(line);
      }
    }
    this.cartLines = next;
    this.updateAndSave();
  }

  private setFoodCount(foodId: string, count: number): void {
    let c: number = count;
    if (c < 0) { c = 0; }
    if (c > MAX_FOOD_COUNT) { c = MAX_FOOD_COUNT; }
    let next: CartLine[] = [];
    let shop: ShopItem = this.getCurrentShop();
    let found: boolean = false;
    for (let i = 0; i < this.cartLines.length; i++) {
      let line: CartLine = this.cartLines[i];
      if (line.foodId === foodId) {
        if (c > 0) {
          next.push({ id: line.id, shopId: line.shopId, shopName: line.shopName, foodId: line.foodId, foodName: line.foodName, price: line.price, count: c });
        }
        found = true;
      } else { next.push(line); }
    }
    if (!found && c > 0) {
      let food: FoodItem | undefined = undefined;
      for (let i = 0; i < shop.foods.length; i++) { if (shop.foods[i].id === foodId) { food = shop.foods[i]; break; } }
      if (food !== undefined) {
        next.push({ id: 'cart_' + foodId, shopId: food.shopId, shopName: shop.name, foodId: food.id, foodName: food.name, price: food.price, count: c });
      }
    }
    this.cartLines = next;
    this.updateAndSave();
  }

  private setCartLineCount(lineId: string, count: number): void {
    let c: number = count;
    if (c < 0) { c = 0; }
    if (c > MAX_FOOD_COUNT) { c = MAX_FOOD_COUNT; }
    let next: CartLine[] = [];
    for (let i = 0; i < this.cartLines.length; i++) {
      let line: CartLine = this.cartLines[i];
      if (line.id === lineId) {
        if (c > 0) {
          next.push({ id: line.id, shopId: line.shopId, shopName: line.shopName, foodId: line.foodId, foodName: line.foodName, price: line.price, count: c });
        }
      } else { next.push(line); }
    }
    this.cartLines = next;
    this.updateAndSave();
  }

  private getFoodCount(foodId: string): number {
    for (let i = 0; i < this.cartLines.length; i++) {
      if (this.cartLines[i].foodId === foodId) {
        return this.cartLines[i].count;
      }
    }
    return 0;
  }

  private getCartCount(): number {
    let count: number = 0;
    for (let i = 0; i < this.cartLines.length; i++) {
      count += this.cartLines[i].count;
    }
    return count;
  }

  private getCartSubtotal(): number {
    let total: number = 0;
    for (let i = 0; i < this.cartLines.length; i++) {
      total += this.cartLines[i].price * this.cartLines[i].count;
    }
    return total;
  }

  private getServiceFee(): number {
    if (this.getCartCount() === 0) {
      return 0;
    }
    return 1;
  }

  private getCartTotal(): number {
    return this.getCartSubtotal() + this.getServiceFee();
  }

  private groupCartByShop(): Map<string, CartLine[]> {
    let groups: Map<string, CartLine[]> = new Map();
    for (let i = 0; i < this.cartLines.length; i++) { let line = this.cartLines[i]; let g = groups.get(line.shopId); if (g === undefined) { g = []; groups.set(line.shopId, g); } g.push(line); }
    return groups;
  }

  private submitOrder(): void {
    if (this.cartLines.length === 0) { return; }
    this.showOrderConfirm = false;
    let shopGroups: Map<string, CartLine[]> = this.groupCartByShop();
    let now: number = Date.now();
    let pickupTime: number = now + this.selectedPickupMinutes * 60 * 1000;
    let newOrders: OrderRecord[] = [];
    let groupCount: number = 0;
    shopGroups.forEach((lines: CartLine[], shopId: string): void => {
      let orderItems: OrderLine[] = [];
      let subtotal: number = 0;
      for (let i = 0; i < lines.length; i++) { let line = lines[i]; orderItems.push({ foodId: line.foodId, foodName: line.foodName, price: line.price, count: line.count }); subtotal += line.price * line.count; }
      let orderId: string = generateOrderId() + '_' + groupCount.toString();
      groupCount++;
      let order: OrderRecord = { id: orderId, shopId: shopId, shopName: lines[0].shopName, items: orderItems, subtotal: subtotal, serviceFee: 1, total: subtotal + 1, status: OrderStatus.Ready, createdAt: now, pickupTime: pickupTime, pickupCode: generatePickupCode(), note: groupCount === 1 ? this.orderNote : this.orderNote + ' [分单' + groupCount.toString() + ']' };
      newOrders.push(order);
    });
    let nextOrders: OrderRecord[] = [];
    for (let i = 0; i < newOrders.length; i++) { nextOrders.push(newOrders[i]); }
    for (let i = 0; i < this.orders.length; i++) { nextOrders.push(this.orders[i]); }
    this.orders = nextOrders;
    for (let oi = 0; oi < newOrders.length; oi++) {
      let o = newOrders[oi];
      console.info('[下单] ' + o.shopName + ' ' + o.items.length.toString() + '件 ¥' + o.total.toFixed(0) + ' 取餐码' + o.pickupCode);
    }
    this.cartLines = [];
    this.orderNote = '';
    this.orderFilter = OrderFilter.Ready;
    this.currentView = AppView.Orders;
    this.updateAndSave();
  }

  private createPickupCode(seed: number): string {
    let code: number = 1000 + seed % 9000;
    return code.toString();
  }

  private updateOrderStatus(orderId: string, status: OrderStatus): void {
    let next: OrderRecord[] = [];
    for (let i = 0; i < this.orders.length; i++) {
      let order: OrderRecord = this.orders[i];
      if (order.id === orderId) {
        let updated: OrderRecord = {
          id: order.id,
          shopId: order.shopId,
          shopName: order.shopName,
          items: order.items,
          subtotal: order.subtotal,
          serviceFee: order.serviceFee,
          total: order.total,
          status: status,
          createdAt: order.createdAt,
          pickupTime: order.pickupTime,
          pickupCode: order.pickupCode,
          note: order.note
        };
        next.push(updated);
      } else {
        next.push(order);
      }
    }
    this.orders = next;
    this.updateAndSave();
  }

  private removeOrder(orderId: string): void {
    let next: OrderRecord[] = [];
    for (let i = 0; i < this.orders.length; i++) {
      if (this.orders[i].id !== orderId) {
        next.push(this.orders[i]);
      }
    }
    this.orders = next;
    this.updateAndSave();
  }

  private repeatOrder(order: OrderRecord): void {
    let next: CartLine[] = [];
    for (let i = 0; i < this.cartLines.length; i++) {
      next.push(this.cartLines[i]);
    }
    for (let j = 0; j < order.items.length; j++) {
      let item: OrderLine = order.items[j];
      let line: CartLine = {
        id: 'cart_' + item.foodId,
        shopId: order.shopId,
        shopName: order.shopName,
        foodId: item.foodId,
        foodName: item.foodName,
        price: item.price,
        count: item.count
      };
      next.push(line);
    }
    this.cartLines = this.mergeCart(next);
    this.currentView = AppView.Cart;
    this.updateAndSave();
  }

  private mergeCart(lines: CartLine[]): CartLine[] {
    let result: CartLine[] = [];
    for (let i = 0; i < lines.length; i++) {
      let source: CartLine = lines[i];
      let merged: boolean = false;
      let next: CartLine[] = [];
      for (let j = 0; j < result.length; j++) {
        let item: CartLine = result[j];
        if (item.foodId === source.foodId) {
          let updated: CartLine = {
            id: item.id,
            shopId: item.shopId,
            shopName: item.shopName,
            foodId: item.foodId,
            foodName: item.foodName,
            price: item.price,
            count: item.count + source.count
          };
          next.push(updated);
          merged = true;
        } else {
          next.push(item);
        }
      }
      if (!merged) {
        next.push(source);
      }
      result = next;
    }
    return result;
  }

  private getFilteredOrders(): OrderRecord[] {
    let result: OrderRecord[] = [];
    for (let i = 0; i < this.orders.length; i++) {
      let order: OrderRecord = this.orders[i];
      if (this.orderFilter === OrderFilter.All ||
        (this.orderFilter === OrderFilter.Ready && order.status === OrderStatus.Ready) ||
        (this.orderFilter === OrderFilter.Completed && order.status === OrderStatus.Completed) ||
        (this.orderFilter === OrderFilter.Cancelled && order.status === OrderStatus.Cancelled)) {
        result.push(order);
      }
    }
    return result;
  }

  private getReadyOrders(): OrderRecord[] {
    let result: OrderRecord[] = [];
    for (let i = 0; i < this.orders.length; i++) {
      if (this.orders[i].status === OrderStatus.Ready) {
        result.push(this.orders[i]);
      }
    }
    return result;
  }

  private getStatusText(status: OrderStatus): string {
    if (status === OrderStatus.Ready) {
      return '待取餐';
    }
    if (status === OrderStatus.Completed) {
      return '已完成';
    }
    return '已取消';
  }

  private getStatusColor(status: OrderStatus): string {
    if (status === OrderStatus.Ready) {
      return UiColors.PRIMARY;
    }
    if (status === OrderStatus.Completed) {
      return UiColors.GREEN;
    }
    return UiColors.MUTED;
  }

  private formatPrice(value: number): string {
    return '¥' + value.toFixed(0);
  }

  private padNumber(value: number): string {
    if (value < 10) {
      return '0' + value.toString();
    }
    return value.toString();
  }

  private formatTime(value: number): string {
    let date: Date = new Date(value);
    return this.padNumber(date.getHours()) + ':' + this.padNumber(date.getMinutes());
  }

  private getOrderItemSummary(order: OrderRecord): string {
    if (order.items.length === 0) {
      return '';
    }
    let first: OrderLine = order.items[0];
    if (order.items.length === 1) {
      return first.foodName + ' ×' + first.count.toString();
    }
    return first.foodName + ' 等 ' + order.items.length.toString() + ' 件';
  }

  private getCompletedOrderCount(): number {
    let count: number = 0;
    for (let i = 0; i < this.orders.length; i++) {
      if (this.orders[i].status === OrderStatus.Completed) {
        count++;
      }
    }
    return count;
  }

  private getUserInitial(): string {
    let name: string = this.userName.trim();
    if (name.length === 0) {
      return '我';
    }
    return name.substring(0, 1);
  }

  private openProfileEdit(): void {
    this.draftName = this.userName;
    this.draftPhone = this.userPhone;
    this.draftLocation = this.userLocation;
    this.profileMessage = '';
    this.currentView = AppView.ProfileEdit;
  }

  private closeProfileEdit(): void {
    this.profileMessage = '';
    this.currentView = AppView.Profile;
  }

  private openPasswordEdit(): void {
    this.oldPassword = '';
    this.newPassword = '';
    this.confirmPassword = '';
    this.passwordMessage = '';
    this.currentView = AppView.ProfilePassword;
  }

  private closePasswordEdit(): void {
    this.oldPassword = '';
    this.newPassword = '';
    this.confirmPassword = '';
    this.passwordMessage = '';
    this.currentView = AppView.Profile;
  }

  private saveProfile(): void {
    let nextPhone: string = this.draftPhone.trim();
    if (nextPhone.length === 0) {
      this.profileMessage = '请输入联系电话';
      return;
    }
    let existing: UserAccount | undefined = this.findUser(nextPhone);
    if (existing !== undefined && nextPhone !== this.currentPhone) {
      this.profileMessage = '该手机号已绑定其他账号';
      return;
    }
    this.userName = this.draftName.trim().length > 0 ? this.draftName.trim() : '校园用户';
    this.userPhone = nextPhone;
    this.userLocation = this.draftLocation.trim().length > 0 ? this.draftLocation.trim() : '校内自取点';
    this.syncCurrentAccount();
    this.profileMessage = '';
    this.currentView = AppView.Profile;
    this.updateAndSave();
  }

  private async savePassword(): Promise<void> {
    let oldValue: string = this.oldPassword.trim();
    let nextValue: string = this.newPassword.trim();
    let confirmValue: string = this.confirmPassword.trim();
    if (oldValue.length === 0 || nextValue.length === 0 || confirmValue.length === 0) {
      this.passwordMessage = '请完整填写密码信息';
      return;
    }
    if (nextValue.length < 6) {
      this.passwordMessage = '新密码至少 6 位';
      return;
    }
    if (nextValue !== confirmValue) {
      this.passwordMessage = '两次输入的新密码不一致';
      return;
    }
    let currentAccount: UserAccount | undefined = this.findUser(this.currentPhone);
    if (currentAccount === undefined) { this.passwordMessage = '账号不存在'; return; }
    let oldMatch: boolean = await verifyPassword(oldValue, currentAccount.password);
    if (!oldMatch) { this.passwordMessage = '原密码不正确'; return; }
    let nextUsers: UserAccount[] = [];
    for (let i = 0; i < this.users.length; i++) {
      let account: UserAccount = this.users[i];
      if (account.phone === this.currentPhone) {
        let updated: UserAccount = {
          phone: account.phone,
          password: await hashPassword(nextValue),
          name: account.name,
          location: account.location,
          createdAt: account.createdAt
        };
        nextUsers.push(updated);
      } else {
        nextUsers.push(account);
      }
    }
    this.users = nextUsers;
    this.oldPassword = '';
    this.newPassword = '';
    this.confirmPassword = '';
    this.passwordMessage = '';
    this.currentView = AppView.Profile;
    this.updateAndSave();
  }

  private shouldShowBottomNav(): boolean {
    return this.loggedIn && (this.currentView === AppView.Home || this.currentView === AppView.Orders ||
      this.currentView === AppView.Pickup || this.currentView === AppView.Profile);
  }

  build() {
    Column() {
      Column() {
        if (!this.loggedIn || this.currentView === AppView.Auth) {
          this.AuthView()
        } else if (this.currentView === AppView.Home) {
          this.HomeView()
        } else if (this.currentView === AppView.Menu) {
          this.MenuView()
        } else if (this.currentView === AppView.Cart) {
          this.CartView()
        } else if (this.currentView === AppView.Orders) {
          this.OrdersView()
        } else if (this.currentView === AppView.Pickup) {
          this.PickupView()
        } else if (this.currentView === AppView.ProfileEdit) {
          this.ProfileEditView()
        } else if (this.currentView === AppView.ProfilePassword) {
          this.ProfilePasswordView()
        } else {
          this.ProfileView()
        }
      }
      .width('100%')
      .layoutWeight(1)
      .align(Alignment.Top)
      .justifyContent(FlexAlign.Start)

      if (this.shouldShowBottomNav()) {
        this.BottomNav()
      }

      if (this.countEditorVisible) {
        Stack({ alignContent: Alignment.Center }) {
          Column() {
            Text('输入数量 (1-' + MAX_FOOD_COUNT.toString() + ')').fontSize(16).fontWeight(FontWeight.Bold)
            TextInput({ text: this.countEditorValue })
              .fontSize(24).textAlign(TextAlign.Center)
              .width(120).height(48).backgroundColor('#F8FAFC')
              .borderRadius(12).border({ width: 1, color: UiColors.LINE }).margin({ top: 12, bottom: 16 })
              .onChange((value: string) => { this.countEditorValue = value; })
            Row({ space: 16 }) {
              Button('取消').height(40).layoutWeight(1).backgroundColor('#F3F4F6').fontColor(UiColors.SUB_TEXT)
                .onClick(() => { this.countEditorVisible = false; })
              Button('确定').height(40).layoutWeight(1).backgroundColor(UiColors.PRIMARY).fontColor('#FFFFFF')
                .onClick(() => {
                  let v: string = this.countEditorValue.replace(/[^0-9]/g, '');
                  let n: number = parseInt(v);
                  if (!isNaN(n)) {
                    if (n < 1) { n = 1; }
                    if (n > MAX_FOOD_COUNT) { n = MAX_FOOD_COUNT; }
                    if (this.countEditorMode === 'cart') { this.setCartLineCount(this.countEditorTargetId, n === 0 ? 0 : n); }
                    else { this.setFoodCount(this.countEditorTargetId, n); }
                  }
                  this.countEditorVisible = false;
                })
            }.width('100%')
          }.padding(24).backgroundColor('#FFFFFF').borderRadius(20).width('80%')
          .shadow({ radius: 20, color: '#00000030' })
        }
        .width('100%').height('100%')
        .backgroundColor('#00000050')
        .position({ x: 0, y: 0 })
      }
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(UiColors.PAGE)
  }

  @Builder
  AuthView() {
    Column() {
      Scroll() {
        Column({ space: 18 }) {
          Stack({ alignContent: Alignment.BottomStart }) {
            Image($r('app.media.img_banner_canteen'))
              .width('100%')
              .height(210)
              .objectFit(ImageFit.Cover)
              .borderRadius(24)
            Column({ space: 8 }) {
              Text('校园食堂')
                .fontSize(30)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
              Text('提前点餐，到点即取')
                .fontSize(15)
                .fontColor('#FFFFFF')
            }
            .width('100%')
            .padding({ left: 20, right: 20, bottom: 20 })
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .height(210)
          .margin({ top: 24 })

          Row() {
            Text('登录')
              .fontSize(16)
              .fontWeight(this.authMode === AuthMode.Login ? FontWeight.Bold : FontWeight.Regular)
              .fontColor(this.authMode === AuthMode.Login ? '#FFFFFF' : UiColors.SUB_TEXT)
              .layoutWeight(1)
              .height(42)
              .textAlign(TextAlign.Center)
              .backgroundColor(this.authMode === AuthMode.Login ? UiColors.PRIMARY : '#FFFFFF')
              .borderRadius(21)
              .onClick(() => {
                this.authMode = AuthMode.Login;
                this.authMessage = '';
              })
            Text('注册')
              .fontSize(16)
              .fontWeight(this.authMode === AuthMode.Register ? FontWeight.Bold : FontWeight.Regular)
              .fontColor(this.authMode === AuthMode.Register ? '#FFFFFF' : UiColors.SUB_TEXT)
              .layoutWeight(1)
              .height(42)
              .textAlign(TextAlign.Center)
              .backgroundColor(this.authMode === AuthMode.Register ? UiColors.PRIMARY : '#FFFFFF')
              .borderRadius(21)
              .onClick(() => {
                this.authMode = AuthMode.Register;
                this.authMessage = '';
              })
          }
          .width('100%')
          .padding(4)
          .backgroundColor('#FFFFFF')
          .borderRadius(24)
          .border({ width: 1, color: UiColors.LINE })

          Column({ space: 12 }) {
            if (this.authMode === AuthMode.Login) {
              Text('欢迎回来')
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor(UiColors.TEXT)
                .width('100%')
              Text('登录后可继续查看购物车和取餐码')
                .fontSize(14)
                .fontColor(UiColors.SUB_TEXT)
                .width('100%')

              TextInput({ placeholder: '手机号', text: this.authPhone })
                .height(48)
                .width('100%')
                .fontSize(15)
                .backgroundColor('#F8FAFC')
                .borderRadius(16)
                .padding({ left: 14, right: 14 })
                .border({ width: 1, color: UiColors.LINE })
                .onChange((value: string) => {
                  this.authPhone = value;
                })
              TextInput({ placeholder: '密码', text: this.authPassword })
                .height(48)
                .width('100%')
                .fontSize(15)
                .type(InputType.Password)
                .backgroundColor('#F8FAFC')
                .borderRadius(16)
                .padding({ left: 14, right: 14 })
                .border({ width: 1, color: UiColors.LINE })
                .onChange((value: string) => {
                  this.authPassword = value;
                })

              if (this.authMessage.length > 0) {
                Text(this.authMessage)
                  .fontSize(13)
                  .fontColor(UiColors.DANGER)
                  .width('100%')
              }

              Button('登录')
                .height(50)
                .width('100%')
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor(UiColors.PRIMARY)
                .borderRadius(25)
                .onClick(() => {
                  this.login();
                })
            } else {
              Text('创建账号')
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor(UiColors.TEXT)
                .width('100%')
              Text('用于保存你的订单、购物车和常用取餐点')
                .fontSize(14)
                .fontColor(UiColors.SUB_TEXT)
                .width('100%')

              TextInput({ placeholder: '姓名', text: this.registerName })
                .height(48)
                .width('100%')
                .fontSize(15)
                .backgroundColor('#F8FAFC')
                .borderRadius(16)
                .padding({ left: 14, right: 14 })
                .border({ width: 1, color: UiColors.LINE })
                .onChange((value: string) => {
                  this.registerName = value;
                })
              TextInput({ placeholder: '手机号', text: this.registerPhone })
                .height(48)
                .width('100%')
                .fontSize(15)
                .backgroundColor('#F8FAFC')
                .borderRadius(16)
                .padding({ left: 14, right: 14 })
                .border({ width: 1, color: UiColors.LINE })
                .onChange((value: string) => {
                  this.registerPhone = value;
                })
              TextInput({ placeholder: '密码，至少 6 位', text: this.registerPassword })
                .height(48)
                .width('100%')
                .fontSize(15)
                .type(InputType.Password)
                .backgroundColor('#F8FAFC')
                .borderRadius(16)
                .padding({ left: 14, right: 14 })
                .border({ width: 1, color: UiColors.LINE })
                .onChange((value: string) => {
                  this.registerPassword = value;
                })
              TextInput({ placeholder: '常用取餐点', text: this.registerLocation })
                .height(48)
                .width('100%')
                .fontSize(15)
                .backgroundColor('#F8FAFC')
                .borderRadius(16)
                .padding({ left: 14, right: 14 })
                .border({ width: 1, color: UiColors.LINE })
                .onChange((value: string) => {
                  this.registerLocation = value;
                })

              if (this.authMessage.length > 0) {
                Text(this.authMessage)
                  .fontSize(13)
                  .fontColor(UiColors.DANGER)
                  .width('100%')
              }

              Button('注册并进入')
                .height(50)
                .width('100%')
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor(UiColors.PRIMARY)
                .borderRadius(25)
                .onClick(() => {
                  this.register();
                })
            }
          }
          .width('100%')
          .padding(18)
          .backgroundColor(UiColors.SURFACE)
          .borderRadius(22)
          .border({ width: 1, color: UiColors.LINE })
        }
        .width('100%')
        .padding({ left: 18, right: 18, bottom: 24 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
      .layoutWeight(1)
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(UiColors.PAGE)
  }

  @Builder
  HomeView() {
    Column() {
      Scroll() {
        Column({ space: 14 }) {
        Column({ space: 4 }) {
          Row() {
            Column({ space: 4 }) {
              Text('校园食堂')
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor(UiColors.TEXT)
              Text(this.userLocation)
                .fontSize(13)
                .fontColor(UiColors.SUB_TEXT)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .layoutWeight(1)
            .align(Alignment.Top)
            .alignItems(HorizontalAlign.Start)

            Text('自取')
              .fontSize(13)
              .fontColor(UiColors.GREEN)
              .padding({ left: 12, right: 12, top: 7, bottom: 7 })
              .backgroundColor(UiColors.GREEN_SOFT)
              .borderRadius(16)
          }
          .width('100%')

          Row({ space: 8 }) {
            TextInput({ placeholder: '搜索店铺或菜品', text: this.searchText })
              .height(42)
              .layoutWeight(1)
              .fontSize(14)
              .backgroundColor(UiColors.SURFACE)
              .borderRadius(22)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.searchText = value;
              })
            Button('搜索')
              .height(42)
              .width(72)
              .fontSize(14)
              .fontColor('#FFFFFF')
              .backgroundColor(UiColors.GREEN)
              .borderRadius(22)
          }
          .width('100%')
          .margin({ top: 14 })
        }
        .width('100%')
        .padding({ top: 20 })

        Stack({ alignContent: Alignment.BottomStart }) {
          Image($r('app.media.img_banner_canteen'))
            .width('100%')
            .height(150)
            .objectFit(ImageFit.Cover)
            .borderRadius(20)
          Column({ space: 7 }) {
            Text('清爽一夏')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
            Text('热餐现做，到点即取')
              .fontSize(14)
              .fontColor('#FFFFFF')
            Text('当季推荐')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .backgroundColor(UiColors.GREEN)
              .borderRadius(14)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding({ left: 18, right: 18, bottom: 16 })
        }
        .width('100%')
        .height(150)
        .backgroundColor('#DDEFE5')
        .borderRadius(20)
        .border({ width: 1, color: '#D7EFDF' })

        Scroll() {
          Row({ space: 10 }) {
            ForEach(this.getHomeCategories(), (category: string) => {
              Text(category)
                .fontSize(14)
                .fontWeight(this.selectedHomeCategory === category ? FontWeight.Bold : FontWeight.Regular)
                .fontColor(this.selectedHomeCategory === category ? UiColors.GREEN : UiColors.SUB_TEXT)
                .padding({ left: 14, right: 14, top: 9, bottom: 9 })
                .backgroundColor(this.selectedHomeCategory === category ? UiColors.GREEN_SOFT : UiColors.SURFACE)
                .borderRadius(18)
                .border({ width: 1, color: this.selectedHomeCategory === category ? '#BFE8D0' : UiColors.LINE })
                .onClick(() => {
                  this.selectedHomeCategory = category;
                })
            }, (category: string) => category + '_' + this.refreshKey.toString())
          }
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')

        Row() {
          Text('推荐店铺')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiColors.TEXT)
          Blank()
          Text(this.getVisibleShops().length.toString() + ' 家可选')
            .fontSize(13)
            .fontColor(UiColors.SUB_TEXT)
        }
        .width('100%')

        Column({ space: 12 }) {
          ForEach(this.getVisibleShops(), (shop: ShopItem) => {
            Row({ space: 14 }) {
              Image(this.getShopImageResource(shop.id))
                .objectFit(ImageFit.Cover)
              .width(86)
              .height(86)
              .borderRadius(14)

              Column({ space: 8 }) {
                Row() {
                  Text(shop.name)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(UiColors.TEXT)
                    .layoutWeight(1)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(shop.score + ' 分')
                    .fontSize(12)
                    .fontColor(UiColors.PRIMARY)
                }
                .width('100%')

                Text('月售 ' + shop.monthly + ' · 评分 ' + shop.score)
                  .fontSize(13)
                  .fontColor(UiColors.SUB_TEXT)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Row() {
                  Text('月售 ' + shop.monthly)
                    .fontSize(12)
                    .fontColor(UiColors.SUB_TEXT)
                  Blank()
                  Text('起取 ' + this.formatPrice(this.getShopMinPrice(shop)))
                    .fontSize(12)
                    .fontColor(UiColors.SUB_TEXT)
                }
                .width('100%')

                Row({ space: 6 }) {
                  ForEach(shop.tags, (tag: string) => {
                    Text(tag)
                      .fontSize(11)
                      .fontColor(UiColors.GREEN)
                      .padding({ left: 7, right: 7, top: 3, bottom: 3 })
                      .backgroundColor(UiColors.GREEN_SOFT)
                      .borderRadius(10)
                  }, (tag: string) => tag + '_' + shop.id + '_' + this.refreshKey.toString())
                }
              }
              .layoutWeight(1)
              .align(Alignment.Top)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .padding(14)
            .backgroundColor(UiColors.SURFACE)
            .borderRadius(18)
            .border({ width: 1, color: UiColors.LINE })
            .onClick(() => {
              this.openShop(shop.id);
            })
          }, (shop: ShopItem) => shop.id + '_' + this.refreshKey.toString())
        }
        .width('100%')

        if (this.getVisibleShops().length === 0) {
          Column({ space: 10 }) {
            Text('暂无匹配店铺')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(UiColors.TEXT)
            Text('换个关键词试试')
              .fontSize(14)
              .fontColor(UiColors.SUB_TEXT)
          }
          .width('100%')
          .padding(28)
          .backgroundColor(UiColors.SURFACE)
          .borderRadius(18)
          .border({ width: 1, color: UiColors.LINE })
        }
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 20 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
      .layoutWeight(1)
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  MenuView() {
    Column() {
      Row() {
        Text('‹')
          .fontSize(34)
          .fontColor(UiColors.TEXT)
          .width(42)
          .height(42)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.currentView = AppView.Home;
          })
        Column({ space: 3 }) {
          Text(this.getCurrentShop().name)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiColors.TEXT)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('热餐现做 · 到点即取')
            .fontSize(12)
            .fontColor(UiColors.SUB_TEXT)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .layoutWeight(1)
        .align(Alignment.Top)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ left: 10, right: 16, top: 14, bottom: 10 })
      .backgroundColor(UiColors.PAGE)

      Row() {
        Text('现点现做')
          .fontSize(12)
          .fontColor(UiColors.GREEN)
          .padding({ left: 9, right: 9, top: 5, bottom: 5 })
          .backgroundColor(UiColors.GREEN_SOFT)
          .borderRadius(12)
        Text('评分 ' + this.getCurrentShop().score)
          .fontSize(12)
          .fontColor(UiColors.SUB_TEXT)
          .margin({ left: 8 })
        Text('月售 ' + this.getCurrentShop().monthly)
          .fontSize(12)
          .fontColor(UiColors.SUB_TEXT)
          .margin({ left: 8 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })

      Stack({ alignContent: Alignment.BottomStart }) {
        Image(this.getShopImageResource(this.selectedShopId))
          .width('100%')
          .height(116)
          .objectFit(ImageFit.Cover)
          .borderRadius(18)
        Column({ space: 5 }) {
          Text(this.getCurrentShop().name)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
          Text('预计 15 分钟可取')
            .fontSize(13)
            .fontColor('#FFFFFF')
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 14 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .height(116)
      .padding({ left: 16, right: 16 })

      Row() {
        Column({ space: 8 }) {
          ForEach(this.getMenuCategories(), (category: string) => {
            Text(category)
              .fontSize(13)
              .fontWeight(this.selectedMenuCategory === category ? FontWeight.Bold : FontWeight.Regular)
              .fontColor(this.selectedMenuCategory === category ? UiColors.GREEN : UiColors.SUB_TEXT)
              .width('100%')
              .padding({ top: 12, bottom: 12 })
              .textAlign(TextAlign.Center)
              .backgroundColor(this.selectedMenuCategory === category ? UiColors.SURFACE : '#EEF1F4')
              .borderRadius(12)
              .onClick(() => {
                this.selectedMenuCategory = category;
              })
          }, (category: string) => category + '_' + this.refreshKey.toString())
        }
        .width(88)
        .height('100%')
        .align(Alignment.Top)
        .padding({ left: 12, right: 8, top: 12 })

        Scroll() {
          Column({ space: 10 }) {
            ForEach(this.getVisibleFoods(), (food: FoodItem) => {
              Row({ space: 12 }) {
                Image(this.getFoodImageResource(food))
                  .objectFit(ImageFit.Cover)
                .width(74)
                .height(74)
                .borderRadius(13)

                Column({ space: 6 }) {
                  Text(food.name)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(UiColors.TEXT)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(food.desc)
                    .fontSize(12)
                    .fontColor(UiColors.SUB_TEXT)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Row() {
                    Text(this.formatPrice(food.price))
                      .fontSize(18)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(UiColors.PRIMARY)
                    Blank()
                    if (this.getFoodCount(food.id) > 0) {
                      Text('-')
                        .fontSize(18)
                        .fontColor(UiColors.SUB_TEXT)
                        .width(30)
                        .height(30)
                        .textAlign(TextAlign.Center)
                        .backgroundColor('#F3F4F6')
                        .borderRadius(14)
                        .border({ width: 1, color: UiColors.LINE })
                        .onClick(() => { this.changeFoodCount(food.id, -1); })
                      Text(this.getFoodCount(food.id).toString())
                        .fontSize(14)
                        .fontColor(UiColors.TEXT)
                        .width(30)
                        .textAlign(TextAlign.Center)
                        .onClick(() => { this.countEditorTargetId = food.id; this.countEditorMode = 'food'; this.countEditorValue = this.getFoodCount(food.id).toString(); this.countEditorVisible = true; })
                    } else {
                      Text('0')
                        .fontSize(14)
                        .fontColor(UiColors.MUTED)
                        .width(30)
                        .textAlign(TextAlign.Center)
                    }
                    Text('+')
                      .fontSize(18)
                      .fontColor('#FFFFFF')
                      .width(30)
                      .height(30)
                      .textAlign(TextAlign.Center)
                      .backgroundColor(UiColors.PRIMARY)
                      .borderRadius(14)
                      .onClick(() => { this.addFood(food); })
                  }
                  .width('100%')
                }
                .layoutWeight(1)
                .align(Alignment.Top)
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .padding(12)
              .backgroundColor(UiColors.SURFACE)
              .borderRadius(16)
              .border({ width: 1, color: UiColors.LINE })
            }, (food: FoodItem) => food.id + '_' + this.refreshKey.toString())
          }
          .width('100%')
          .padding({ right: 14, top: 12, bottom: 18 })
        }
        .layoutWeight(1)
        .height('100%')
        .align(Alignment.Top)
      }
      .width('100%')
      .layoutWeight(1)
      .align(Alignment.Top)

      Row() {
        Row() {
          Image($r('app.media.ic_cart_active'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
          Column({ space: 2 }) {
            Text(this.formatPrice(this.getCartTotal()))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(UiColors.TEXT)
            Text('共 ' + this.getCartCount().toString() + ' 件（含服务费 ' + this.formatPrice(this.getServiceFee()) + '）')
              .fontSize(11)
              .fontColor(UiColors.SUB_TEXT)
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 10 })
        }
        .layoutWeight(1)

        Button('直接下单')
          .height(46)
          .width(112)
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor(this.getCartCount() > 0 ? UiColors.PRIMARY : '#C9CED6')
          .borderRadius(23)
          .enabled(this.getCartCount() > 0)
          .onClick(() => { this.confirmOrder(); })
      }
      .width('100%').padding({ left: 16, right: 16, top: 12, bottom: 16 })
      .backgroundColor(UiColors.SURFACE).border({ width: 1, color: UiColors.LINE })
      .onClick(() => { if (this.getCartCount() > 0) this.showCartPopup = true; })

      // ---- 购物车弹窗 ----
      if (this.showCartPopup) {
        Stack({ alignContent: Alignment.Bottom }) {
          Column() {
            Row() {
              Text('购物车').fontSize(16).fontWeight(FontWeight.Bold)
              Blank()
              Text('清空').fontSize(12).fontColor(UiColors.DANGER)
                .padding({ left: 10, right: 10, top: 5, bottom: 5 })
                .backgroundColor('#FFF0ED').borderRadius(10)
                .onClick(() => { this.clearCart(); })
              Text('✕').fontSize(18).fontColor(UiColors.MUTED).width(28).height(28)
                .textAlign(TextAlign.Center).margin({ left: 6 })
                .onClick(() => { this.showCartPopup = false; })
            }.width('100%').padding({ left: 4, right: 4, bottom: 8 })

            if (this.cartLines.length === 0) {
              Text('购物车为空').fontSize(14).fontColor(UiColors.SUB_TEXT).padding(16)
            } else {
              Scroll() {
                Column({ space: 6 }) {
                  ForEach(this.cartLines, (line: CartLine) => {
                    Row({ space: 8 }) {
                      Text(line.foodName).fontSize(13).fontWeight(FontWeight.Bold).fontColor(UiColors.TEXT).layoutWeight(1).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text(line.shopName).fontSize(11).fontColor(UiColors.SUB_TEXT).width(60).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text('-').fontSize(14).width(22).height(22).textAlign(TextAlign.Center).backgroundColor('#F3F4F6').borderRadius(11).onClick(() => { this.changeFoodCount(line.foodId, -1); })
                      Text(line.count.toString()).fontSize(13).width(24).textAlign(TextAlign.Center)
                        .onClick(() => { this.countEditorTargetId = line.id; this.countEditorMode = 'cart'; this.countEditorValue = line.count.toString(); this.countEditorVisible = true; })
                      Text('+').fontSize(14).width(22).height(22).textAlign(TextAlign.Center).backgroundColor(UiColors.PRIMARY).fontColor('#FFFFFF').borderRadius(11).onClick(() => { this.changeFoodCount(line.foodId, 1); })
                      Text(this.formatPrice(line.price * line.count)).fontSize(13).fontColor(UiColors.TEXT).width(44).textAlign(TextAlign.End)
                    }.width('100%').padding(6).backgroundColor('#F8FAFC').borderRadius(10)
                  }, (line: CartLine) => line.id + '_' + line.count.toString())
                }.width('100%')
              }.constraintSize({ maxHeight: 260 })
            }
          }
          .width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius({ topLeft: 16, topRight: 16 })
          .shadow({ radius: 10, color: '#00000020' })
        }
        .width('100%').height('100%').backgroundColor('#00000040')
        .position({ x: 0, y: 0 })
        .onClick(() => { this.showCartPopup = false; })
      }

      // ---- 下单确认弹窗 ----
      if (this.showOrderConfirm) {
        Stack({ alignContent: Alignment.Center }) {
          Column({ space: 16 }) {
            Text('确认下单').fontSize(20).fontWeight(FontWeight.Bold)
            Text('共 ' + this.getCartCount().toString() + ' 件，合计 ' + this.formatPrice(this.getCartTotal()))
              .fontSize(15).fontColor(UiColors.SUB_TEXT)
            Row({ space: 16 }) {
              Button('取消').layoutWeight(1).height(44).fontColor(UiColors.SUB_TEXT).backgroundColor('#F3F4F6').borderRadius(22)
                .onClick(() => { this.showOrderConfirm = false; })
              Button('确认下单').layoutWeight(1).height(44).fontColor('#FFFFFF').backgroundColor(UiColors.PRIMARY).borderRadius(22)
                .onClick(() => { this.submitOrder(); })
            }.width('100%')
          }.width('80%').padding(24).backgroundColor('#FFFFFF').borderRadius(20)
        }
        .width('100%').height('100%').backgroundColor('#00000050')
        .position({ x: 0, y: 0 })
      }
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(UiColors.PAGE)
  }

  @Builder
  CartView() {
    Column() {
      Row() {
        Text('‹')
          .fontSize(34)
          .fontColor(UiColors.TEXT)
          .width(42)
          .height(42)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.currentView = AppView.Menu;
          })
        Text('确认订单')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(UiColors.TEXT)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text(' ')
          .width(42)
      }
      .width('100%')
      .padding({ left: 10, right: 16, top: 14, bottom: 10 })

      if (this.cartLines.length === 0) {
        Column({ space: 14 }) {
          Text('购物车为空')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiColors.TEXT)
          Text('先挑选想吃的餐品')
            .fontSize(14)
            .fontColor(UiColors.SUB_TEXT)
          Button('去首页看看')
            .height(44)
            .width(130)
            .fontColor('#FFFFFF')
            .backgroundColor(UiColors.PRIMARY)
            .borderRadius(22)
            .onClick(() => {
              this.currentView = AppView.Home;
            })
        }
        .width('100%')
        .layoutWeight(1)
        .align(Alignment.Top)
        .padding({ top: 72 })
      } else {
        Scroll() {
          Column({ space: 12 }) {
            Column({ space: 10 }) {
              Text('取餐信息')
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor(UiColors.TEXT)
              Text(this.userLocation)
                .fontSize(14)
                .fontColor(UiColors.TEXT)
              Text('提交后约 15 分钟可凭取餐码自取')
                .fontSize(13)
                .fontColor(UiColors.SUB_TEXT)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .padding(16)
            .backgroundColor(UiColors.SURFACE)
            .borderRadius(18)
            .border({ width: 1, color: UiColors.LINE })

            Column({ space: 12 }) {
              Row() {
                Text('商品清单')
                  .fontSize(17)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.TEXT)
                Blank()
                Text(this.getCartCount().toString() + ' 件')
                  .fontSize(13)
                  .fontColor(UiColors.SUB_TEXT)
              }
              .width('100%')

              ForEach(this.cartLines, (line: CartLine) => {
                Row({ space: 12 }) {
                  Image(this.getCartLineImageResource(line))
                    .width(54)
                    .height(54)
                    .objectFit(ImageFit.Cover)
                    .borderRadius(12)
                  Column({ space: 5 }) {
                    Text(line.foodName)
                      .fontSize(15)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(UiColors.TEXT)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(line.shopName)
                      .fontSize(12)
                      .fontColor(UiColors.SUB_TEXT)
                  }
                  .layoutWeight(1)
                  .align(Alignment.Top)
                  .alignItems(HorizontalAlign.Start)

                  Text(this.formatPrice(line.price))
                    .fontSize(14)
                    .fontColor(UiColors.TEXT)
                    .width(48)
                    .textAlign(TextAlign.End)
                  Text('-')
                    .fontSize(18)
                    .fontColor(UiColors.SUB_TEXT)
                    .width(30)
                    .height(30)
                    .textAlign(TextAlign.Center)
                    .backgroundColor('#F3F4F6')
                    .borderRadius(14)
                    .border({ width: 1, color: UiColors.LINE })
                    .onClick(() => { this.changeFoodCount(line.foodId, -1); })
                  Text(line.count.toString())
                    .fontSize(15)
                    .fontColor(UiColors.TEXT)
                    .width(30)
                    .textAlign(TextAlign.Center)
                    .onClick(() => { this.countEditorTargetId = line.id; this.countEditorMode = 'cart'; this.countEditorValue = line.count.toString(); this.countEditorVisible = true; })
                  Text('+')
                    .fontSize(18)
                    .fontColor('#FFFFFF')
                    .width(30)
                    .height(30)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(UiColors.PRIMARY)
                    .borderRadius(14)
                    .onClick(() => { this.changeFoodCount(line.foodId, 1); })
                  Text('✕')
                    .fontSize(14)
                    .fontColor(UiColors.DANGER)
                    .width(26)
                    .height(26)
                    .textAlign(TextAlign.Center)
                    .borderRadius(13)
                    .onClick(() => { this.setCartLineCount(line.id, 0); })
                }
                .width('100%')
              }, (line: CartLine) => line.id)
            }
            .width('100%')
            .padding(16)
            .backgroundColor(UiColors.SURFACE)
            .borderRadius(18)
            .border({ width: 1, color: UiColors.LINE })

            TextInput({ placeholder: '口味、偏好等备注', text: this.orderNote })
              .width('100%')
              .height(48)
              .fontSize(14)
              .backgroundColor(UiColors.SURFACE)
              .borderRadius(16)
              .padding({ left: 14, right: 14 })
              .border({ width: 1, color: UiColors.LINE })
              .onChange((value: string) => {
                this.orderNote = value;
              })

            Column({ space: 10 }) {
              Row() {
                Text('商品金额')
                  .fontSize(14)
                  .fontColor(UiColors.SUB_TEXT)
                Blank()
                Text(this.formatPrice(this.getCartSubtotal()))
                  .fontSize(14)
                  .fontColor(UiColors.TEXT)
              }
              .width('100%')
              Row() {
                Text('打包服务')
                  .fontSize(14)
                  .fontColor(UiColors.SUB_TEXT)
                Blank()
                Text(this.formatPrice(this.getServiceFee()))
                  .fontSize(14)
                  .fontColor(UiColors.TEXT)
              }
              .width('100%')
              Row() {
                Text('合计')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.TEXT)
                Blank()
                Text(this.formatPrice(this.getCartTotal()))
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.PRIMARY)
              }
              .width('100%')
            }
            .width('100%')
            .padding(16)
            .backgroundColor(UiColors.SURFACE)
            .borderRadius(18)
            .border({ width: 1, color: UiColors.LINE })
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 18 })
        }
        .layoutWeight(1)
        .align(Alignment.Top)

        Button('提交订单')
          .width('100%')
          .height(50)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .backgroundColor(UiColors.PRIMARY)
          .borderRadius(25)
          .onClick(() => {
            this.submitOrder();
          })
          .margin({ top: 4 })
          .padding({ left: 16, right: 16 })
      }
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(UiColors.PAGE)
  }

  @Builder
  OrdersView() {
    Column() {
      Text('我的订单')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(UiColors.TEXT)
        .width('100%')
        .padding({ left: 16, right: 16, top: 22, bottom: 10 })

      Row({ space: 8 }) {
        Text('全部')
          .fontSize(14)
          .fontColor(this.orderFilter === OrderFilter.All ? '#FFFFFF' : UiColors.SUB_TEXT)
          .padding({ left: 13, right: 13, top: 8, bottom: 8 })
          .backgroundColor(this.orderFilter === OrderFilter.All ? UiColors.PRIMARY : UiColors.SURFACE)
          .borderRadius(16)
          .border({ width: 1, color: this.orderFilter === OrderFilter.All ? UiColors.PRIMARY : UiColors.LINE })
          .onClick(() => {
            this.orderFilter = OrderFilter.All;
          })
        Text('待取餐')
          .fontSize(14)
          .fontColor(this.orderFilter === OrderFilter.Ready ? '#FFFFFF' : UiColors.SUB_TEXT)
          .padding({ left: 13, right: 13, top: 8, bottom: 8 })
          .backgroundColor(this.orderFilter === OrderFilter.Ready ? UiColors.PRIMARY : UiColors.SURFACE)
          .borderRadius(16)
          .border({ width: 1, color: this.orderFilter === OrderFilter.Ready ? UiColors.PRIMARY : UiColors.LINE })
          .onClick(() => {
            this.orderFilter = OrderFilter.Ready;
          })
        Text('已完成')
          .fontSize(14)
          .fontColor(this.orderFilter === OrderFilter.Completed ? '#FFFFFF' : UiColors.SUB_TEXT)
          .padding({ left: 13, right: 13, top: 8, bottom: 8 })
          .backgroundColor(this.orderFilter === OrderFilter.Completed ? UiColors.PRIMARY : UiColors.SURFACE)
          .borderRadius(16)
          .border({ width: 1, color: this.orderFilter === OrderFilter.Completed ? UiColors.PRIMARY : UiColors.LINE })
          .onClick(() => {
            this.orderFilter = OrderFilter.Completed;
          })
        Text('已取消')
          .fontSize(14)
          .fontColor(this.orderFilter === OrderFilter.Cancelled ? '#FFFFFF' : UiColors.SUB_TEXT)
          .padding({ left: 13, right: 13, top: 8, bottom: 8 })
          .backgroundColor(this.orderFilter === OrderFilter.Cancelled ? UiColors.PRIMARY : UiColors.SURFACE)
          .borderRadius(16)
          .border({ width: 1, color: this.orderFilter === OrderFilter.Cancelled ? UiColors.PRIMARY : UiColors.LINE })
          .onClick(() => {
            this.orderFilter = OrderFilter.Cancelled;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 10 })

      if (this.getFilteredOrders().length === 0) {
        Column({ space: 12 }) {
          Text('暂无订单')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiColors.TEXT)
          Text('下单后可在这里查看取餐码')
            .fontSize(14)
            .fontColor(UiColors.SUB_TEXT)
          Button('去点餐')
            .height(44)
            .width(110)
            .fontColor('#FFFFFF')
            .backgroundColor(UiColors.PRIMARY)
            .borderRadius(22)
            .onClick(() => {
              this.currentView = AppView.Home;
            })
        }
        .width('100%')
        .layoutWeight(1)
        .align(Alignment.Top)
        .padding({ top: 72, left: 16, right: 16 })
      } else {
        Scroll() {
          Column({ space: 12 }) {
            ForEach(this.getFilteredOrders(), (order: OrderRecord) => {
              Column({ space: 12 }) {
                Row() {
                  Column({ space: 4 }) {
                    Text(order.shopName)
                      .fontSize(17)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(UiColors.TEXT)
                    Text('下单时间 ' + this.formatTime(order.createdAt))
                      .fontSize(12)
                      .fontColor(UiColors.SUB_TEXT)
                  }
                  .layoutWeight(1)
                  .align(Alignment.Top)
                  .alignItems(HorizontalAlign.Start)
                  Text(this.getStatusText(order.status))
                    .fontSize(13)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(this.getStatusColor(order.status))
                }
                .width('100%')

                ForEach(order.items, (item: OrderLine) => {
                  Row() {
                    Text(item.foodName)
                      .fontSize(14)
                      .fontColor(UiColors.TEXT)
                      .layoutWeight(1)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text('×' + item.count.toString())
                      .fontSize(13)
                      .fontColor(UiColors.SUB_TEXT)
                      .width(34)
                      .textAlign(TextAlign.Center)
                    Text(this.formatPrice(item.price * item.count))
                      .fontSize(14)
                      .fontColor(UiColors.TEXT)
                      .width(58)
                      .textAlign(TextAlign.End)
                  }
                  .width('100%')
                }, (item: OrderLine) => order.id + '_' + item.foodId + '_' + this.refreshKey.toString())

                Row() {
                  Text('合计')
                    .fontSize(14)
                    .fontColor(UiColors.SUB_TEXT)
                  Blank()
                  Text(this.formatPrice(order.total))
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(UiColors.TEXT)
                }
                .width('100%')

                if (order.status === OrderStatus.Ready) {
                  Column({ space: 4 }) {
                    Text('取餐码')
                      .fontSize(13)
                      .fontColor(UiColors.SUB_TEXT)
                    Text(order.pickupCode)
                      .fontSize(34)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(UiColors.PRIMARY)
                    Text('请在 ' + this.formatTime(order.pickupTime) + ' 前往取餐')
                      .fontSize(12)
                      .fontColor(UiColors.SUB_TEXT)
                  }
                  .width('100%')
                  .padding(14)
                  .backgroundColor(UiColors.SURFACE_SOFT)
                  .borderRadius(16)
                }

                Row({ space: 10 }) {
                  if (order.status === OrderStatus.Ready) {
                    Button('取消订单')
                      .height(40)
                      .layoutWeight(1)
                      .fontSize(14)
                      .fontColor(UiColors.SUB_TEXT)
                      .backgroundColor('#FFFFFF')
                      .borderRadius(20)
                      .border({ width: 1, color: UiColors.LINE })
                      .onClick(() => {
                        this.updateOrderStatus(order.id, OrderStatus.Cancelled);
                      })
                    Button('确认取餐')
                      .height(40)
                      .layoutWeight(1)
                      .fontSize(14)
                      .fontColor('#FFFFFF')
                      .backgroundColor(UiColors.PRIMARY)
                      .borderRadius(20)
                      .onClick(() => {
                        this.updateOrderStatus(order.id, OrderStatus.Completed);
                      })
                  } else if (order.status === OrderStatus.Completed) {
                    Button('再来一单')
                      .height(40)
                      .layoutWeight(1)
                      .fontSize(14)
                      .fontColor('#FFFFFF')
                      .backgroundColor(UiColors.GREEN)
                      .borderRadius(20)
                      .onClick(() => {
                        this.repeatOrder(order);
                      })
                    Button('移除记录')
                      .height(40)
                      .layoutWeight(1)
                      .fontSize(14)
                      .fontColor(UiColors.SUB_TEXT)
                      .backgroundColor('#FFFFFF')
                      .borderRadius(20)
                      .border({ width: 1, color: UiColors.LINE })
                      .onClick(() => {
                        this.removeOrder(order.id);
                      })
                  } else {
                    Button('移除记录')
                      .height(40)
                      .width(120)
                      .fontSize(14)
                      .fontColor(UiColors.SUB_TEXT)
                      .backgroundColor('#FFFFFF')
                      .borderRadius(20)
                      .border({ width: 1, color: UiColors.LINE })
                      .onClick(() => {
                        this.removeOrder(order.id);
                      })
                  }
                }
                .width('100%')
              }
              .width('100%')
              .padding(16)
              .backgroundColor(UiColors.SURFACE)
              .borderRadius(18)
              .border({ width: 1, color: UiColors.LINE })
            }, (order: OrderRecord) => order.id + '_' + this.refreshKey.toString())
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 18 })
        }
        .layoutWeight(1)
        .align(Alignment.Top)
      }
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(UiColors.PAGE)
  }

  @Builder
  PickupView() {
    Column() {
      Scroll() {
        Column({ space: 14 }) {
        Text('取餐')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(UiColors.TEXT)
          .width('100%')
          .padding({ top: 22 })

        if (this.getReadyOrders().length === 0) {
          Column({ space: 12 }) {
            Text('暂无待取餐订单')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(UiColors.TEXT)
            Text('提交订单后，取餐码会显示在这里')
              .fontSize(14)
              .fontColor(UiColors.SUB_TEXT)
            Button('去点餐')
              .height(44)
              .width(110)
              .fontColor('#FFFFFF')
              .backgroundColor(UiColors.PRIMARY)
              .borderRadius(22)
              .onClick(() => {
                this.currentView = AppView.Home;
              })
          }
          .width('100%')
          .padding(28)
          .backgroundColor(UiColors.SURFACE)
          .borderRadius(18)
          .border({ width: 1, color: UiColors.LINE })
        } else {
          ForEach(this.getReadyOrders(), (order: OrderRecord) => {
            Column({ space: 12 }) {
              Row() {
                Column({ space: 4 }) {
                  Text(order.shopName)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(UiColors.TEXT)
                  Text(this.getOrderItemSummary(order))
                    .fontSize(13)
                    .fontColor(UiColors.SUB_TEXT)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .layoutWeight(1)
                .align(Alignment.Top)
                .alignItems(HorizontalAlign.Start)
                Text(this.formatPrice(order.total))
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.PRIMARY)
              }
              .width('100%')

              Column({ space: 5 }) {
                Text('取餐码')
                  .fontSize(13)
                  .fontColor(UiColors.SUB_TEXT)
                Text(order.pickupCode)
                  .fontSize(42)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.PRIMARY)
                Text('预计 ' + this.formatTime(order.pickupTime) + ' 可取')
                  .fontSize(13)
                  .fontColor(UiColors.SUB_TEXT)
              }
              .width('100%')
              .padding(18)
              .backgroundColor(UiColors.SURFACE_SOFT)
              .borderRadius(18)

              Button('已取到餐')
                .height(44)
                .width('100%')
                .fontSize(15)
                .fontColor('#FFFFFF')
                .backgroundColor(UiColors.PRIMARY)
                .borderRadius(22)
                .onClick(() => {
                  this.updateOrderStatus(order.id, OrderStatus.Completed);
                })
            }
            .width('100%')
            .padding(16)
            .backgroundColor(UiColors.SURFACE)
            .borderRadius(18)
            .border({ width: 1, color: UiColors.LINE })
          }, (order: OrderRecord) => order.id + '_' + this.refreshKey.toString())
        }
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 20 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
      .layoutWeight(1)
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  ProfileView() {
    Column() {
      Scroll() {
        Column({ space: 14 }) {
          Text('我的')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiColors.TEXT)
            .width('100%')
            .padding({ top: 22 })

          Column({ space: 14 }) {
            Row({ space: 14 }) {
              Stack({ alignContent: Alignment.Center }) {
                Text(this.getUserInitial())
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
              }
              .width(64)
              .height(64)
              .backgroundColor(UiColors.PRIMARY)
              .borderRadius(32)

              Column({ space: 6 }) {
                Row() {
                  Text(this.userName)
                    .fontSize(23)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(UiColors.TEXT)
                    .layoutWeight(1)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text('自取用户')
                    .fontSize(12)
                    .fontColor(UiColors.GREEN)
                    .padding({ left: 9, right: 9, top: 5, bottom: 5 })
                    .backgroundColor(UiColors.GREEN_SOFT)
                    .borderRadius(12)
                }
                .width('100%')

                Text(this.userPhone)
                  .fontSize(14)
                  .fontColor(UiColors.SUB_TEXT)
                  .width('100%')
                Text(this.userLocation)
                  .fontSize(13)
                  .fontColor(UiColors.MUTED)
                  .width('100%')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .layoutWeight(1)
              .align(Alignment.Top)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')

            Row({ space: 10 }) {
              Column({ space: 4 }) {
                Text(this.orders.length.toString())
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.TEXT)
                Text('全部订单')
                  .fontSize(12)
                  .fontColor(UiColors.SUB_TEXT)
              }
              .layoutWeight(1)
              .align(Alignment.Top)
              .padding(12)
              .backgroundColor('#F8FAFC')
              .borderRadius(14)

              Column({ space: 4 }) {
                Text(this.getReadyOrders().length.toString())
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.PRIMARY)
                Text('待取餐')
                  .fontSize(12)
                  .fontColor(UiColors.SUB_TEXT)
              }
              .layoutWeight(1)
              .align(Alignment.Top)
              .padding(12)
              .backgroundColor(UiColors.SURFACE_SOFT)
              .borderRadius(14)

              Column({ space: 4 }) {
                Text(this.getCompletedOrderCount().toString())
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.GREEN)
                Text('已完成')
                  .fontSize(12)
                  .fontColor(UiColors.SUB_TEXT)
              }
              .layoutWeight(1)
              .align(Alignment.Top)
              .padding(12)
              .backgroundColor(UiColors.GREEN_SOFT)
              .borderRadius(14)
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(UiColors.SURFACE)
          .borderRadius(20)
          .border({ width: 1, color: UiColors.LINE })

          Column({ space: 10 }) {
            Row({ space: 12 }) {
              Stack({ alignContent: Alignment.Center }) {
                Image($r('app.media.ic_profile_active'))
                  .width(22)
                  .height(22)
                  .objectFit(ImageFit.Contain)
              }
              .width(40)
              .height(40)
              .backgroundColor(UiColors.SURFACE_SOFT)
              .borderRadius(14)

              Column({ space: 3 }) {
                Text('个人资料')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.TEXT)
                Text('修改姓名、联系电话和取餐点')
                  .fontSize(12)
                  .fontColor(UiColors.SUB_TEXT)
              }
              .layoutWeight(1)
              .align(Alignment.Top)
              .alignItems(HorizontalAlign.Start)

              Text('›')
                .fontSize(24)
                .fontColor(UiColors.MUTED)
            }
            .width('100%')
            .padding(14)
            .backgroundColor(UiColors.SURFACE)
            .borderRadius(16)
            .border({ width: 1, color: UiColors.LINE })
            .onClick(() => {
              this.openProfileEdit();
            })

            Row({ space: 12 }) {
              Stack({ alignContent: Alignment.Center }) {
                Image($r('app.media.ic_lock_active'))
                  .width(22)
                  .height(22)
                  .objectFit(ImageFit.Contain)
              }
              .width(40)
              .height(40)
              .backgroundColor(UiColors.SURFACE_SOFT)
              .borderRadius(14)

              Column({ space: 3 }) {
                Text('修改密码')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.TEXT)
                Text('更新登录密码，保护账号信息')
                  .fontSize(12)
                  .fontColor(UiColors.SUB_TEXT)
              }
              .layoutWeight(1)
              .align(Alignment.Top)
              .alignItems(HorizontalAlign.Start)

              Text('›')
                .fontSize(24)
                .fontColor(UiColors.MUTED)
            }
            .width('100%')
            .padding(14)
            .backgroundColor(UiColors.SURFACE)
            .borderRadius(16)
            .border({ width: 1, color: UiColors.LINE })
            .onClick(() => {
              this.openPasswordEdit();
            })

            Row({ space: 12 }) {
              Stack({ alignContent: Alignment.Center }) {
                Image($r('app.media.ic_order_active'))
                  .width(22)
                  .height(22)
                  .objectFit(ImageFit.Contain)
              }
              .width(40)
              .height(40)
              .backgroundColor('#F8FAFC')
              .borderRadius(14)

              Column({ space: 3 }) {
                Text('我的订单')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.TEXT)
                Text('查看全部订单和取餐记录')
                  .fontSize(12)
                  .fontColor(UiColors.SUB_TEXT)
              }
              .layoutWeight(1)
              .align(Alignment.Top)
              .alignItems(HorizontalAlign.Start)

              Text('›')
                .fontSize(24)
                .fontColor(UiColors.MUTED)
            }
            .width('100%')
            .padding(14)
            .backgroundColor(UiColors.SURFACE)
            .borderRadius(16)
            .border({ width: 1, color: UiColors.LINE })
            .onClick(() => {
              this.orderFilter = OrderFilter.All;
              this.currentView = AppView.Orders;
            })

            Row({ space: 12 }) {
              Stack({ alignContent: Alignment.Center }) {
                Image($r('app.media.ic_pickup_active'))
                  .width(22)
                  .height(22)
                  .objectFit(ImageFit.Contain)
              }
              .width(40)
              .height(40)
              .backgroundColor(UiColors.GREEN_SOFT)
              .borderRadius(14)

              Column({ space: 3 }) {
                Text('取餐码')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.TEXT)
                Text('查看当前待取餐订单')
                  .fontSize(12)
                  .fontColor(UiColors.SUB_TEXT)
              }
              .layoutWeight(1)
              .align(Alignment.Top)
              .alignItems(HorizontalAlign.Start)

              Text('›')
                .fontSize(24)
                .fontColor(UiColors.MUTED)
            }
            .width('100%')
            .padding(14)
            .backgroundColor(UiColors.SURFACE)
            .borderRadius(16)
            .border({ width: 1, color: UiColors.LINE })
            .onClick(() => {
              this.currentView = AppView.Pickup;
            })
          }
          .width('100%')

          Column({ space: 10 }) {
            Row() {
              Text('常用取餐点')
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor(UiColors.TEXT)
              Blank()
              Text('修改')
                .fontSize(14)
                .fontColor(UiColors.PRIMARY)
                .onClick(() => {
                  this.openProfileEdit();
                })
            }
            .width('100%')

            Text(this.userLocation)
              .fontSize(15)
              .fontColor(UiColors.TEXT)
              .width('100%')
            Text('下单后将优先使用该取餐信息')
              .fontSize(12)
              .fontColor(UiColors.SUB_TEXT)
              .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(UiColors.SURFACE)
          .borderRadius(18)
          .border({ width: 1, color: UiColors.LINE })

          Button('退出登录')
            .height(46)
            .width('100%')
            .fontSize(15)
            .fontColor(UiColors.DANGER)
            .backgroundColor('#FFFFFF')
            .borderRadius(23)
            .border({ width: 1, color: '#F2C7C0' })
            .onClick(() => {
              this.logout();
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 20 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
      .layoutWeight(1)
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  ProfileEditView() {
    Column() {
      Row() {
        Text('‹')
          .fontSize(34)
          .fontColor(UiColors.TEXT)
          .width(42)
          .height(42)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.closeProfileEdit();
          })
        Text('编辑资料')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(UiColors.TEXT)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text(' ')
          .width(42)
      }
      .width('100%')
      .padding({ left: 10, right: 16, top: 14, bottom: 10 })

      Scroll() {
        Column({ space: 14 }) {
          Column({ space: 12 }) {
            Row({ space: 12 }) {
              Stack({ alignContent: Alignment.Center }) {
                Text(this.getUserInitial())
                  .fontSize(26)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
              }
              .width(58)
              .height(58)
              .backgroundColor(UiColors.PRIMARY)
              .borderRadius(29)

              Column({ space: 5 }) {
                Text('个人资料')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.TEXT)
                Text('用于取餐核对和联系确认')
                  .fontSize(13)
                  .fontColor(UiColors.SUB_TEXT)
              }
              .layoutWeight(1)
              .align(Alignment.Top)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(UiColors.SURFACE)
          .borderRadius(18)
          .border({ width: 1, color: UiColors.LINE })

          Column({ space: 12 }) {
            Text('姓名')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(UiColors.TEXT)
              .width('100%')
            TextInput({ placeholder: '请输入姓名', text: this.draftName })
              .height(48)
              .width('100%')
              .fontSize(15)
              .backgroundColor('#F8FAFC')
              .borderRadius(16)
              .padding({ left: 14, right: 14 })
              .border({ width: 1, color: UiColors.LINE })
              .onChange((value: string) => {
                this.draftName = value;
              })

            Text('联系电话')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(UiColors.TEXT)
              .width('100%')
            TextInput({ placeholder: '请输入手机号', text: this.draftPhone })
              .height(48)
              .width('100%')
              .fontSize(15)
              .backgroundColor('#F8FAFC')
              .borderRadius(16)
              .padding({ left: 14, right: 14 })
              .border({ width: 1, color: UiColors.LINE })
              .onChange((value: string) => {
                this.draftPhone = value;
              })

            Text('常用取餐点')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(UiColors.TEXT)
              .width('100%')
            TextInput({ placeholder: '请输入常用取餐点', text: this.draftLocation })
              .height(48)
              .width('100%')
              .fontSize(15)
              .backgroundColor('#F8FAFC')
              .borderRadius(16)
              .padding({ left: 14, right: 14 })
              .border({ width: 1, color: UiColors.LINE })
              .onChange((value: string) => {
                this.draftLocation = value;
              })

            if (this.profileMessage.length > 0) {
              Text(this.profileMessage)
                .fontSize(13)
                .fontColor(UiColors.DANGER)
                .width('100%')
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor(UiColors.SURFACE)
          .borderRadius(18)
          .border({ width: 1, color: UiColors.LINE })

          Button('保存信息')
            .height(50)
            .width('100%')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor(UiColors.PRIMARY)
            .borderRadius(25)
            .onClick(() => {
              this.saveProfile();
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 20 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
      .layoutWeight(1)
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(UiColors.PAGE)
  }

  @Builder
  ProfilePasswordView() {
    Column() {
      Row() {
        Text('‹')
          .fontSize(34)
          .fontColor(UiColors.TEXT)
          .width(42)
          .height(42)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.closePasswordEdit();
          })
        Text('修改密码')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(UiColors.TEXT)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text(' ')
          .width(42)
      }
      .width('100%')
      .padding({ left: 10, right: 16, top: 14, bottom: 10 })

      Scroll() {
        Column({ space: 14 }) {
          Column({ space: 12 }) {
            Row({ space: 12 }) {
              Stack({ alignContent: Alignment.Center }) {
                Image($r('app.media.ic_lock_active'))
                  .width(28)
                  .height(28)
                  .objectFit(ImageFit.Contain)
              }
              .width(58)
              .height(58)
              .backgroundColor(UiColors.SURFACE_SOFT)
              .borderRadius(20)

              Column({ space: 5 }) {
                Text('账号安全')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(UiColors.TEXT)
                Text('修改后下次登录请使用新密码')
                  .fontSize(13)
                  .fontColor(UiColors.SUB_TEXT)
              }
              .layoutWeight(1)
              .align(Alignment.Top)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(UiColors.SURFACE)
          .borderRadius(18)
          .border({ width: 1, color: UiColors.LINE })

          Column({ space: 12 }) {
            Text('原密码')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(UiColors.TEXT)
              .width('100%')
            TextInput({ placeholder: '请输入原密码', text: this.oldPassword })
              .height(48)
              .width('100%')
              .fontSize(15)
              .type(InputType.Password)
              .backgroundColor('#F8FAFC')
              .borderRadius(16)
              .padding({ left: 14, right: 14 })
              .border({ width: 1, color: UiColors.LINE })
              .onChange((value: string) => {
                this.oldPassword = value;
              })

            Text('新密码')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(UiColors.TEXT)
              .width('100%')
            TextInput({ placeholder: '至少 6 位', text: this.newPassword })
              .height(48)
              .width('100%')
              .fontSize(15)
              .type(InputType.Password)
              .backgroundColor('#F8FAFC')
              .borderRadius(16)
              .padding({ left: 14, right: 14 })
              .border({ width: 1, color: UiColors.LINE })
              .onChange((value: string) => {
                this.newPassword = value;
              })

            Text('确认新密码')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(UiColors.TEXT)
              .width('100%')
            TextInput({ placeholder: '请再次输入新密码', text: this.confirmPassword })
              .height(48)
              .width('100%')
              .fontSize(15)
              .type(InputType.Password)
              .backgroundColor('#F8FAFC')
              .borderRadius(16)
              .padding({ left: 14, right: 14 })
              .border({ width: 1, color: UiColors.LINE })
              .onChange((value: string) => {
                this.confirmPassword = value;
              })

            if (this.passwordMessage.length > 0) {
              Text(this.passwordMessage)
                .fontSize(13)
                .fontColor(UiColors.DANGER)
                .width('100%')
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor(UiColors.SURFACE)
          .borderRadius(18)
          .border({ width: 1, color: UiColors.LINE })

          Button('保存密码')
            .height(50)
            .width('100%')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .backgroundColor(UiColors.PRIMARY)
            .borderRadius(25)
            .onClick(() => {
              this.savePassword();
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 20 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
      .layoutWeight(1)
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(UiColors.PAGE)
  }

  @Builder
  BottomNav() {
    Row() {
      Column({ space: 4 }) {
        Image(this.currentView === AppView.Home ? $r('app.media.ic_home_active') : $r('app.media.ic_home'))
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
        Text('首页')
          .fontSize(11)
          .fontColor(this.currentView === AppView.Home ? UiColors.PRIMARY : UiColors.SUB_TEXT)
      }
      .width('25%')
      .onClick(() => {
        this.currentView = AppView.Home;
      })

      Column({ space: 4 }) {
        Image(this.currentView === AppView.Orders ? $r('app.media.ic_order_active') : $r('app.media.ic_order'))
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
        Text('订单')
          .fontSize(11)
          .fontColor(this.currentView === AppView.Orders ? UiColors.PRIMARY : UiColors.SUB_TEXT)
      }
      .width('25%')
      .onClick(() => {
        this.currentView = AppView.Orders;
      })

      Column({ space: 4 }) {
        Image(this.currentView === AppView.Pickup ? $r('app.media.ic_pickup_active') : $r('app.media.ic_pickup'))
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
        Text('取餐')
          .fontSize(11)
          .fontColor(this.currentView === AppView.Pickup ? UiColors.PRIMARY : UiColors.SUB_TEXT)
      }
      .width('25%')
      .onClick(() => {
        this.currentView = AppView.Pickup;
      })

      Column({ space: 4 }) {
        Image(this.currentView === AppView.Profile ? $r('app.media.ic_profile_active') : $r('app.media.ic_profile'))
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
        Text('我的')
          .fontSize(11)
          .fontColor(this.currentView === AppView.Profile ? UiColors.PRIMARY : UiColors.SUB_TEXT)
      }
      .width('25%')
      .onClick(() => {
        this.currentView = AppView.Profile;
      })
    }
    .width('100%')
    .height(68)
    .padding({ left: 8, right: 8, top: 8, bottom: 8 })
    .backgroundColor(UiColors.SURFACE)
    .border({ width: 1, color: UiColors.LINE })
  }
}
