# 欢迎加入栋记（冬季）战场！
[简体中文](#简体中文)|[繁体中文](#繁體中文)|[English](#English)

## 简体中文
冬季战场的默认语言！
---

### 一、项目简介

**栋记（冬季）战场（Dong's MC Warfare）** 是一个基于《我的世界》Java版 1.21.11 的多人对抗数据包。它不是小游戏插件，不是命令方块堆砌的临时娱乐——它是一个从命令方块项目转化而来、由数据驱动、支持多语言与主题包的**完整对战平台**。

取名为*栋记*战场，是为了以此纪念为《冬季战场》开发提供宝贵支持的Minecraft超级栋服腐竹**GNOD728**，没有超级栋服的支持，我们做不出来这个小东西。
当然，我们*号为张楚*也是经过了GNOD728本人的允许，也欢迎大家去玩他做的*冬季战场：极地潜兵*。

~~其实本来叫Winter Battlefield的，但是这和EA的Battlefield太像了，所以改成现在的名字，大家感觉我们的谐音梗水平怎么样呢？~~

**核心理念**：免费、公平、文化传播、玩家共创。

- **免费**：永远不收一分钱，如果谁让你付费购买，你被骗了。
- **公平**：禁止外挂，不搞氪金变强，每一场胜负只取决于你的操作和配合。
- **文化传播**：从“雪域龙腾”到“极地潜兵”，冬战可以被任何人改写成任何文化主题。
- **玩家共创**：每一个测试员、每一个提交翻译键的人、每一个在60144发过“Ciallo～”的人，都是冬战的共建者。

**一句话定义**：  
**在冰原上打一场15分钟的攻防战，用兵种、导弹和步话机，写自己的战争故事。**

**部分代码和介绍由Deepseek生成**
~~反过来说，剩下的部分就是我们亲自写的~~

---

### 二、快速开始

#### 1. 安装
- **数据包**：将 `djzc444.zip` 放入存档的 `datapacks` 文件夹。(如果您使用了我们提供的存档进行游玩，可以跳过这一步)
- **资源包**：将 `赛扬的冬季战场v1.0.6.zip` 放入 `resourcepacks` 文件夹，并在游戏中加载（**优先级调到最高**）。
> 听说你的网络太卡了下载不了我们的资源包？
>  没问题，你可以把*数据包*塞进资源包文件夹，我们往里面塞了一套备用的文件！
- **可选主题包**：如需“雪域龙腾”或“极地潜兵”，同样放入资源包文件夹，优先级高于默认包。

- **或者即将推出的“冬季战场优化整合包”**：平常怎么装整合包就怎么装这个。

> 📌 提示：强烈推荐使用服务器或者局域网联机进行多人对战。虽然单人模式也可体验游戏的部分内容，但多人游戏是我们推荐的游玩方式。

#### 2. 进入游戏
- 创建/进入世界后，你会自动获得 **冬战成员用书**（一本成书）。
- **按 G 键**（或右键成员用书）打开主菜单。记得调整视频设置，否则*GUI会被截断*

#### 3. 第一次对战流程
1. **选择阵营**：CT（防守方）或 T（进攻方）。  
   - CT：阻止T占领全部战区，拖到15分钟结束即赢。  
   - T：占领全部四个战区（A、B、C、D）即赢。
2. **选择兵种**：从8个兵种中选一个。
3. **点击“准备”**：等待所有玩家准备，游戏自动开始。
4. **传送**：在成员用书中打开“传送系统”，选择战区、启动器或队友身边出发。
5. **开战**：使用步话机（G键菜单内）发送指令，配合队友占点、激活启动器、发射导弹。

#### 4. 基础操作速记
- **G键**：主菜单（兵种、传送、步话机、百科）
- **右键成员用书**：效果同上
- **步话机指令**：在主菜单中点击预设消息（如“进攻D点！”“发现敌人！”）
- **导弹发射**：手持导弹（如“空空导弹”），右键发射。
- **干扰导弹**：右键干扰弹，你的上下左右前后会弹出几只鸡，导弹会追踪它们。

> ⚠️ 注意：敌方玩家头顶**是没有名字的！**你可以通过盔甲纹饰颜色（CT蓝色 / T红色）和外观识别场上的人是敌是右。

---

### 三、游戏机制详解

#### 1. 战区与占领
以我们的第一张地图**冬季战场**为例：
- **四个战区**：A（冰湖北侧）、B（冰刺之地南侧）、C（雪原村庄中心）、D（CT家后方冰湖）。
- **占领规则**：
  - T方进入战区 → 增加占领进度；CT方进入 → 减少进度。
  - 离开战区不重置进度（保留已占领比例）。
  - 双方同时进点时，T方进度增加效率减半，CT方无法减少进度。
  - CT无法夺回已被T完全占领的点位。
- **占点时间**：60秒。

#### 2. 启动器（C/D点前置条件）
- **C点启动器**（C1、C2、C3）：分别位于南侧战壕地堡、村庄地道、北部山腰。
- **D点启动器**（D1、D2、D3）：分别位于碉堡、灯塔地下室、CT出生点。
- **激活方式**：占领B点后，启动器高亮；玩家需**旋转物品展示框约一圈（右键7次）**。
- **全部激活后**：对应战区开放占领。
- **自动修理**：如果展示框被意外击毁，系统会自动重新放置。

#### 3. 兵种系统
| 大类 | 亚种 | 定位 |
|------|------|------|
| **突击兵** | 近战兵（盾斧剑）、三叉戟兵（破盾戟） | 正面推进 |
| **侦察兵** | 狙击手（大狙弓）、游骑兵（高速矛） | 远程压制/骚扰 |
| **支援兵** | 防空兵（原版机枪+霰弹弩+地空导弹）、冈格尼尔（秒杀三叉戟） | 火力支援/辅助 |
| **航空兵** | 立体机动装置（导弹+雷枪）、板载兵（就是你想的那个，不建议玩，因为这很疯狂） | 制空与奇袭 |

- **条件限制**：航空兵在5杀后解锁；板载兵每人一局仅一次。

#### 4. 导弹与空战
- **导弹类型**：
  - 空空导弹：追踪敌方空中单位。
  - 空地导弹：追踪地面单位。
- **发射与干扰**：右键发射；任何投掷物（鸡蛋、雪球）会吸引导弹追踪，可用于欺骗。
- **告警系统**：当敌方导弹进入100米内，**每秒发出一次告警**。
- **机场补给**：
  - 己方机场停留30秒 → 获得4枚空空、8枚空地导弹。
  - 接近敌方机场（<75米且有敌方单位）→ 机场自动发射地空导弹。
  - 机场设有 **弹射器**（绊线钩+命令方块），给予速度和漂浮效果，模拟现实中的弹射器。

#### 5. 步话机与战术通信
- **MK.IV 步话机**：基于对话框的预设指令系统。
- **12条指令**：包含“进攻D点”“防守D点”“发现敌人”“我来助你”等。
- **彩蛋指令**：`Ciallo～(∠・ω< )⌒★` —— 彩蛋。
- **使用方式**：G键主菜单 → “转到步话机” → 点击对应消息。

#### 6. 传送系统
- **传送点**：包括战区、启动器、出生点、机场、队友身边等。
- **条件限制**：
  - 只能传送到己方控制的区域。
  - 地下（Y<40）可随意传送（用于配装中心）。
  - 传送到最近/随机队友。
- **旧版传送器**：保留但已加警示标语，建议使用新版。

#### 7. 特殊机制
- **轰炸塔**：地图中隐藏的观测塔，使用“轰炸指示器”标记区域，标记落地10秒后爆炸，伤害半径14米，有伤害梯度（**可能炸死自己或者队友**）。
- **自动设置重生点**：
  - 开局时重生点自动设为地下配装处。
  - 游戏结束时重生点移到队伍选择器附近。
  - 腐竹再也不用担心玩家到处乱跑了！
- **防破坏**：所有生存模式玩家进入服务器自动设为冒险模式，无法破坏方块。

#### 版本规划
[这是更新日志](CHAGELOG.md)

1.0.6 Ultimate（当前）
- [x] 初步适配 English
- [x] 进一步整理现有代码架构
- [x] 修复一些BUG

1.0.7 【整装待发】（2026年Q4）
- [ ] 迁移到 Minecraft 26.3
- [ ] 在代码中解耦游戏地图，并增加一个新地图
- [ ] 加入地图边界检测系统，防止玩家迷路
- [ ] 重制航空兵的**雷枪**
- [ ] 性能优化
- [ ] 小bug修复

1.1 【新航线】（2027年Q1）
- [ ] 海战系统！
- [ ] BOT系统（第一版）
- [ ] 新手教程
- [ ] 修复因为适配26.3产生的BUG

1.1.1 【无人智胜】（2027年Q2）
- [ ] 彻底移除**赐福系统的残余部分**，然后加入**战场支援系统**
- [x] 加入一些无人装备
……


## 繁體中文
希望使用繁體的同胞們看得舒服一點！
---

### 一、項目簡介

**棟記（冬季）戰場（Dong's MC Warfare）** 是一個基於《我的世界》Java 版 1.21.11 的多人對抗資料包。它不是小遊戲插件，不是命令方塊堆砌的臨時娛樂，而是一個由資料驅動、支援多語言與主題包的**完整對戰平台**。

取名為*棟記*戰場，是為了紀念為《冬季戰場》開發提供寶貴支援的 Minecraft 超級棟服腐竹**GNOD728**。沒有超級棟服的支援，我們做不出這個小東西。
當然，我們*號為張楚*也是經過了 GNOD728 本人的允許，也歡迎大家去玩他製作的*冬季戰場：極地潛兵*。

~~其實本來叫 Winter Battlefield 的，但是這和 EA 的 Battlefield 太像了，所以改成現在的名字，大家覺得我們的諧音梗水準怎麼樣呢？~~

**核心理念**：免費、公平、文化傳播、玩家共創。

- **免費**：永遠不收一分錢，如果有人讓你付費購買，你就被騙了。
- **公平**：禁止外掛，不搞課金變強，每一場勝負只取決於你的操作和配合。
- **文化傳播**：從「雪域龍騰」到「極地潛兵」，冬戰可以被任何人改寫成任何文化主題。
- **玩家共創**：每一個測試員、每一個提交翻譯鍵的人、每一個在 60144 發過「Ciallo～」的人，都是冬戰的共建者。

**一句話定義**：
**在冰原上打一場 15 分鐘的攻防戰，用兵種、飛彈和步話機，寫下自己的戰爭故事。**

**部分程式碼和介紹由 Deepseek 生成**
~~反過來說，剩下的部分就是我們親自寫的~~

---

### 二、快速開始

#### 1. 安裝
- **資料包**：將 `djzc444.zip` 放入存檔的 `datapacks` 資料夾。（如果您使用了我們提供的存檔進行遊玩，可以跳過這一步）
- **資源包**：將 `賽揚的冬季戰場v1.0.6.zip` 放入 `resourcepacks` 資料夾，並在遊戲中載入（**將優先級調到最高**）。
> 聽說你的網路太卡了下載不到我們的資源包？
>  沒問題，你可以把*資料包*塞進資源包資料夾，我們往裡面塞了一套備用的檔案！
- **可選主題包**：如需「雪域龍騰」或「極地潛兵」，同樣放入資源包資料夾，優先級高於預設包。

- **或者即將推出的「冬季戰場優化整合包」**：平常怎麼裝整合包就怎麼裝這個。

> 📌 提示：強烈推薦使用伺服器或區域網路進行多人對戰。雖然單人模式也可體驗遊戲的部分內容，但多人遊戲是我們推薦的遊玩方式。

#### 2. 進入遊戲
- 建立或進入世界後，你會自動獲得 **冬戰成員用書**（一本成書）。
- **按 G 鍵**（或右鍵成員用書）開啟主選單。記得調整影片設定，否則 *GUI 會被截斷*。

#### 3. 第一次對戰流程
1. **選擇陣營**：CT（防守方）或 T（進攻方）。
  - CT：阻止 T 佔領全部戰區，拖到 15 分鐘結束即獲勝。
   - T：佔領全部四個戰區（A、B、C、D）即獲勝。
2. **選擇兵種**：從 8 個兵種中選擇一個。
3. **點擊「準備」**：等待所有玩家準備，遊戲會自動開始。
4. **傳送**：在成員用書中開啟「傳送系統」，選擇戰區、發射器或在隊友身邊出發。
5. **開戰**：使用步話機（G 鍵選單內）傳送指令，配合隊友佔點、啟動發射器、發射飛彈。

#### 4. 基本操作速記
- **G 鍵**：主選單（兵種、傳送、步話機、百科）
- **右鍵成員用書**：效果同上
- **步話機指令**：在主選單中點擊預設訊息（如「進攻 D 點！」、「發現敵人！」）
- **飛彈發射**：手持飛彈（如「空對空飛彈」），右鍵發射。
- **干擾飛彈**：右鍵干擾彈，你的上下左右前後會彈出幾隻雞，飛彈會追蹤牠們。

> ⚠️ 注意：敵方玩家頭頂**沒有名字！**你可以透過盔甲紋飾顏色（CT 藍色 / T 紅色）和外觀辨識場上的人是敵是友。

---

### 三、遊戲機制詳解

#### 1. 戰區與佔領
以我們的第一張地圖**冬季戰場**為例：
- **四個戰區**：A（冰湖北側）、B（冰刺之地南側）、C（雪原村莊中心）、D（CT 家後方冰湖）。
- **佔領規則**：
  - T 方進入戰區 → 增加佔領進度；CT 方進入 → 減少進度。
  - 離開戰區不會重置進度（保留已佔領比例）。
  - 雙方同時進點時，T 方進度增加效率減半，CT 方無法減少進度。
  - CT 無法奪回已被 T 完全佔領的點位。
- **佔點時間**：60 秒。

#### 2. 發射器（C/D 點前置條件）
- **C 點發射器**（C1、C2、C3）：分別位於南側戰壕碉堡、村莊地道、北部山腰。
- **D 點發射器**（D1、D2、D3）：分別位於碉堡、燈塔地下室、CT 出生點。
- **啟動方式**：佔領 B 點後，發射器會高亮；玩家需**旋轉物品展示框約一圈（右鍵 7 次）**。
- **全部啟動後**：對應戰區開放佔領。
- **自動修理**：如果展示框被意外擊毀，系統會自動重新放置。

#### 3. 兵種系統
| 大類 | 亞種 | 定位 |
|------|------|------|
| **突擊兵** | 近戰兵（盾斧劍）、三叉戟兵（破盾戟） | 正面推進 |
| **偵察兵** | 狙擊手（大狙弓）、遊騎兵（高速矛） | 遠程壓制/騷擾 |
| **支援兵** | 防空兵（原版機槍+霰彈弩+地對空飛彈）、岡格尼爾（秒殺三叉戟） | 火力支援/輔助 |
| **航空兵** | 立體機動裝置（飛彈+雷槍）、板載兵（就是你想的那個，不建議玩，因為這很瘋狂） | 制空與奇襲 |

- **條件限制**：航空兵在 5 殺後解鎖；板載兵每人每局僅限一次。

#### 4. 飛彈與空戰
- **飛彈類型**：
  - 空對空飛彈：追蹤敵方空中單位。
  - 空對地飛彈：追蹤地面單位。
- **發射與干擾**：右鍵發射；任何投擲物（雞蛋、雪球）都會吸引飛彈追蹤，可用於欺騙。
- **警報系統**：當敵方飛彈進入 100 公尺內，**每秒發出一次警報**。
- **機場補給**：
  - 己方機場停留 30 秒 → 獲得 4 枚空對空、8 枚空對地飛彈。
  - 接近敵方機場（<75 公尺且有敵方單位）→ 機場自動發射地對空飛彈。
  - 機場設有 **彈射器**（絆線鉤+命令方塊），給予速度和漂浮效果，模擬現實中的彈射器。

#### 5. 步話機與戰術通訊
- **MK.IV 步話機**：基於對話框的預設指令系統。
- **12 條指令**：包含「進攻 D 點」、「防守 D 點」、「發現敵人」、「我來助你」等。
- **彩蛋指令**：`Ciallo～(∠・ω< )⌒★` —— 彩蛋。
- **使用方式**：G 鍵主選單 →「轉到步話機」→ 點擊對應訊息。

#### 6. 傳送系統
- **傳送點**：包括戰區、發射器、出生點、機場、隊友身邊等。
- **條件限制**：
  - 只能傳送到己方控制的區域。
  - 地下（Y<40）可隨意傳送（用於配裝中心）。
  - 傳送到最近或隨機隊友。
- **舊版傳送器**：保留但已加警示標語，建議使用新版。

#### 7. 特殊機制
- **轟炸塔**：地圖中隱藏的觀測塔，使用「轟炸指示器」標記區域，標記落地 10 秒後爆炸，傷害半徑 14 公尺，有傷害梯度（**可能炸死自己或者隊友**）。
- **自動設定重生點**：
  - 開局時重生點自動設為地下配裝處。
  - 遊戲結束時重生點移到隊伍選擇器附近。
  - 腐竹再也不用擔心玩家到處亂跑了！
- **防破壞**：所有生存模式玩家進入伺服器後自動設為冒險模式，無法破壞方塊。

#### 版本規劃
[這是更新日誌](CHAGELOG.md)
1.0.6 Ultimate（當前）
- [x] 初步適配 English
- [x] 進一步整理現有程式碼架構
- [x] 修復一些 BUG

1.0.7 【整裝待發】（2026 年 Q4）
- [ ] 遷移到 Minecraft 26.3
- [ ] 在程式碼中解耦遊戲地圖，並增加一個新地圖
- [ ] 加入地圖邊界檢測系統，防止玩家迷路
- [ ] 重製航空兵的**雷槍**
- [ ] 效能優化
- [ ] 小 bug 修復

1.1 【新航線】（2027 年 Q1）
- [ ] 海戰系統！
- [ ] BOT 系統（第一版）
- [ ] 新手教學
- [ ] 修復因適配 26.3 產生的 BUG

1.1.1 【無人智勝】（2027 年 Q2）
- [ ] 徹底移除**賜福系統的殘餘部分**，然後加入**戰場支援系統**
- [x] 加入一些無人裝備
……

## English
Don't worry, we're saving up token money for translation.
---

### I. Project Overview

**Dong's MC Warfare** is a multiplayer combat data pack based on Minecraft Java Edition 1.21.11. It is not a mini-game plugin or a temporary command-block contraption. It is a **complete combat platform** converted from a command-block project, driven by data, and supporting multiple languages and themed resource packs.

The name *Dong's MC Warfare* commemorates **GNOD728**, the owner of **Super Dong Server**, whose valuable support helped develop the original Dong's MC Warfare project. Without Super Dong Server's support, we could not have made this little project.
Of course, brrowing his name was also used with GNOD728's permission. You are also welcome to try his project, *Dong's MC Warfare: Polar Diver Pack*.

~~It was originally going to be called Winter Battlefield, but that sounded too much like EA's Battlefield, so we changed it to its current name. What do you think of our pun?~~

**Core principles**: free, fair, cultural expression, and player co-creation.

- **Free**: We will never charge a cent. If someone asks you to pay for it, you are being scammed.
- **Fair**: Cheats are forbidden, and paying cannot make you stronger. Every match is decided by your skill and teamwork.
- **Cultural expression**: From the Snowland Dragon Soar theme to the Polar Diver theme, Dong's MC Warfare can be rewritten by anyone around any cultural theme.
- **Player co-creation**: Every tester, everyone who submits a translation key, and everyone who has posted “Ciallo~” in 60144 is a co-builder of Dong's MC Warfare.

**In one sentence**:
**Fight a 15-minute attack-and-defense battle on an ice plain, using classes, missiles, and radios to write your own war story.**

**Some of the code and introduction were generated by DeepSeek.**
~~In other words, we wrote everything else ourselves.~~

---

### II. Quick Start

#### 1. Installation
- **Data pack**: Put `djzc444.zip` in the world's `datapacks` folder. (You can skip this step if you are using the world save we provided.)
- **Resource pack**: Put `Saiyang's Dong's MC Warfare v1.0.6.zip` in the `resourcepacks` folder and load it in-game (**set its priority to the highest**).
> Heard your internet is too slow to download our resource pack?
>  No problem—you can put the *data pack* inside the resource pack folder; we included a backup set for that.
- **Optional themed resource packs**: To use Red Loong or Polar Diver, also place the corresponding resource pack in the resource packs folder and give it a higher priority than the default pack.

- **Or use the upcoming “Dong's MC Warfare Optimization Modpack”**: install it the same way you would install any other modpack.

> 📌 Tip: We strongly recommend using a server or LAN multiplayer for combat. Although single-player lets you experience some of the game, multiplayer is the intended way to play.

#### 2. Entering the Game
- After creating or entering a world, you will automatically receive the **Dong's MC Warfare Member Handbook** (a written book).
- **Press G** (or right-click the Member Handbook) to open the main menu. Remember to adjust your video settings, or the *GUI may be cut off*.

#### 3. Your First Match
1. **Choose a team**: CT (defenders) or T (attackers).
  - CT: prevent T from capturing every combat zone. Survive until the 15-minute timer ends to win.
   - T: capture all four combat zones (A, B, C, and D) to win.
2. **Choose a class**: select one of the eight classes.
3. **Click “Ready”**: the game starts automatically when all players are ready.
4. **Teleport**: open the Teleportation System in the Member Handbook and choose a combat zone, launcher, or teammate.
5. **Fight**: use the radio in the G-key menu to send commands, capture points with your teammates, activate launchers, and fire missiles.

#### 4. Basic Controls
- **G**: main menu (classes, teleportation, radio, and wiki)
- **Right-click the Member Handbook**: same effect as pressing G
- **Radio commands**: click preset messages in the main menu, such as “Attack point D!” or “Enemy spotted!”
- **Fire missiles**: hold a missile, such as an air-to-air missile, and right-click to launch it.
- **Jamming missiles**: right-click a jamming missile. Several chickens will appear around you, and the missile will track them.

> ⚠️ Note: Enemy players have **no name above their heads!** Identify players by their armor trim colors (blue for CT / red for T) and their appearance to determine whether they are friend or foe.

---

### III. Detailed Game Mechanics

#### 1. Combat Zones and Capture
Using our first map, **Dong's MC Warfare**, as an example:
- **Four combat zones**: A (north of the ice lake), B (south of the Ice Spikes), C (the center of the snowy village), and D (the ice lake behind the CT base).
- **Capture rules**:
  - T entering a combat zone increases capture progress; CT entering decreases it.
  - Leaving a combat zone does not reset its progress. The captured percentage is retained.
  - If both teams are in the zone, T's capture speed is halved and CT cannot reduce progress.
  - CT cannot recapture a point fully captured by T.
- **Capture time**: 60 seconds.

#### 2. Launchers (Prerequisites for Points C and D)
- **C-point launchers** (C1, C2, C3): located in the southern trench bunker, the village tunnel, and the northern hillside.
- **D-point launchers** (D1, D2, D3): located in the bunker, the lighthouse basement, and the CT spawn point.
- **Activation**: after point B is captured, the launchers are highlighted. Players must **rotate the item frame approximately one full turn (right-click seven times)**.
- **After all launchers are activated**: the corresponding combat zone becomes available for capture.
- **Automatic repair**: if an item frame is accidentally destroyed, the system automatically places it again.

#### 3. Class System
| Category | Subclass | Role |
|------|------|------|
| **Assault** | Melee (shield, axe, and sword), Trident (shield-breaking trident) | Front-line assault |
| **Recon** | Sniper (heavy sniper bow), Ranger (high-speed spear) | Long-range suppression and harassment |
| **Support** | Anti-air (vanilla machine gun, shotgun crossbow, and surface-to-air missiles), Gungnir (one-hit-kill trident) | Fire support and assistance |
| **Air** | 3D Maneuver Gear (missiles and lightning spear), Boarder (you know the one; not recommended because it is absolutely wild) | Air superiority and surprise attacks |

- **Restrictions**: the Air class unlocks after five kills; each player may use the Boarder class only once per match.

#### 4. Missiles and Air Combat
- **Missile types**:
  - Air-to-air missiles: track airborne enemy units.
  - Air-to-ground missiles: track ground units.
- **Launching and jamming**: right-click to launch. Any projectile, such as an egg or snowball, attracts missile tracking and can be used as a decoy.
- **Warning system**: when an enemy missile comes within 100 meters, a warning is issued **once every second**.
- **Airfield resupply**:
  - Stay at your team's airfield for 30 seconds → receive 4 air-to-air and 8 air-to-ground missiles.
  - Approach an enemy airfield (within 75 meters and with an enemy unit present) → the airfield automatically launches surface-to-air missiles.
  - Airfields have **catapults** (tripwire hooks and command blocks) that grant Speed and Levitation, simulating a real aircraft catapult.

#### 5. Radio and Tactical Communication
- **MK.IV Radio**: a preset command system based on dialogue boxes.
- **12 commands**: including “Attack point D,” “Defend point D,” “Enemy spotted,” and “I’m coming to help.”
- **Easter egg command**: `Ciallo~(∠・ω< )⌒★` — an easter egg.
- **How to use**: G-key main menu → “Go to Radio” → click the desired message.

#### 6. Teleportation System
- **Teleport destinations**: combat zones, launchers, spawn points, airfields, teammates, and more.
- **Restrictions**:
  - You can only teleport to areas controlled by your team.
  - You can teleport freely underground (Y<40), which is intended for the loadout center.
  - You can teleport to the nearest or a random teammate.
- **Legacy Teleporter**: retained with a warning label; the new system is recommended.

#### 7. Special Mechanics
- **Bombing Tower**: a hidden observation tower on the map. Use the “Bombing Designator” to mark an area. It explodes 10 seconds after the marker lands, with a 14-meter damage radius and damage falloff (**you may kill yourself or your teammates**).
- **Automatic spawn points**:
  - At the start of a match, your spawn point is automatically set to the underground loadout area.
  - When the game ends, it is moved near the team selector.
  - The server owner no longer has to worry about players running all over the place!
- **Block protection**: all players in Survival mode are automatically set to Adventure mode when they enter the server and cannot break blocks.

#### Version Roadmap
[This is changelog](CHAGELOG.md)
1.0.6 Ultimate (current)
- [x] Initial English adaptation
- [x] Further organization of the existing code architecture
- [x] Fixed some bugs

1.0.7 [On the Verge of Release] (Q4 2026)
- [ ] Migrate to Minecraft 26.3
- [ ] Decouple the game map from the code and add a new map
- [ ] Add a map boundary detection system to prevent players from getting lost
- [ ] Rebuild the Air Force's **Lightning Spear**
- [ ] Performance optimization
- [ ] Minor bug fixes

1.1 [New Route] (Q1 2027)
- [ ] Naval combat system!
- [ ] BOT system (first version)
- [ ] Beginner tutorial
- [ ] Fix bugs caused by adapting to 26.3

1.1.1 [Unmanned Victory] (Q2 2027)
- [ ] Completely remove the remaining parts of the **Blessing system**, then add a **Warfare support system**
- [x] Add some unmanned equipment
……