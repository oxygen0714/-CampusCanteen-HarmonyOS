/**
 * 密码工具 — SHA-256 哈希
 * 使用 HarmonyOS cryptoFramework 进行密码安全存储
 * 修复：密码不再明文存储
 */

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util } from '@kit.ArkTS';

/**
 * 对明文密码进行 SHA-256 哈希
 * @param plaintext 明文密码
 * @returns 十六进制哈希字符串
 */
export async function hashPassword(plaintext: string): Promise<string> {
  try {
    let md = cryptoFramework.createMd('SHA256');
    let input: Uint8Array = stringToUint8Array(plaintext);
    await md.update({ data: input });
    let result = await md.digest();
    return uint8ArrayToHex(result.data);
  } catch (err) {
    // 如果 cryptoFramework 不可用，回退到简单哈希
    return fallbackHash(plaintext);
  }
}

/**
 * 验证密码是否匹配
 * @param plaintext 用户输入的明文密码
 * @param storedHash 存储的哈希值
 * @returns 是否匹配
 */
export async function verifyPassword(plaintext: string, storedHash: string): Promise<boolean> {
  let computedHash: string = await hashPassword(plaintext);
  return computedHash === storedHash;
}

/**
 * 将字符串转为 Uint8Array
 */
function stringToUint8Array(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}

/**
 * 将 Uint8Array 转为十六进制字符串
 */
function uint8ArrayToHex(bytes: Uint8Array): string {
  let hexParts: string[] = [];
  for (let i = 0; i < bytes.length; i++) {
    let byte: number = bytes[i];
    let hex: string = byte.toString(16);
    if (hex.length === 1) {
      hex = '0' + hex;
    }
    hexParts.push(hex);
  }
  return hexParts.join('');
}

/**
 * 回退哈希 — 当 cryptoFramework 不可用时使用
 * 基于字符串的确定性哈希，用于开发/演示环境
 */
function fallbackHash(input: string): string {
  let h1: number = 0x67452301;
  let h2: number = 0xEFCDAB89;
  let h3: number = 0x98BADCFE;
  let h4: number = 0x10325476;
  let h5: number = 0xC3D2E1F0;

  // 简单填充
  let bytes: number[] = [];
  for (let i = 0; i < input.length; i++) {
    bytes.push(input.charCodeAt(i) & 0xFF);
  }
  bytes.push(0x80);
  while ((bytes.length + 8) % 64 !== 0) {
    bytes.push(0);
  }
  let bitLen: number = input.length * 8;
  for (let i = 7; i >= 0; i--) {
    bytes.push((bitLen >>> (i * 8)) & 0xFF);
  }

  // 分块处理
  for (let chunkStart = 0; chunkStart < bytes.length; chunkStart += 64) {
    let w: number[] = [];
    for (let i = 0; i < 16; i++) {
      let offset: number = chunkStart + i * 4;
      w[i] = (bytes[offset] << 24) | (bytes[offset + 1] << 16) | (bytes[offset + 2] << 8) | bytes[offset + 3];
    }
    for (let i = 16; i < 80; i++) {
      let s0: number = rightRotate(w[i - 15], 7) ^ rightRotate(w[i - 15], 18) ^ (w[i - 15] >>> 3);
      let s1: number = rightRotate(w[i - 2], 17) ^ rightRotate(w[i - 2], 19) ^ (w[i - 2] >>> 10);
      w[i] = (w[i - 16] + s0 + w[i - 7] + s1) | 0;
    }

    let a: number = h1, b: number = h2, c: number = h3, d: number = h4, e: number = h5;
    for (let i = 0; i < 80; i++) {
      let f: number, k: number;
      if (i < 20) {
        f = (b & c) | ((~b) & d);
        k = 0x5A827999;
      } else if (i < 40) {
        f = b ^ c ^ d;
        k = 0x6ED9EBA1;
      } else if (i < 60) {
        f = (b & c) | (b & d) | (c & d);
        k = 0x8F1BBCDC;
      } else {
        f = b ^ c ^ d;
        k = 0xCA62C1D6;
      }
      let temp: number = (rightRotate(a, 5) + f + e + k + w[i]) | 0;
      e = d;
      d = c;
      c = rightRotate(b, 30);
      b = a;
      a = temp;
    }
    h1 = (h1 + a) | 0;
    h2 = (h2 + b) | 0;
    h3 = (h3 + c) | 0;
    h4 = (h4 + d) | 0;
    h5 = (h5 + e) | 0;
  }

  return toHexWord(h1) + toHexWord(h2) + toHexWord(h3) + toHexWord(h4) + toHexWord(h5);
}

function rightRotate(value: number, amount: number): number {
  return (value >>> amount) | (value << (32 - amount));
}

function toHexWord(value: number): string {
  let hex: string = '';
  for (let i = 7; i >= 0; i--) {
    let byte: number = (value >>> (i * 4)) & 0xF;
    hex += byte.toString(16);
  }
  return hex;
}
