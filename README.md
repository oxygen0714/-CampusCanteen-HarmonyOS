# 校园食堂点餐

基于 HarmonyOS ArkTS 的校园食堂提前点餐应用。

## 功能

- 9 个档口浏览点餐、分类筛选、关键词搜索
- 用户注册/登录，密码采用 **SHA-256 哈希**存储
- 手机号格式校验（1[3-9]xxxxxxxxx）、密码强度校验
- 购物车弹窗实时增减、数字自由输入编辑、清空购物篮
- **跨店自动拆分订单** —— 不同档口自动分成独立订单
- 下单确认弹窗、取餐码随机生成、订单管理
- 单品数量上限 99

## 兼容

| DevEco Studio | SDK API | 结果 |
|:--|:--|:--:|
| 6.1.1 | 24 | ✅ |
| 5.1.1 | 19 | ✅ |

## 快速开始

```bash
# 1. 克隆仓库
git clone https://github.com/oxygen0714/-CampusCanteen-HarmonyOS.git

# 2. 用 DevEco Studio 打开项目目录

# 3. 修改 local.properties 中 SDK 路径为你自己的路径
#    nodejs.dir=E:/DevEco Studio/tools/node
#    sdk.dir=E:/DevEco Studio/sdk/default

# 4. Build → Build Hap(s)
```

## 项目结构

```
entry/src/main/ets/
├── pages/Index.ets         ← 主文件，全部 UI + 业务逻辑
├── entryability/            ← 应用入口
├── entrybackupability/      ← 备份扩展
├── data/                    ← 种子数据 + 存储管理
├── models/                  ← 数据模型
└── utils/                   ← 工具（密码哈希、校验、格式化）
```

## 技术栈

- **语言**: ArkTS (TypeScript)
- **UI 框架**: ArkUI 声明式
- **密码安全**: SHA-256（cryptoFramework 主 + 软实现回退）
- **存储**: Preferences 本地持久化
- **构建**: Hvigor

## 开源协议

MIT
