/**
 * 格式化工具
 * 价格、时间等格式化函数
 */

/**
 * 格式化价格：¥XX
 */
export function formatPrice(value: number): string {
  return '¥' + value.toFixed(0);
}

/**
 * 数字补零
 */
function padNumber(value: number): string {
  if (value < 10) {
    return '0' + value.toString();
  }
  return value.toString();
}

/**
 * 格式化时间戳为 HH:MM
 */
export function formatTime(value: number): string {
  let date: Date = new Date(value);
  return padNumber(date.getHours()) + ':' + padNumber(date.getMinutes());
}

/**
 * 生成简短订单 ID 摘要
 */
export function getOrderItemSummary(items: { foodName: string; count: number }[]): string {
  if (items.length === 0) {
    return '';
  }
  let first = items[0];
  if (items.length === 1) {
    return first.foodName + ' ×' + first.count.toString();
  }
  return first.foodName + ' 等 ' + items.length.toString() + ' 件';
}
