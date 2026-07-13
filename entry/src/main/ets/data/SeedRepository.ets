/**
 * 种子数据仓库 — 校园档口和餐品数据
 */

import { ShopSeed, FoodItem, ShopItem } from '../models/DataModels';

export class SeedRepository {
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
