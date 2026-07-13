/**
 * 数据模型 — 校园食堂点餐应用
 * 所有枚举、接口、常量集中管理
 */

// ==================== 视图枚举 ====================

export enum AppView {
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

export enum AuthMode {
  Login = 0,
  Register = 1
}

export enum OrderStatus {
  Ready = 0,
  Completed = 1,
  Cancelled = 2
}

export enum OrderFilter {
  All = 0,
  Ready = 1,
  Completed = 2,
  Cancelled = 3
}

// ==================== 数据接口 ====================

export interface ShopSeed {
  name: string;
  score: string;
  monthly: string;
  tags: string[];
  foodNames: string[];
}

export interface FoodItem {
  id: string;
  shopId: string;
  name: string;
  price: number;
  category: string;
  desc: string;
  sold: number;
}

export interface ShopItem {
  id: string;
  name: string;
  score: string;
  monthly: string;
  tags: string[];
  foods: FoodItem[];
}

export interface CartLine {
  id: string;
  shopId: string;
  shopName: string;
  foodId: string;
  foodName: string;
  price: number;
  count: number;
}

export interface OrderLine {
  foodId: string;
  foodName: string;
  price: number;
  count: number;
}

export interface OrderRecord {
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

export interface UserAccount {
  phone: string;
  password: string;       // 现在存储 SHA-256 哈希值，不再是明文
  name: string;
  location: string;
  createdAt: number;
}

// ==================== 常量 ====================

export class UiColors {
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

export class StorageKeys {
  static readonly STORE_NAME: string = 'campus_canteen_user_cache_v2';
  static readonly CART: string = 'cart_lines';
  static readonly ORDERS: string = 'orders';
  static readonly USER_NAME: string = 'user_name';
  static readonly USER_PHONE: string = 'user_phone';
  static readonly USER_LOCATION: string = 'user_location';
  static readonly USERS: string = 'users';
  static readonly CURRENT_PHONE: string = 'current_phone';
  static readonly LOGGED_IN: string = 'logged_in';
}

/** 每个食物单品最大可点数量 */
export const MAX_FOOD_COUNT: number = 99;

/** 可选取餐时间（分钟） */
export const PICKUP_TIME_OPTIONS: number[] = [15, 30, 45];

/** 默认取餐时间（分钟） */
export const DEFAULT_PICKUP_MINUTES: number = 15;
