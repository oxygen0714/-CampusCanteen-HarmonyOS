/**
 * 输入验证工具
 * 提供手机号、密码、姓名等格式校验
 */

import { MAX_FOOD_COUNT } from '../models/DataModels';

/**
 * 验证中国大陆手机号格式
 * 规则：1 开头，第二位 3-9，共 11 位数字
 */
export function isValidPhone(phone: string): boolean {
  if (phone.length === 0) {
    return false;
  }
  // 中国大陆手机号：1[3-9]\d{9}
  let phoneRegex: RegExp = /^1[3-9]\d{9}$/;
  return phoneRegex.test(phone.trim());
}

/**
 * 验证密码强度
 * 规则：至少 6 位字符
 */
export function isValidPassword(password: string): boolean {
  return password.length >= 6;
}

/**
 * 获取密码校验失败的原因
 */
export function getPasswordError(password: string): string {
  if (password.length === 0) {
    return '请输入密码';
  }
  if (password.length < 6) {
    return '密码至少 6 位';
  }
  return '';
}

/**
 * 验证姓名
 * 规则：1-20 个字符，非空
 */
export function isValidName(name: string): boolean {
  let trimmed: string = name.trim();
  return trimmed.length >= 1 && trimmed.length <= 20;
}

/**
 * 获取手机号校验失败的原因
 */
export function getPhoneError(phone: string): string {
  if (phone.trim().length === 0) {
    return '请输入手机号';
  }
  if (!isValidPhone(phone)) {
    return '请输入正确的 11 位手机号';
  }
  return '';
}

/**
 * 验证食物数量是否有效
 * @returns 有效的数量值（限制在 1-MAX_FOOD_COUNT 之间）
 */
export function clampFoodCount(count: number): number {
  if (count < 0) {
    return 0;
  }
  if (count > MAX_FOOD_COUNT) {
    return MAX_FOOD_COUNT;
  }
  return count;
}
