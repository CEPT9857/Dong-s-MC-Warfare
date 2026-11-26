# 冬季战场数据包接口文档

这份文档对着 `datapacks/djzc444/` 里现在跑的代码写。菜单、对话框和 `trigger` 交互算玩家能碰到的接口，其余函数按内部实现看，改的时候别当稳定 API 用。

## 1. 基本信息

| 项目 | 内容 |
| --- | --- |
| 数据包 | 冬季战场（Dong's MC Warfare） |
| 当前文档对象 | 工作区当前代码 |
| 版本名 | `1.0.7-1128-by-CE_PT`（CHANGELOG 已开条目，`end` 日期待补） |
| Git HEAD | `72cd29c`（`1.0.7-1123-by-CE_PT`）；此后为未提交的工作区改动 |
| Minecraft 版本 | Java 版 1.21.11 |
| 数据包格式 | `min_format` `94.1`，`max_format` `101.1` |
| 主要命名空间 | `djzc444` |
| 相关命名空间 | `djzc555`、`djzc666`、`djzc777`、`djzc888` |
| 函数目录 | `data/<namespace>/function/` |
| 函数调用格式 | `function <namespace>:<路径>` |
| 数据包根目录 | `datapacks/djzc444/` |

## 2. 目录树

整包长这样。每个节点后面那句就是它干的事。

```
datapacks/djzc444/
├── pack.mcmeta                    数据包格式、版本范围、菜单里显示的描述
├── pack.png                       数据包图标
├── README.md                      面向玩家和维护者的说明
├── CHANGELOG.md                   版本更新日志
├── Developer Document.md          这份接口文档
├── assets/                        数据包自带的备用翻译（四语言）
└── data/
    ├── minecraft/
    │   └── tags/
    │       ├── function/
    │       │   ├── load.json      加载时跑的函数清单
    │       │   └── tick.json      每 tick 跑的函数清单
    │       ├── block/
    │       │   └── raycast.json   射线穿透方块清单（定义了，目前没接线）
    │       └── dialog/
    │           ├── quick_actions.json        G 键快捷入口
    │           └── pause_screen_actions.json ESC 暂停菜单入口
    ├── djzc444/                   主命名空间，流程、占点、兵种、传送、对话框、武器、统计
    │   ├── advancement/
    │   │   ├── fight/             可见战绩与武器成就，root 在加载和开局时发
    │   │   ├── intro/             增益介绍成就
    │   │   └── tool/              隐藏工具成就，航空兵解锁、刺雷
    │   ├── damage_type/           missile / mine 伤害类型
    │   ├── dialog/
    │   │   ├── *.json             静态对话框（协议、阵营、步话机、统计、管理用书等）
    │   │   └── wiki/              百科全书页面，含两张地图的分页
    │   ├── enchantment/           burstshot 附魔
    │   ├── item_modifier/         轰炸/雷枪耐久，以及护甲纹饰同步的修饰器
    │   ├── predicate/             位置、装备、按键、状态谓词
    │   └── function/
    │       ├── load.mcfunction    建计分板、队伍、BossBar，做首次启动配置
    │       ├── tick.mcfunction    每 tick 的主调度，按顺序调下面各模块
    │       ├── advancement/       成就检测
    │       ├── buff/              增益效果与清理
    │       ├── ctmsg/ tmsg/       两阵营步话机消息处理
    │       ├── dialog/            动态对话框宏函数，从 storage 读参数
    │       ├── game/              对局流程、时钟、输入分发、战斗、支援、护甲同步和空战曲 `music_af`
    │       ├── option/            管理选项、阵营、统计、测试工具
    │       ├── points/            A-D 战区、启动器、机场
    │       ├── support/           手动支援工具函数，没接进主 tick
    │       ├── tp/                传送目的地处理
    │       ├── type/              兵种选择、配装（含统一护甲发放）、兵种管理预设
    │       └── weapon/            武器、装备、盾牌和成书发放
    ├── djzc555/                   射线检测
    │   └── function/
    │       ├── load.mcfunction    建 ray_* 计分板，写默认粒子配置
    │       ├── tick.mcfunction    每 tick 驱动 sleep 模式的射线
    │       └── raycast/
    │           ├── block.mcfunction         通用方块检测入口
    │           ├── entity.mcfunction        通用实体检测入口
    │           ├── ground.mcfunction        轰炸指示器入口，固定即时 + end_rod
    │           ├── rocket.mcfunction        雷枪入口，固定即时 + campfire_cosy_smoke
    │           ├── spawn_at_result.mcfunction 在落点生成 mark3 并设倒计时
    │           ├── particle/
    │           │   ├── end_rod.mcfunction              粒子预设，白色末地烛
    │           │   └── campfire_cosy_smoke.mcfunction   粒子预设，营火烟雾
    │           └── internal/
    │               ├── start.mcfunction    建 marker、复制参数、分即时/异步两条路
    │               ├── step.mcfunction     宏步长前进，调粒子和碰撞检测
    │               ├── particle.mcfunction 宏粒子命令，全包唯一一条 particle
    │               ├── check.mcfunction    方块/实体碰撞判定，sleep 时断递归
    │               ├── hit.mcfunction      写结果、复制副本、回调、按 UID 清标签
    │               ├── miss.mcfunction     同上，结果是未命中
    │               ├── store_result.mcfunction   按 uid 把结果写进独立槽（ray_keep=1）
    │               ├── consume_result.mcfunction 按 uid 取出并删除结果槽
    │               ├── tick_one.mcfunction 单条异步射线的每 tick 计时器
    │               └── on_result.mcfunction 结果回调挂钩，参数是本条结果副本
    ├── djzc666/                   导弹武器、制导、近炸引信、扫描与配置
    │   ├── advancement/tool/      隐藏发射/扫描触发器
    │   ├── predicate/             导弹锁定状态
    │   └── function/              game/ 导弹逻辑，option/ 模式开关，weapon/ 发放
    ├── djzc777/                   新手教程
    │   ├── dialog/tutorial/       教程主页、实境提示、成员用书说明、结束页
    │   └── function/tutorial/     `start`、`end`、`advance`，以及 `option.mcfunction` + `option/` 六个按钮子函数
    └── djzc888/                   地图系统
        └── function/
            ├── map_swich.mcfunction    按 map djzc.map 选地图
            ├── game_map_selection.mcfunction 读玩家提交的地图编号
            ├── tick.mcfunction         每 tick 处理地图选择
            ├── dz_djzc/               冬季战场地图的 main 与 unique
            └── jc_basic/              基础教程地图的 main、unique（事件触发）与 unique_tick（区域检测）
```

命名空间各管一摊。

| 命名空间 | 职责 |
| --- | --- |
| `djzc444` | 主数据包，流程、占点、兵种、传送、对话框、武器、统计 |
| `djzc555` | 射线检测。`game/lib_boom_single` 调 `raycast/ground`，`game/lib_rocket_fire` 调 `raycast/rocket`，`raycast/spawn_at_result` 生成落点标记 |
| `djzc666` | 导弹武器、制导、近炸引信、扫描和配置。机场、兵种、管理菜单会调它的函数 |
| `djzc777` | 新手教程，`djzc777:open` 开主页，`tutorial/start` 和 `tutorial/end` 控制实境教程 |
| `djzc888` | 地图系统，`map_swich` 按 `djzc.map` 选 `dz_djzc` 或 `jc_basic`，地图 `main.mcfunction` 把战区、启动器、机场和传送点写进 `storage djzc:map` |

## 3. 接口约定

- 函数用命名空间 ID 调用，比如 `function djzc444:option/boost`。
- 函数会读当前的执行者、位置、维度上下文。调用前先看清它要不要玩家执行者（`@s`）、队伍、实体标签或者特定坐标。
- 玩家菜单把选项写进 `trigger` 计分板，tick 函数再读出来分发。
- `djzc.*` 这些目标装着游戏流程、玩家统计和内部计算状态。除了[第 5 节](#5-玩家输入接口trigger)列的 `trigger` 入口，外部别直接改。
- 对话框、物品和记分板显示属于交互接口，按钮和使用行为执行的命令也算在里面。

### 3.1 代码范式

按领域拆函数。命名空间区分组件，`game/`、`points/`、`tp/`、`type/`、`weapon/`、`dialog/` 再按职责分文件。入口负责编排，具体动作丢给子函数。

调度靠 `load` 和 `tick` 标签。`tick` 每个游戏刻查一次对局阶段、玩家分数和谓词，然后调对应处理函数。菜单请求写进 `trigger` 目标，也是 tick 来收。

高频路径用 Guard Clause 提前返回：`execute if <条件> run return fail` / `return run function` 挡在开头，后面的命令就不必每条再挂同一个 `if/unless`。`game/lib_books`（右键成书分发）、`game/time_custom`（常驻时钟）、`djzc666:game/lib_missile_track_do`（导弹制导分发）已这么改。低频函数（60 秒调度、按钮触发）不必为结构改动冒风险，保持原样。

状态放计分板。玩家状态、统计、对局流程、战区进度、菜单请求都在里面，函数用 `execute if/unless score` 判断和推进。结构化参数和动态界面数据走 Storage。

执行上下文是隐式输入。函数不收显式参数，靠执行者、位置、队伍、标签、谓词和计分板。复用一个函数之前，把 `@s`、`@p`、`as`、`at` 挨个核一遍，作用错实体这种事排查起来很费时间。

交互层调业务逻辑。对话框按钮执行 `trigger` 或函数，tick 分发器读完请求再去找兵种、传送、统计这些模块。

地图数据和逻辑拆开。坐标通过 `storage djzc:map` 注入，函数用宏参数读 `x`、`y`、`z`、`dx`、`dy`、`dz`、`name`。加新地图写同结构的 `main.mcfunction` 和 `unique.mcfunction` 就行，整套业务函数不用复制。

留了一处硬编码。对局开始、教程结束和默认重生点还写死在 `dz_djzc` / `jc_basic` 的起始区域坐标上，迁移地图时得一起核。

新增状态之前，先想清楚它该挂在玩家计分项还是虚拟玩家计分项，再把初始化位置、tick 调度和所有读写点找齐。这一步偷懒，后面会花几倍时间补。

### 3.2 AI须知
[AEGENTS.md](AEGENTS.md)

## 4. 生命周期入口

生命周期函数注册在 `data/minecraft/tags/function/`。

| 入口 | 注册内容 | 用途 |
| --- | --- | --- |
| `minecraft:load` | `djzc444:load`、`djzc555:load`、`djzc666:load`、`djzc777:load`、`djzc888:load` | 初始化计分板、队伍、BossBar、地图元数据，顺带打一条加载提示。加载数据包或 `/reload` 时触发 |
| `minecraft:tick` | `djzc444:tick`、`djzc444:advancement/detection`、`djzc666:tick`、`djzc888:tick`、`djzc555:tick` | 按标签顺序跑对局逻辑、成就检测、导弹系统、地图选择，以及 sleep 模式射线的每 tick 驱动 |

`djzc444:load` 还干这些。

- 设置 `keep_inventory`、`players_sleeping_percentage` 等游戏规则
- 发放 `djzc444:fight/root` 和 `djzc444:intro/root` 成就
- 世界出生点和玩家出生点设为 `-434 41 -709 -505 0`
- 创建 `djzc.gameflow`、`djzc.time` 等目标，`starter` / `T` / `CT` 队伍，`djzc_game:time` / `djzc_point:*` BossBar
- 调 `djzc444:game/game_eula` 显示欢迎界面，每 60 秒查一次还有谁没同意协议
- `initialize djzc.option` 不等于 `1` 时，调 `djzc444:initialize` 做首次启动配置

`djzc444:tick` 的顺序大致是。

1. 对局主时钟和常驻时钟
2. 准备系统（`game/game_prepare`）
3. 生存模式玩家强制转冒险
4. 重新启用所有玩家的 `trigger` 目标
5. 步话机、成员用书、成书检测
6. 兵种选择与传送系统，非 debug 模式要求玩家 Y 在 `-100..40`
7. 同意协议后的阵营选择
8. 垂直机动、新星、三连发、轰炸指示器、雷枪、烟雾弹、无人机、干扰弹
9. 阵亡计分板
10. 占点系统与启动器系统

首次启动存档时 `djzc444:initialize` 会多做一摊事，开 boost、复位 debug / 导弹模式 / 兵种开关、跑一次 `second` 和 `time_initialize`、启动并立刻结束一局把参数写进去、显示血量、发首次启动提示，最后把 `initialize djzc.option` 设成 `1`。它会动对局状态，别拿它当普通重载用。已有存档里要调，先备份，再确认当前状态。

## 5. 玩家输入接口（Trigger）

tick 会重新启用玩家的 `trigger` 目标，然后读请求、分发处理。提交形式就一句。

```mcfunction
trigger <objective> set <value>
```

| 目标 | 已确认用途 | 值域/说明 |
| --- | --- | --- |
| `djzc.prepare` | 提交准备状态 | 准备阶段 `1` 已准备，`0` 取消。至少一名已加入 CT/T 的玩家在线，且所有 CT/T 玩家都是 `1` 时开局 |
| `djzc.type_choose` | 选兵种 | `1` 近战兵（JZB）、`2` 狙击手（JJS）、`3` 防空兵（FKB）、`4` 立体机动/航空兵（LTJD）、`5` 三叉戟兵（SCJ）、`6` 游骑兵（YQB）、`7` 冈格尼尔（GGNE）、`8` 板载兵（BZB） |
| `djzc.tp` | 选传送目的地 | 编号见[5.1](#51-传送编号)，能不能去由对应 `tp/` 函数判 |
| `djzc.ctmsg` | CT 步话机 | `1` 赞成、`2` 反对、`3` 冲锋、`4` 撤退、`5` 发现敌人、`6` 请求支援、`7` 掩护、`8` 彩蛋、`9-12` 进攻 A-D、`13-16` 防守 A-D |
| `djzc.tmsg` | T 步话机 | 编号同上，由 `function/tmsg/` 里对应编号的函数处理 |
| `djzc.option` | 成员用书和菜单操作 | `1-7` 侧边栏统计、`8` 统计菜单、`9` 加入 CT、`10` 加入 T、`11` 兵种选择、`12` 步话机、`13` 重新部署、`14` 中止个人音乐、`15` 成员用书、`16` 传送系统、`17` 兵种管理、`18` 地图选择；`100-105` 为新手教程按钮（见[7.5](#75-新手教程djzc777)），由 `djzc777:tutorial/option` 每 tick 消费。`19` 号段空闲 |
| `djzc.eula` | 用户协议 | 点同意提交 `-1`，tick 处理成 `1` 并打开阵营选择。`1` 表示已同意 |
| `djzc.map` | 地图选择 | `1` 冬季战场（`dz_djzc`）、`2` 教程-基础教程（`jc_basic`） |

### 5.1 传送编号

| 值 | 目的地 |
| --- | --- |
| `1` | 最近的队友 |
| `2` | 随机队友 |
| `3-5` | A 点、B 点、C 点 |
| `6-8` | C1、C2、C3 启动器 |
| `9-12` | D 点、D1、D2、D3 启动器 |
| `13-14` | CT 出生点 1、2 |
| `15-16` | T 出生点 1、2 |
| `17-18` | CT 空中出生点、CT 机场 |
| `19-20` | T 空中出生点、T 机场 |

### 5.2 地图编号

| 值 | 地图代码 | 说明 |
| --- | --- | --- |
| `1` | `dz_djzc` | 冬季战场，第一张地图，带机场和空中出生点 |
| `2` | `jc_basic` | 教程-基础教程，用于新手教程，也带机场和“空中出生点” |

玩家交上来的 `djzc.map` 分值由 `djzc888:game_map_selection` 读走，写进虚拟玩家 `map djzc.map`，`djzc888:map_swich` 再按它加载地图配置。

### 5.3 Trigger 调用约束

- tick 会重新启用在线玩家的 `trigger` 目标。目标没启用，玩家就交不了对应的 `trigger` 命令。
- 菜单用 `trigger <objective> set <value>` 提交，tick 分发。处理函数一般会把玩家分值清掉。
- `djzc.option` 一边收菜单请求，一边存配置值（`boost`、`debug`、`harmony`、`missile_mode`、`track_type` 这些虚拟玩家分值）。玩家自己在这个目标上的分值别当持久配置读。
- `djzc.map` 的复位现在是坏的。`game_map_selection` 末尾那句 `scoreboard players reset @s djzc.map` 不在 `as @a` 上下文里，tick 顶层的 `@s` 没有实体。玩家交过一次地图编号，分值就一直留着，每 tick 把 `map` 虚拟玩家重设成同一个编号，地图跟着反复加载。多人留了不同编号还会按选择器顺序互相盖。想让它一次性生效，手动清玩家分值，或者把那行修了。
- 对外集成优先复用游戏内菜单。直接交 `trigger` 会绕过界面层的限制，还得自己检查处理函数有没有校验权限、阵营、对局阶段。
- 管理用书的展示入口有 `select_opbook` 谓词挡着，可 tick 对 `djzc.option=17` 的分发没判 OP。能交这个值的玩家就能打开兵种管理对话框。这个入口要是只该给 OP 用，得在分发逻辑里补权限校验，然后进游戏验一遍。

### 5.4 兵种选择限制

- 八个兵种的选择函数都查 `jzb` / `jjs` / `fkb` / `ltjd` / `scj` / `yqb` / `ggne` / `bzb` 在 `djzc.type` 里的开关。兵种被禁时提示「该兵种目前已被游戏禁用」。
- 航空兵（`djzc.type_choose=4`）要先拿到本局解锁进度 `djzc444:tool/hkb`。`advancement/detection` 在本局击杀数 `djzc.count_kill >= 立体机动 djzc.type`（当前 `5`）时发进度，没解锁会提示「击杀数小于5，无法购买」。
- 板载兵（`djzc.type_choose=8`）每局一次。选的时候给玩家自己的 `djzc.type` 加 `1`，跟虚拟玩家 `神风特攻`（当前 `1`）比；再选就提示「你已玉碎，无法购买」。
- 其余兵种没有击杀门槛。配装、重生、传送行为在各自的 `type/` 函数里。
- 选成功之后 `weapon/books_all` 会把步话机和成员用书一起发下去。

### 5.5 传送与步话机细则

- 非 debug 模式，玩家 Y 在 `-100` 到 `40`（含边界）之间 tick 才处理兵种选择和传送请求。debug 模式（`debug djzc.option=1`）不管高度。
- A、B 点看对应战区流程分值，`0` 放 CT 进、挡 T，非 `0` 反过来。
- C、D 点用另一套值，`0` 放 CT，`-1` 放 T，`1`（已开放未占领）两边都不让直接传。占领后流程把分值置 `-1`。
- C1-C3、D1-D3 启动器点位分值 `0` 放 CT，非 `0` 放 T。出生点、空中出生点和机场只认对应阵营。
- 「最近队友」用同队选择器，靠至少 `1` 格的距离把自己排掉；「随机队友」用同队随机选择器，没明确排自己。两个都播本队的「我来助你」。
- 步话机 `1-7` 和 `9-16` 只发本队，`8` 的 Ciallo 发给所有人。默认文案如下。

| 值 | CT/T 步话机 fallback 文案 |
| --- | --- |
| `1-2` | 赞成！、反对！ |
| `3-7` | 和我一起冲上去！、撤退！、发现敌人！、请求支援！、我来助你！ |
| `8` | Ciallo～(∠・ω< )⌒★！ |
| `9-12` | 进攻 A 点！、进攻 B 点！、进攻 C 点！、进攻 D 点！ |
| `13-16` | 防守 A 点！、防守 B 点！、防守 C 点！、防守 D 点！ |

- 机场逻辑在 `djzc444:points/airport_x`。玩家进机场区域后 `djzc.airport_ct` / `djzc.airport_t` 从 `30` 开始每秒减，归零且带 `AF` 标签时发空空导弹、空地导弹、雷枪、机炮火箭和干扰弹，倒计时重置回 `30`。机场里还有补给倒计时的 actionbar。
- 己方机场有人，且 `75` 格内有敌方 `AF` 单位时，机场给这名玩家发 `djzc666:tool/missile_sam`，靠成就奖励触发一次地对空导弹发射。
- `jc_basic` 的机场和空中出生点字段在配置文件里被注释掉了，这张图不会执行机场补给。传送菜单照样显示 17-20 号按钮，可对应的 `tp_af*` 没坐标时宏调用会失败，之前加载过 `dz_djzc` 的话还可能拿残留旧坐标凑数。

### 5.6 阵营选择与准备

- 阵营只在没开局时（`game djzc.gameflow=0`）能选。对局中从 T 想改投 CT（或反过来）会被 `option/no_run` 挡下，提示「系统拒绝了你的要求，因为这是叛逃。」。选本方阵营不产生变化。
- 准备系统只数 `team=T` 和 `team=CT` 的玩家，没入队的不会挡开局。至少一名已入队玩家在线、且全部已入队玩家都准备时，`game/game_prepare` 调 `game/start`。
- `game/end_custom` 把所有人的 `djzc.prepare` 清成 `0`，并显示「点此再玩一局」的可点文本。

### 5.7 地图选择与开局前置

- 地图选择对话框由 `djzc444:option=18` 打开，两个按钮分别交 `trigger djzc.map set 1` 和 `set 2`。
- 地图配置靠 `djzc888:map_swich` 按虚拟玩家 `map djzc.map` 加载，`game/start` 也会调一次。
- 带 `$(map_name)` 的动态对话框（成员用书、传送系统、地图选择）依赖 `storage djzc:game.map_name`，这个键由地图配置写入。全新存档在首次加载地图前打开这些页，宏参数缺失，对话框渲染不出来。静态 JSON 版成员用书（G 键 / 暂停菜单）本身能开，里面的地图选择链接一样受限制。
- 所以新存档得按这个顺序来，先用 `scoreboard players set map djzc.map 1`（或直接 `function djzc888:dz_djzc/main`）把地图写进去，再碰成员用书、传送和开局流程。

### 5.8 管理接口

管理用书（`custom_data.tags` 含 `opbook`）可以直接调。

```mcfunction
function djzc444:weapon/book_opbook
```

它会打开动态管理菜单（`dialog/op_dialog`），里面有 Boost 开关 `djzc444:option/boost` / `unboost`，debug 开关 `scoreboard players set debug djzc.option 0|1`，强制启动和中止 `djzc444:game/start` / `end_custom`，和谐冬战开关 `do_harmony` / `no_harmony`（会改地图里的旗帜图案），导弹制导模式 `djzc666:option/do_missile_vector`（`missile_mode=1`）和 `do_missile_tp`（`missile_mode=0`），导弹目标判定 `do_track_predicate`（`track_type=1`）和 `do_track_tag`（`track_type=0`）。

静态管理对话框 `djzc444:op` 也能用 `/dialog show @s djzc444:op` 直接开。它不显示实时状态栏，按钮行为和动态版一致。欢迎界面里给管理员提了这个入口。

## 6. 对话框接口

### 6.1 静态 JSON 对话框

下面这些定义在 `data/djzc444/dialog/` 或 `data/djzc777/dialog/`，`dialog show @s <id>` 直接开，执行者得是玩家。

| 对话框 ID | 用途 | 打开方式 |
| --- | --- | --- |
| `djzc444:eula_notice` | 用户协议与欢迎界面 | `game/game_eula` 每 60 秒查未同意玩家 |
| `djzc444:team_selection` | 阵营选择 | 玩家交 `djzc.eula=-1` 后由 tick 打开 |
| `djzc444:scoreboard` | 统计信息菜单 | `djzc.option=8` |
| `djzc444:ctmsg` / `djzc444:tmsg` | CT/T 步话机 | 右键带 `msg` 标签的成书，或 `djzc.option=12` |
| `djzc444:type_choose` | 静态兵种选择页（8 个按钮） | `tutorial_gui3` 里的「兵种选择」链接 |
| `djzc444:userbook` | 静态成员用书 | G 键快捷菜单、暂停菜单、百科返回链接 |
| `djzc444:op` | 静态管理用书 | `/dialog show @s djzc444:op` |
| `djzc444:wiki/wiki_notice` | 百科全书主页 | 成员用书里的「百科全书」链接 |
| `djzc444:wiki/wiki_before_play` | 玩前必看 | 百科主页 |
| `djzc444:wiki/wiki_map` | 地图速览 | 百科主页 |
| `djzc444:wiki/wiki_map_dz_djzc` | 冬季战场地图页 | 地图速览 |
| `djzc444:wiki/wiki_map_jc_basic` | 教程-基础教程地图页 | 地图速览 |
| `djzc444:wiki/wiki_how_to_play` | 游戏流程 | 百科主页 |
| `djzc444:wiki/wiki_type_intro` | 兵种介绍目录 | 百科主页、地图速览 |
| `djzc444:wiki/wiki_type_jzb` 等 8 个页面 | 八个兵种介绍 | 兵种介绍目录 |
| `djzc444:wiki/wiki_credits` | 制作人名单 | 百科主页 |
| `djzc777:tutorial/root` | 新手教程主页 | `function djzc777:open`、暂停菜单 |
| `djzc777:tutorial/tutorial_skip` | 教程跳过/入门选择 | 教程主页 |
| `djzc777:tutorial/tutorial_a` / `b` | 实境教程提示页 | 首次进入 A/B 点区域（`unique_tick`，阶段 1/3） |
| `djzc777:tutorial/tutorial_starter` | 启动器教学页 | 激活任意 C 点启动器（`C1/C2/C3=1`，阶段 5） |
| `djzc777:tutorial/tutorial_c` | C 点占领教学页 | C123=3 全部激活、C 点开放占领（阶段 7） |
| `djzc777:tutorial/tutorial_d` | D 点占领教学页 | 占领 D 点（`D=2`，阶段 9） |
| `djzc777:tutorial/tutorial_gui1` / `gui2` / `gui3` | 成员用书说明页（multi_action）；gui3 含「兵种选择」按钮 | 教程流程，gui1 由 104 号段传送后拉起 |
| `djzc777:tutorial/tutorial_end` | 基础教程结束页 | 任意玩家进入靶场出口区域（x=-388..-386,y=19,z=-749..-751），弹出后置阶段 -2 防重复 |
| `djzc777:tutorial/tutorial_advanced` | 进阶教程占位页 | 教程结束页 |

教程对话框实际在 `data/djzc777/dialog/tutorial/` 子目录下，ID 必须带 `tutorial/` 前缀；原 `tutorial_win` 和 `tutorial_choose` 已删，分别由 `tutorial_d` 和 `tutorial_gui3` 的「兵种选择」按钮接替。

### 6.2 动态（内联）对话框

这些没有静态 JSON 文件，宏函数用 `$dialog show @s { ... }` 现场生成。先把对应 Storage 准备好，再用 `with storage` 调。

| 入口函数 | 生成内容 | 参数来源 | 触发方式 |
| --- | --- | --- | --- |
| `djzc444:dialog/user_dialog` → `dialog/userbook` | 带实时地图名和剩余时间的成员用书 | `storage djzc:game` | 右键成员用书、`djzc.option=15` |
| `djzc444:dialog/tp_dialog` → `dialog/tp_system` | 20 个传送目的地、当前地图名和剩余时间 | `storage djzc:game` | `djzc.option=16`、成员用书退出按钮 |
| `djzc444:dialog/choose_dialog` → `dialog/type_choose` | 带兵种启用状态和颜色的兵种选择页 | `storage djzc:type_manage` | `djzc.option=11` |
| `djzc444:dialog/manage_dialog` → `dialog/type_manage` | 兵种管理系统（复选框、预设、确认） | `storage djzc:type_manage` | `djzc.option=17` |
| `djzc444:dialog/op_dialog` → `dialog/op` | 带实时状态栏的管理用书 | `storage djzc444:op` | 右键管理用书 |
| `djzc444:dialog/map_dialog` → `dialog/map_selection` | 地图选择页（1/2） | `storage djzc:game` | `djzc.option=18` |

旧版静态 `data/djzc444/dialog/tp_system.json` 在 1108 改动里删了，传送系统现在只剩 `dialog/tp_system` 内联版。

共用的参数约定。

- `djzc:game`，`minute` 和 `second` 由 `second.mcfunction` 每秒写，`map_name` 由地图配置写。被 `$(...)` 引用的键缺一个，整次宏调用报错，对话框不显示。
- `djzc:type_manage`，`jzb`…`bzb` 是 `0/1` 开关，`*_color` 文本颜色，`*_ini` 复选框初值，`preset1`…`preset8` 预设单选初值，`template_preset` 和 `template_confirm` 是 `dynamic/run_command` 模板，`minute`、`second` 是时间。
- `djzc444:op`，`boost`、`debug`、`gameflow`、`harmony`、`missile_mode`、`track_type` 是数值，`*_color` 是状态栏颜色。

### 6.3 对话框关系

- 百科主页 `wiki_notice` 连到 `wiki_before_play`、`wiki_map`、`wiki_how_to_play`、`wiki_type_intro`、`wiki_credits`。
- `wiki_map` 连到 `wiki_map_dz_djzc`、`wiki_map_jc_basic`、`wiki_type_intro`。两张地图页互相连，都能回百科主页。
- `wiki_type_intro` 连到八个 `wiki_type_*`，每页回兵种介绍目录。
- `wiki_before_play` 和 `wiki_how_to_play` 的正文链接指向 `wiki_map`，退出按钮都回 `wiki_notice`。
- `userbook` 静态和动态版的正文链接都含百科、统计、地图选择、管理用书，退出按钮进传送系统。
- `tutorial_end` 能结束教程、看进阶占位页或重播教程主页；`tutorial_gui3` 的「兵种选择」按钮直接打开静态 `djzc444:type_choose`。

### 6.4 快捷入口标签

- `data/minecraft/tags/dialog/quick_actions.json` 放 `djzc444:userbook`，按 G 键（`key.quickActions`）打开静态成员用书。
- `data/minecraft/tags/dialog/pause_screen_actions.json` 放 `djzc444:userbook` 和 `djzc777:tutorial/root`，ESC 暂停菜单能开成员用书或新手教程。

## 7. 函数接口与模块

下面是主要函数和模块的索引，路径相对 `data/djzc444/function/`。数据包函数不收独立参数，输入来自执行上下文、计分板和 Storage。

| 模块/函数 ID | 用途 | 调用注意 |
| --- | --- | --- |
| `djzc444:option/boost`、`djzc444:option/unboost` | 开关 boost 模式 | 会改多项游戏规则，关之前建议备份 |
| `djzc444:initialize` | 初始化存档 | 动很多游戏状态，不是常规重载入口，已有对局里别重复调 |
| `djzc444:dialog/user_dialog`、`dialog/tp_dialog`、`dialog/op_dialog`、`dialog/manage_dialog`、`dialog/choose_dialog`、`dialog/map_dialog` | 打开对应动态对话框 | 要玩家当 `@s` 执行，会清理相关 `trigger` 分值 |
| `djzc777:open` | 打开新手教程主页 | 要玩家当 `@s` 执行，显示 `djzc777:tutorial/root` |
| `djzc777:tutorial/start`、`djzc777:tutorial/end` | 开始或结束实境教程 | 要玩家当 `@s` 执行，会改教程阶段分值、阵营、重生点和玩家位置，还依赖固定地图坐标 |
| `djzc444:game/start`、`game/end_custom`、`game/end_ct`、`game/end_t` | 开始或结束一局 | 内部流程函数，直接调会动全局对局状态 |
| `djzc444:game/game_flow`、`flow_begin`、`flow_a_b`、`flow_c_d`、`flow_end` | 对局流程状态机 | 占点、启动器或时钟触发 |
| `djzc444:points/x_point`、`x_point_reset`、`x_occupy_by_t`、`x_occupy_by_ct` | 通用占点更新、复位与占领回调 | `x_occupy_by_ct` 目前没人调，属于预留 |
| `djzc444:points/starter_x`、`c_starter`、`d_starter` | 启动器激活、C/D 点启动器阶段结算 | 宏读 `storage djzc:map` 的启动器字段 |
| `djzc444:points/airport_x` | 机场补给与地对空导弹触发 | 宏读 `airport_ct` / `airport_t` |
| `djzc444:game/game_starter_x`、`game_starter_display`、`game_starter_nodisplay`、`game_starter_reset` | 启动器展示框检测、盔甲架高亮/清除、开局复位 | 宏读启动器坐标和 `frame_facing` |
| `djzc444:game/lib_*` | 战斗与支援机制 | tick 调度，内部实现 |
| `djzc444:game/lib_armor_sync`、`game/lib_armor_sync/ct`、`game/lib_armor_sync/t` | 换队、首次入队或发白板时同步全身盔甲的纹饰材料 | 全场扫描，按 `team` 判 CT/T，只改 `trim` 组件，不碰耐久和附魔。换队、发装备、切和谐模式时主动请求一次，`second` 每秒再兜底一次 |
| `djzc444:weapon/shield` | 统一发 tv 盾作为白板，随后由 `lib_armor_sync` 按队伍/兵种/和谐模式替换 | 由 `suit_jzb` / `suit_scj` 调用，要玩家当 `@s` |
| `djzc555:raycast/block`、`raycast/entity` | 通用射线检测入口 | 可配 `ray_sleep` 让检测跨 tick 走，结果走 `internal/on_result` 回调 |
| `djzc555:raycast/ground`、`raycast/rocket` | 轰炸指示器和雷枪的玩法入口 | 固定即时、固定开轨迹粒子，参数见[7.4](#74-射线检测雷枪与轰炸指示器djzc555--djzc444gamelib_) |
| `djzc555:raycast/particle/end_rod`、`particle/campfire_cosy_smoke` | 切换轨迹粒子 | 写 `storage djzc555:raycast particle`，两个玩法入口各自会调 |
| `djzc555:raycast/spawn_at_result` | 生成落点标记 | 宏来源 `storage djzc555:raycast result` |
| `djzc666:game/lib_missile_*`、`missile_scan`、`missile_fox`、`missile_rifle`、`missile_sam` | 导弹制导、近炸引信、扫描与发射 | 发射函数由成就奖励调用 |
| `djzc888:map_swich`、`dz_djzc/main`、`jc_basic/main`、`game_map_selection`、`tick` | 地图元数据注册与选择 | `map_swich` 按 `map djzc.map` 调地图配置写 `storage djzc:map`，`game_map_selection` 由 tick 调 |
| `djzc444:option/test_tool/*` | 开发测试工具 | 只给调试用 |

### 7.1 地图元数据接口（`djzc888`）

- `djzc888:map_swich` 是地图系统的加载入口，读虚拟玩家 `map djzc.map`，`1` 调 `djzc888:dz_djzc/main`，`2` 调 `djzc888:jc_basic/main`。
- 每张地图的 `main.mcfunction` 用 `data merge storage djzc:map { ... }` 写元数据，顺手写 `storage djzc:game.map_name`。
- `djzc888:tick` 每 tick 调 `djzc888:game_map_selection`，读玩家 `djzc.map` 的 `1/2`，写进虚拟玩家 `map djzc.map`，再调 `map_swich`。
- `game/start` 也会调 `map_swich`，保证开局用当前选的地图。
- `flow_begin`、`flow_a_b`、`flow_c_d`、`flow_end`、`c_starter`、`d_starter` 用 `$function djzc888:$(name)/unique` 调当前地图的特色函数；`starter_x` 和 `x_occupy_by_*` 经 `game_flow` 间接进流程。`$(name)` 来自 `storage djzc:map map_data.name`。
- `storage djzc:map` 常用字段如下。

| 键 | 字段 | 用途 |
| --- | --- | --- |
| `map_data` | `name` | 地图代码，用于 `djzc888:$(name)/unique` |
| `a_point` / `b_point` / `c_point` / `d_point` | `x`、`y`、`z`、`dx`、`dy`、`dz`、`glass_x`、`glass_y`、`glass_z`、`NAME`、`name`、`gameflow` | 战区范围、玻璃颜色复位坐标、显示名、占领后的流程值（A/B 为 `1`，C/D 为 `2`） |
| `airport_ct` / `airport_t` | `x`、`y`、`z`、`dx`、`dy`、`dz`、`name`、`TEAM`、`team`、`ENEMY_TEAM`、`enemy_team` | 机场区域、阵营和补给计分板后缀 |
| `c1`…`c3` / `d1`…`d3` | `x`、`y`、`z`、`NAME`、`name`、`frame_facing` | 启动器展示框位置、显示名和朝向 |
| `tp_a`…`tp_af4` | `x`、`y`、`z` | 传送目的地坐标 |

- 两张图现在的差别。`dz_djzc` 写机场 `airport_ct` / `airport_t` 和 `tp_af1`…`tp_af4`；`jc_basic` 的机场和空中出生点字段被注释，不写；`jc_basic` 的 D 点 `glass_x/glass_y/glass_z` 还是 `-458/60/-761`，跟 `dz_djzc` 一样，迁移或复位玻璃前先核。
- `data merge` 不删旧键。同一存档从 `dz_djzc` 切到 `jc_basic` 时，`airport_ct`、`airport_t`、`tp_af1`…`tp_af4` 这些没被覆盖的键会留着旧图的值，17-20 号传送和机场逻辑照样可能用旧坐标。切图之后按需清 `storage djzc:map`。
- 现在没有默认地图。全新存档必须先设 `map djzc.map`，否则 `map_data` 不存在，开局流程加载不了。见[5.7](#57-地图选择与开局前置)。

### 7.2 占点与启动器

- `points/x_point` 每 tick 由 `tick.mcfunction` 以 `with storage djzc:map <point>_point` 调用，只在 A/B 为 `0`、C/D 为 `1` 时执行。
- 占点进度挂在 `djzc.time3` 上的 `T_$(NAME)`（内部累计，初始 `1040`）和 `T_S$(NAME)`（对外进度，初始 `60`）。每 tick 取点内最近一名 T 玩家让 `T_$(NAME)` 减 `2`，再取最近一名 CT 玩家加 `1`；`T_$(NAME) <= 1000` 时 `T_S$(NAME)` 减 `1`、累计值回 `1040`；`T_$(NAME) > 1040` 时 `T_S$(NAME)` 加 `1`、累计值回 `1002`；`T_S$(NAME) <= 0` 调 `x_occupy_by_t`，进度回 `60`。
- BossBar `djzc_point:<name>` 显示 `T_S$(NAME)`，上限 `60`。`T_S <= 15` 红色，否则蓝色，点内没人时隐藏。
- `x_occupy_by_t` 把玻璃改红、把该点流程值设成地图配置里的 `gameflow`、播占点音效、给点内 T 玩家加 `djzc.occupy`，然后调 `game_flow`。`x_occupy_by_ct` 把玻璃改回蓝并复位进度，目前没有调用方。
- `game_starter_x` 读展示框 `ItemRotation`，值为 `7` 时调 `points/starter_x` 激活启动器，展示框旋转复位成 `0`。展示框实体不见时会按 `frame_facing` 自动补一个 `glow_item_frame`。
- `points/starter_x` 清启动器高亮、播音效、把这个启动器在 `djzc.gameflow` 里设 `1`，再调 `game_flow`。
- `game_starter_display` 给启动器附近的盔甲架加发光和定位栏，`game_starter_nodisplay` 清发光并把定位栏传输范围设 `0`。
- C 点启动器全激活后，`game_flow` 调 `c_starter`，`B+` 设 `2`，随后 `game_flow` 把 `C` 设 `1`、`B+` 设 `0`，C 点开放占领，C1-C3 置 `-1`。D 点同理。

### 7.3 导弹系统（`djzc666`）

- 武器。空空导弹 `blaze_rod`，`custom_data.tags=["djzc.missile.aa"]`，每次发 `4` 个，冷却 `3` 秒；空地导弹 `breeze_rod`，标签 `djzc.missile.ag`，每次 `8` 个，冷却 `3` 秒；地空导弹发射器 `bone`，标签 `djzc.missile.ga`，每次 `8` 个，冷却 `3` 秒。
- 发射和扫描由隐藏成就触发。消耗 `djzc.missile.aa` 走 `djzc666:tool/missile_fox` → `missile_fox`，`djzc.missile.ag` 走 `missile_rifle`，`djzc.missile.ga` 走 `missile_sam`。长按 `blaze_rod` / `breeze_rod` / `bone` 走 `missile_scan` / `missile_ag_scan` / `missile_ga_scan`，扫锥形范围内的玩家并让他们发光。
- 导弹实体是 `minecraft:snowball`，带 `missile`、`AA` / `AG` / `GF_AA` 和 `CT_*` / `T_*` 标签，`Owner` 存发射者 UUID，`PortalCooldown` 当引信倒计时。
- 制导模式看 `missile_mode djzc.option`，`1`（默认，`initialize` 复位值）向量法 Motion 制导，`0` TP 瞬移制导。分发器 `lib_missile_track_do` 用 `if matches 1 run return run function` 提前返回，模式 0 的两条 `tp` 不再重复挂 `unless` 条件。目标判定看 `track_type djzc.option`，默认 `0` 用 `AF` / `GF` 标签，`1` 用 `is_on_ground` / `no_on_ground` 谓词。
- 近炸引信，敌方 `AF` / `GF` 单位进导弹 `3` 格内就把 `PortalCooldown` 置 `0`；导弹撞上非可替换方块也会自爆。干扰弹现在直接当作敌方单位被追踪，旧版「命中抛出的物品」诱饵逻辑已删。
- 伤害，`lib_missile_damage` 对 `AA` 造成 `84` 点、半径 `5` 格，对 `AG` 造成 `46` 点、半径 `5` 格。`GF_AA` 导弹同时带 `AA` 标签，吃 `84` 点那档。
- 敌导弹告警在 `djzc.time2` 的 `刻=20` 和 `刻=10` 执行，每 0.5 秒一次，给 `100` 格内的敌方空军/地面单位显示「敌导弹」。

### 7.4 射线检测、雷枪与轰炸指示器（`djzc555` / `djzc444:game/lib_*`）

射线检测有两种跑法。`ray_sleep=0` 是老样子，单 tick 同步递归 `start` → `step` → `check` → `step`，调用完同一 tick 就能读 `storage djzc555:raycast result`。`ray_sleep=N` 会把递归拆开，`check` 在每步末尾 `return 0`，`djzc555:tick` 每 tick 按 `ray_timer` 推进一步，轨迹看得见。sleep 模式下结果延迟产生，后续逻辑挂到 `internal/on_result`，别在调用后立刻读 storage。

步长和粒子参数都存进每条射线 marker 自己的 `data` compound，用 `with entity @s data` 传宏。多条射线并存不会串参数，`ray_uid` 也真正启用了，施法者标签按 UID 清。宏规则帮了忙，字符串标签插入时不含引号，数值标签不带类型后缀，所以 `$(id)` 能直接当粒子名、`$(step)` 能直接当坐标。

轨迹粒子是一条宏命令 `$particle $(id) ~ ~ ~ $(delta) $(speed) $(count) $(mode) $(viewers)`，配置写在 `storage djzc555:raycast particle`。正式版只留两个预设，`end_rod` 和 `campfire_cosy_smoke`。`ray_particle` 还是开关，`0` 关、`1..` 开，跟以前一样。

四个入口的参数。

| 入口 | 轨迹粒子 | sleep | 备注 |
| --- | --- | --- | --- |
| `raycast/block` | 沿用当前 storage | 外部可配，默认 `0` | 通用工具入口，`ray_type=0` |
| `raycast/entity` | 沿用当前 storage | 外部可配，默认 `0` | 通用工具入口，`ray_type=1` |
| `raycast/ground` | 固定 `minecraft:end_rod` | 固定 `0` | 轰炸指示器，`ray_step=10`、`ray_max=400` |
| `raycast/rocket` | 固定 `minecraft:campfire_cosy_smoke` | 固定 `0` | 雷枪，`ray_step=10`、`ray_max=400` |

两个玩法入口把 `ray_sleep` 钉死在 `0`，因为 `lib_boom_single` 和 `lib_rocket_fire` 都是调用完立刻读 result 的写法。计分板分数是持久的，测试时谁设过 `ray_sleep=2`，下一次右键萝卜钓竿就会沿用，标记直接不生成。想给通用入口配 sleep，用完记得把分数清回 `0`。

计分板参数，`djzc555.ray_dist` 步数、`ray_max` 最大步数、`ray_type`（`0` 方块、`1` 实体、`2` 两者）、`ray_step`（值 ×0.1 = 格数）、`ray_particle`、`ray_sleep`、`ray_timer`、`ray_uid`、`ray_keep`。

结果字段有 `hit`、`x` / `y` / `z`、`distance`、`steps`、`uid`；实体检测额外写 `entity` UUID，方块检测写 `block` 状态。`result` 还是全局单例，即时调用方读完就用。每条射线结束时会另存一份到 marker 的 `data.result`，`on_result` 用宏拿到自己那份，不受后来者覆盖。需要跨 tick 或事后查询时把 `ray_keep` 设 `1`，结果按 uid 写进 `storage djzc555:raycast results.u<N>`，用 `internal/consume_result` 取走并删除。默认不存槽，免得即时调用把槽堆起来。

方块判定用 `#minecraft:replaceable`。仓库里另有一份 `data/minecraft/tags/block/raycast.json`（空气、可替换方块、旗帜、按钮、营火、蜡烛、藤蔓、门、铁轨、告示牌、火把等），现在没接线，属于遗留配置。

**雷枪**（`lib_rocket_ltjd`）

- 主手/副手诡异菌钓竿右键触发，要求 `custom_data.tags` 含 `djzc.rocket.ltjd`
- `lib_rocket_fire` 执行 `raycast/rocket`，在落点召唤 `ltjd_boom` 标记，再由 `lib_rocket_detonate` 以发射者身份引爆
- `lib_rocket_boom` 按距离分 16 档，中心 `0.5` 格内 `70` 点，之后每 `0.5` 格递减，`7.5-8.0` 格 `2` 点，伤害类型 `minecraft:explosion`。只显式排除带 `djzc.rocket_caster` 标签的发射者，同队豁免交给 `/damage`
- 全图可用，不受 `boom_area` 限制，debug 模式不扣耐久
- 物品 `max_damage=16`，每次发射应用 `djzc444:damage_ltjd`（`set_damage` 常量 `-0.0625`，`add: true`），代码按 `minecraft:damage~{damage:16}` 没收耗尽的雷枪
- 爆炸特效 `minecraft:campfire_cosy_smoke`，和轨迹粒子同一款

**轰炸指示器**（`lib_boom_marker`）

- 主手/副手胡萝卜钓竿右键触发，计分板 `djzc.r_click5`
- 非 debug 模式只能在 `boom_area` 谓词圈的两个区域里召唤，debug 全图可用
- `lib_boom_single` 执行 `raycast/ground`，在落点召唤 `mark3`，应用 `djzc444:damage_half`（`set_damage` 常量 `-0.5`，`add: true`），代码在 `minecraft:damage~{damage:2}` 时没收指示器
- `mark3` 的 `djzc.time2` 由 `game/time_custom` 每 tick 减，归零后 `lib_boom_marker_damage` 引爆，中心 `144` 点，`14.5` 格处 `10` 点，伤害类型 `minecraft:explosion`
- 爆炸不分敌我，发射者也不会被自动排除，这点跟雷枪不一样
- `spawn_at_result` 给新标记加临时标签 `djzc444.mark3_new` 来设倒计时，设完就摘。之前用 `@e[tag=mark3,limit=1,sort=nearest]`，函数是从施法者位置执行的，场上已有旧标记时会挑错，新标记拿不到 `djzc.time2`，被 `time_custom` 减成 `-1` 后下一 tick 就自爆。`lib_boom_marker` 里还留了一行兜底，没拿到倒计时的 `mark3` 补 `200`

**烟雾弹**，穿透等级 `9` 的箭标成 `smoke`，落地后持续生成 `campfire_cosy_smoke`；箭自身 `life=600`（30 秒）到期消失。

**干扰弹**，`djzc.r_click2`（鸡蛋）触发 `lib_jam_egg`，在玩家周围生成带 `jam_decoy` / `AF` 或 `GF` 标签的鸡，5 秒后清掉。

**无人机**，`djzc.r_click3`（蓝色鸡蛋）触发 `lib_allay_drone`，生成带 `drone` / `AF` 标签的悦灵，侦察 32 格内敌人并让他们发光，200 tick 后自爆。

**新星 / 三连发 / 垂直机动**分别由 `lib_nova`、`lib_sanlian3`、`lib_fly` 处理，后两个依赖 `select_fly`、`jump_sneak` 谓词和对应物品标签。

### 7.5 新手教程（`djzc777`）

- 主页入口 `function djzc777:open`，以当前玩家 `@s` 显示 `djzc777:tutorial/root`。ESC 暂停菜单的 `pause_screen_actions` 也能开。
- `function djzc777:tutorial/start` 在 `game=1`（对局进行中）时用 `return run tellraw` 提前拒绝，提示「对局进行中，暂时不能进入新手教程。」。否则切地图到 `jc_basic`（`map djzc.map=2` → `map_swich` → `game/start`），把玩家加进 T 队，`djzc777.tutorial=1`，重生点和位置设 `(-434, 41, -709)`，发 `type_fkb` 装备，并清掉出口弹窗防重复标记。它会切图、改阵营和装备，只开对话框的别调这个。
- `function djzc777:tutorial/end` 用 `as @s` 直接把执行玩家 `djzc777.tutorial` 设 `-1`，按队伍设重生点并传到 T `(-397, 30, -809)` / CT `(-405, 30, -809)`，发「点此准备开一局」的 tellraw（点击交 `djzc.prepare=1`）。执行者必须是玩家。
- `djzc777:load` 创建 dummy 目标 `djzc777.tutorial`。阶段值：`1`/`3`/`5`/`7`/`9` 是各触发前的等待态，弹窗后推进到偶数 `2`/`4`/`6`/`8`/`10`，按钮再 +1 进入下一等待态；`-1` 主动结束、`-2` 已看过出口结束页（防重复弹）。目标不是 `trigger`，别用 `/trigger` 交。
- 阶段推进链（由 `djzc888:jc_basic/unique.mcfunction` 事件触发 + `unique_tick.mcfunction` 区域触发）：进入 A 点（1→2）→ 进 B 点（3→4）→ 激活任意 C 启动器（5→6，`C1/C2/C3=1`）→ C123=3 全激活开放占领（7→8，`tutorial_c`）→ 占领 D 点 `D=2`（9→10，`tutorial_d`）。按钮 `advance` 统一 +1 并 `dialog clear`。
- 按钮走 `djzc.option` 的 `100-105` 号段，由 tick 里的 `djzc777:tutorial/option` 分发到 `option/` 六个子函数：`100` 一键占领 A（`T_SA=0`）、`101` 一键占领 B（`T_SB=0`）、`102` 进攻 C（广播步话机 `tmsg=11`）、`103` 进攻 D（广播 `tmsg=12` + `T_SC=0` 一键占领 C）、`104` 进入配装教学（传送 `(-380,20,-748)` → `advance` → 拉起 `tutorial_gui1`）、`105` 无视风险结束教程（`function djzc777:tutorial/end`）。一键占领靠把倒计时分数归零，交给每 tick 的 `x_point` 走正常占领流程，不绕过 gameflow。
- 注意 `advance` 内含 `dialog clear`，需要在 `dialog show` **之前**调用；`gui1` 曾因顺序颠倒导致新开的页面被立刻关掉。
- 对话框 ID 全在 `tutorial/` 子目录下，路径带 `tutorial/` 前缀。主页 `tutorial/root`、实境提示 `tutorial_a`/`tutorial_b`/`tutorial_starter`/`tutorial_c`/`tutorial_d`、成员用书说明 `tutorial_gui1`/`gui2`/`gui3`、结束页 `tutorial_end`、进阶占位 `tutorial_advanced`。原 `tutorial_win`、`tutorial_choose` 已删除，分别由 `tutorial_d`、`tutorial_gui3` 的「兵种选择」按钮接替。
- 三个成员用书说明页是 `multi_action`：从 `djzc444:userbook` 按语义复制来的按钮（加入CT/T、兵种选择、步话机、重新部署、中止音乐、准备/取消准备），有 tooltip 的只有 join_ct/join_t/redeploy 三项，与 userbook 严格一致；gui1/gui2 翻页按钮在 `exit_action`，gui3 的 `exit_action` 已移除、兵种选择按钮放 `actions`。
- `tutorial_starter` 现有三段 body：`body1` 教激活（含 `%1$s` keybind）、`body2` 说可分几次转动展示框、`body3` 说找不到就看定位栏。教程页翻译键从 `djzc777.dialog.*` 改名并入 `djzc.dialog.*`，条目仍在 `assets/djzc777/lang/`；dialog fallback 与 zh_cn 值已逐键对齐（37 处一致）。
- 出口区域检测在 `unique_tick.mcfunction`：任意玩家进入 `x=-388..-386,y=19,z=-749..-751` 弹 `tutorial_end` 并把该玩家阶段置 `-2`，`unless matches -2` 挡住每 tick 重复弹；重播时 `start` 把阶段重置为 1，下次经过还能再触发。
- 旧版 `djzc777:tutorial/ch01` 至 `ch08` 已删。`tutorial/start` 和 `tutorial/end` 仍用固定地图坐标，迁移地图前核传送点、阵营和兵种效果。进阶页目前只是占位。

### 7.6 统计与其他系统

- `option/scoreboard_*` 把对应统计目标显示到侧边栏，顺手清 `djzc.option`。`1` 总击杀数（`djzc.stat_kill`）、`2` 总阵亡数（`djzc.stat_death`）、`3` CT 击杀数（`djzc.CT`）、`4` T 击杀数（`djzc.T`）、`5` 战斗场次（`djzc.fight`）、`6` 胜利场次（`djzc.fight_win`）、`7` 失败场次（`djzc.fight_lost`）。
- `game/death_scoreboard` 处理无归属死亡，T 玩家不是被 CT 击杀就把最近 CT 的 `djzc.CT` 和 `djzc.count_kill` 加 `1`，CT 玩家反过来同理。处理完清 `djzc.count_die1`、`djzc.T_D_by_CT`、`djzc.CT_D_by_T`。
- `game/music_stop` 停所有玩家声音，`end_custom` 结束后 10 秒调度一次。`game/music_af` 停所有声音并播 `music.dragon`（空战曲）。
- `tag_clear` 清当前玩家的 `GF`、`AF` 和八个兵种标签，兵种函数发装备前调。
- `support/mechanic_wolf`、`support/allay_drone`、`support/swarm_drones`、`support/smoke` 是独立的手动支援工具函数，目前主要给开发测试或手动发放用，没接进主 tick 流程。
- `game/lib_armor_sync` 是全场扫描，看玩家队伍和 `djzc444.armor_team`，不一致才调 `game/lib_armor_sync/ct` 或 `/t`。新发的白板 `quartz` 也会触发一次，装备和背包都看。两个函数用 `item_modifier` 把身上所有带 `trim` 的装备材料改成 `lapis`（CT）或 `redstone`（T）。`all_of_player` 的参数是物品谓词 `filter` 和目标 `modifier`，遍历背包、护甲、主手、副手、光标和合成格，盔甲和盾牌共用这一套。发放统一在 `type/armor`，发石英白板；`type/suit` 只负责按兵种挑部位，不再分 CT/T 两套。
- 为免等满一秒，状态刚变的当刻会主动请求一次 `game/lib_armor_sync`：换队走 `option/do_join_ct`、`option/do_join_t`，发装备走八个 `type/type_*`（都放在加完兵种 tag 之后，否则盾牌会按错兵种换），切和谐模式走 `option/do_harmony`、`option/no_harmony`。请求的是同一个全场函数，不是单人版，一次会把在场所有人刷一遍。`second` 里那次保留作兜底，防漏调和手动给的白板。

- `weapon/shield` 统一发 tv 盾作为白板，`game/lib_armor_sync` 按和谐模式、队伍和 `scj` tag 换盾，盾牌也走 `all_of_player`，`filter` 是 `minecraft:shield`。和谐模式全员 tv，非和谐 CT 非 scj 换北极星、CT scj 保持 tv、T 换普通。`suit_jzb` 和 `suit_scj` 都只调 `weapon/shield`。

## 8. 状态与数据约定

### 8.1 主要计分板分组

| 目标/目标前缀 | 用途概览 | 接口级别 |
| --- | --- | --- |
| `djzc.gameflow` | 对局流程、战区和启动器状态 | 内部状态 |
| `djzc.time`、`djzc.time2`、`djzc.time3` | 对局时钟、常驻时钟和占点计算 | 内部状态 |
| `djzc.option` | 菜单请求，也存 boost/debug/harmony/missile_mode/track_type 等配置 | 玩家通过 trigger 交请求，配置分值属于内部状态 |
| `djzc.type` | 兵种选择、启用状态、预设及相关常量 | 内部状态 |
| `djzc.r_click2`、`djzc.r_click3`、`djzc.r_click4`、`djzc.r_click5`、`djzc.r_click6`、`djzc.r_click7` | 物品使用行为检测 | 内部状态，由 `minecraft.used:*` 准则驱动。`r_click5` 轰炸指示器，`r_click6` 雷枪，`r_click4`（棕色鸡蛋）当前无读写方 |
| `djzc.prepare`、`djzc.tp`、`djzc.type_choose`、`djzc.ctmsg`、`djzc.tmsg`、`djzc.eula`、`djzc.map` | 玩家输入 trigger | 交互入口，值域见[第 5 节](#5-玩家输入接口trigger) |
| `djzc777.tutorial` | 新手教程阶段 | 普通 dummy。等待态 `1`/`3`/`5`/`7`/`9`，弹窗后偶数 `2`/`4`/`6`/`8`/`10`，按钮 +1 推进；`-1` 主动结束、`-2` 已看过出口结束页。不是玩家 trigger |
| `djzc.stat_*`、`djzc.count_*`、`djzc.fight*`、`djzc.CT`、`djzc.T`、`djzc.occupy` | 统计数据和对局记录 | 用于统计或展示，写入规则见[7.6](#76-统计与其他系统) |
| `djzc.airport_ct`、`djzc.airport_t` | 机场补给倒计时 | 内部状态，由 `airport_x` 改 |
| `djzc555.ray_*` | 射线检测参数与运行状态 | 内部状态。含 `ray_dist`、`ray_max`、`ray_type`、`ray_step`、`ray_particle`、`ray_sleep`（每步间隔 tick）、`ray_timer`（运行态倒计时）、`ray_uid`（关联施法者与 marker） |
| `djzc444.armor_team`、`djzc444.armor_slot` | 护甲纹饰同步状态、遍历槽位的临时计数 | 内部状态。`armor_team` 为 `1` 表示 CT、`2` 表示 T，没分数时下一次同步会扫一次 |
| `djzc666.track` | 导弹向量制导计算 | 内部状态 |
| `djzc.hp` | 玩家血量显示（`health` 准则） | 显示接口 |

### 8.2 游戏流程状态

`djzc.gameflow` 的虚拟玩家含义。

| 虚拟玩家 | 值 | 含义 |
| --- | --- | --- |
| `game` | `0` / `1` | 未开局 / 对局进行中 |
| `A`、`B` | `0` / `1` / `-1` | CT 控制 / T 已占领 / 本轮已结算并进入下一阶段。A、B 都变 `1` 时进 C 点启动器阶段 |
| `C`、`D` | `0` / `1` / `2` / `-1` | CT 控制 / 开放占领 / T 已占领（瞬时）/ 已激活并进入下一阶段 |
| `A+B` | `0` / `2` | A、B 占领数之和，到 `2` 触发 `flow_a_b` |
| `B+`、`C+` | `0` / `1` / `2` | 启动器阶段标记，`1` 高亮可激活，`2` 全部激活等推进 |
| `C1`…`C3`、`D1`…`D3` | `0` / `1` / `-1` | 未激活 / 已激活 / 本轮已结算 |
| `C123`、`D123` | `0..3` | 三个启动器的激活数之和，到 `3` 触发对应结算 |

流程这么走。

1. A、B 都被 T 占领（`A+B=2`）→ `flow_a_b`，A/B 置 `-1`，`B+=1`，高亮 C1-C3
2. C1-C3 全激活（`C123=3`）→ `c_starter`，`B+=2`，C1-C3 置 `-1`；`game_flow` 把 `C=1`、`B+=0`，C 点开放占领
3. C 被 T 占领（`C=2`）→ `flow_c_d`，`C+ =1`，`C=-1`，高亮 D1-D3
4. D1-D3 全激活（`D123=3`）→ `d_starter`，`C+=2`，D1-D3 置 `-1`；`game_flow` 把 `D=1`、`C+=0`，D 点开放占领
5. D 被 T 占领（`D=2`）→ `flow_end`，T 胜利（`end_t`）；15 分钟耗尽则 CT 胜利（`end_ct`）

`djzc.time` 初始 `分=15`、`秒=0`、`刻=0`，`time_game` 只在 `game=1` 时跑，分钟降到 `0` 以下调 `end_ct`。`djzc.time3` 还存占点常量 `1040`、`1000`、`60`、`30`、`15`、`0` 和 `T_A`…`T_D`、`T_SA`…`T_SD`。

### 8.3 Storage

| Storage | 主要键 | 用途 |
| --- | --- | --- |
| `djzc:game` | `minute`、`second`、`map_name` | 动态对话框的时间与当前地图代码。`second.mcfunction` 每秒写时间，地图配置写 `map_name` |
| `djzc:map` | `map_data`、`a_point`…`d_point`、`airport_ct`、`airport_t`、`c1`…`c3`、`d1`…`d3`、`tp_*` | 地图元数据，见[7.1](#71-地图元数据接口djzc888) |
| `djzc:type_manage` | `jzb`…`bzb`、`*_color`、`*_ini`、`preset1`…`preset8`、`template_preset`、`template_confirm`、`minute`、`second` | 兵种选择和兵种管理对话框参数 |
| `djzc444:op` | `boost`、`debug`、`gameflow`、`harmony`、`missile_mode`、`track_type`、`*_color` | 管理用书状态栏参数 |
| `djzc444:rocket` | `x`、`y`、`z`、`caster` | 雷枪爆心坐标的宏来源。`caster` 在 `spawn_mark` 里读，但当前发射链没写，爆炸归属实际由执行上下文承担；每次发射后清理 |
| `djzc555:raycast` | `result`、`particle` | `result` 装 `hit`、`x`/`y`/`z`、`distance`、`steps`、`uid` 等，读完清理；`particle` 装 `id`、`delta`、`speed`、`count`、`mode`、`viewers`，由 `raycast/particle/*` 预设写入，start 复制到每条射线 marker |
| `example:data` | `arr`、`arr_temp` | 只给 `option/test_tool` 开发示例用 |

### 8.4 实体标签

| 标签 | 用途 |
| --- | --- |
| `AF` / `GF` | 空中单位 / 地面单位，导弹目标和雷达判定用 |
| `jzb`、`jjs`、`fkb`、`ltjd`、`scj`、`yqb`、`ggne`、`bzb` | 玩家当前兵种标签，`tag_clear` 清掉后重新加 |
| `fly` | 可触发垂直机动的物品标签（`select_fly` 谓词） |
| `msg`、`userbook`、`opbook` | 成书物品的 `custom_data.tags`，分别对应步话机、成员用书、管理用书 |
| `mark3` | 轰炸指示器落点标记，倒计时后爆炸 |
| `djzc444.mark3_new` | `spawn_at_result` 给刚生成的标记挂的临时标签，用来精确设倒计时，设完立刻摘 |
| `ltjd_boom` | 雷枪爆心标记，只承载坐标，引爆后立即清 |
| `djzc.rocket_caster` | 雷枪发射者临时标签，用于 `tag=!` 排除自身 |
| `AA`、`AG`、`GF_AA`、`CT_AA`、`T_AA`、`CT_AG`、`T_AG`、`CT_GA`、`T_GA`、`missile` | 导弹实体分类与归属 |
| `jam_decoy` | 干扰弹生成的鸡诱饵 |
| `drone` | 悦灵无人机 |
| `smoke` | 烟雾弹箭矢 |
| `shot` | 新星成就检测用的箭矢标记 |
| `djzc555.ray_marker`、`djzc555.ray_live`、`djzc555.ray_caster`、`djzc555.ray_async` | 射线标记实体、启动期临时标签、施法者标签、sleep 模式标记 |
| `djzc666_dir` | 导弹向量制导内部标记 |

### 8.5 谓词

| 谓词 | 用途 |
| --- | --- |
| `djzc444:boom_area` | 轰炸指示器允许召唤的两个固定区域，非 debug 模式用 |
| `djzc444:height_under40` | 玩家 Y 在 `-100..40`，兵种选择和传送系统的非 debug 限制 |
| `djzc444:is_on_ground` / `no_on_ground` | 导弹目标判定的地面/空中状态 |
| `djzc444:jump_sneak` | 同时按跳跃和潜行，用于垂直机动 |
| `djzc444:select_fly` | 主手/副手物品带 `fly` 标签 |
| `djzc444:select_msg` / `select_userbook` / `select_opbook` | 成书物品标签检测 |
| `djzc444:select_rocket_ltjd` | 物品带 `djzc.rocket.ltjd` 标签，用于雷枪 |
| `djzc444:select_carrot_on_a_stick` | 手持胡萝卜钓竿，现在由计分板路径替代，谓词留着 |
| `djzc444:move_0` | 玩家移动速度为 0 |
| `djzc666:missile_locked` | 导弹锁定状态（发光效果等级 5） |

### 8.6 伤害类型、物品修饰器与附魔

- 伤害类型 `djzc444:missile`（导弹）、`djzc444:mine`（地雷）、`minecraft:explosion`（轰炸指示器、雷枪）。
- 物品修饰器 `djzc444:damage_half`（`set_damage` 常量 `-0.5`，轰炸指示器）、`djzc444:damage_ltjd`（`-0.0625`，雷枪）。
- 附魔 `djzc444:burstshot`（爆炸开火），最高 1 级，加弩的弹射物数量和散布，与 `#minecraft:exclusive_set/crossbow` 互斥。

### 8.7 成就

| 成就组 | 用途 |
| --- | --- |
| `djzc444:fight/*` | 可见战斗统计与武器成就，`root` 在加载和对局开始时授予，`count_*` 记本局击杀/占点 |
| `djzc444:intro/*` | 增益介绍成就，加载时从 `intro/root` 全部授予 |
| `djzc444:tool/root`、`tool/hkb`、`tool/cl` | 隐藏工具成就，`hkb` 用于航空兵解锁，`cl` 用于刺雷 |
| `djzc666:tool/*` | 隐藏发射/扫描触发器，奖励函数生成导弹或执行扫描后立刻撤销 |

### 8.8 翻译键与地图解耦

- 地图相关显示文本统一用 `djzc.map.<地图代码>.*`，例如 `djzc.map.dz_djzc.point_a`、`djzc.map.jc_basic.respawn_sky_ct`。
- 百科地图页标题和简介用 `djzc.dialog.wiki.map_<地图代码>.title` / `.body1`。
- 新增地图时一起补 `assets/djzc444/lang/*.json` 里的 `djzc.map.<code>.*` 键，`djzc.dialog.wiki.map_<code>.title` / `.body1` 键，`data/djzc444/dialog/wiki/wiki_map_<code>.json`，`wiki_map.json` 里的页面链接，以及 `djzc888:<code>/main.mcfunction` 和 `unique.mcfunction`。
- 数据包内 `assets/djzc444/lang/` 提供备用翻译（当前 624 键 × 4 语言），`assets/minecraft/lang/` 另有 43 键 × 4 语言，配套资源包的 `assets/djzc444/lang/` 同为 624 键 × 4 语言（两侧逐字节一致）。对话框带 `fallback`，完整本地化还是得加载资源包。
- 新手教程的翻译从 `djzc777.dialog.*` 改名并入通用体系，现为 `djzc.dialog.*`（教程页专属键），条目仍放在配套资源包的 `assets/djzc777/lang/`（47 键 × 4 语言）。`djzc777.load.msg`、`djzc777.tutorial.start.denied`、`djzc777.tutorial.end.complete` 三个键保留原命名空间不变。教程页 dialog 的 fallback 与 zh_cn 已对齐，改文案时两边一起维护。

### 8.9 实测注意事项

下面这些是调试时踩出来的，代码重构之后照样适用。

- 队伍名读不到实体 NBT。`Team` 不是实体 NBT 字段，`data modify storage … set from entity @s Team` 会静默不执行，目标路径保留原值；伤害选择器的 `team=!` 只认字面量队伍名，不吃变量或选择器。按队伍分派就用 `execute if entity @s[team=CT]` 配字面量分支，或者按队伍拆函数。
- marker 没有 `Owner` 字段，那个字段只在可驯服生物和抛射物上。要给 marker 记归属，得用自定义键（比如 `data.owner`）显式写；引用 marker 自己的 `UUID` 只能拿到 marker 的 UUID。`nbt={UUID:[I;a,b,c,d]}` 这种整数组形式的比较是有效的。
- `by` 选择器解析为空时整条 `/damage` 会被静默跳过，表现是特效音效都在、伤害为零。排查时先单独验选择器能不能命中，别一上来怀疑数值。
- 宏参数来源和执行者是两回事。`execute as <实体> run function … with entity @s` 会把执行者一起切走，函数里 `@s` 变成那个实体。要用 `by @s` 表示发射者，就得让发射者一直是执行者，只把另一个实体当宏来源（先把字段读进 storage，再 `with storage` 调）。雷枪以前把爆心标记设成执行者，`by @s` 指到标记、`positioned` 退化，爆炸特效和音效一起没了。
- `/damage` 的归属和友军豁免都由命令与执行上下文承担。以某玩家为执行者跑伤害函数时，`/damage` 自动继承该执行者当伤害来源，击杀能正常显示击杀者，不用写 `by`；同队豁免也自动，按队伍 `friendlyFire` 规则判，同队不掉血，不需要 `team=!`，只有要把发射者本人排掉才显式写（雷枪的 `tag=!djzc.rocket_caster`）；反过来，显式写 `damage … by <玩家>` 会多触发一层友伤判定，实测对敌方玩家静默拦截伤害，表现为只能炸到无阵营玩家，别这么写。
- 玩家数据里没有可读的名字字段，`data modify … set from entity @s Name` 取不到值。要标识玩家用 `UUID`，选择器里用 `nbt={UUID:…}` / `nbt=!{UUID:…}`。
- `data modify storage <id> set value {…}` 这个语法不合法，`data modify` 必须带路径。清空 storage 只能逐键穷举，比如 `data modify storage djzc444:rocket x set value []`。
- `data merge storage` 不清除旧键。地图切换时 `airport_*`、`tp_af*` 这些没被新图覆盖的键会留上一张图的值，要清就逐键 `data remove`。
- 宏函数缺变量会整体失败。`with storage` 调用时正文里任一 `$(key)` 在 Storage 里不存在，整次调用报错且不执行。动态对话框用到的 `map_name`、`minute`、`second` 得一直存在。
- 生成实体之后要给它写状态，别用 `@e[tag=xxx,sort=nearest]` 找刚生成的那个。函数的执行位置未必在生成点，场上已有同类实体时很容易点错。给新实体挂一个临时标签，写完状态再摘，比按距离猜稳得多。轰炸指示器那个「第二个标记落地即自爆」的 bug 就是这么来的。
- 排查「赋值后读回为空」，先看目标路径是不是写完又被后面的清理指令盖了。用哨兵值判一条 `data modify` 到底有没有执行过，比反复读数快。

## 9. 配套资源包接口

这一节按 `赛扬的冬季战场 v1.0.7` 资源包整理。资源包是客户端资源层，没有数据包函数和 `trigger` 入口，集成点在原版声音事件替换、音频文件和语言键。元数据把 `min_format` 和 `max_format` 都写 `75`，实际以目标客户端加载结果为准。

### 9.1 声音事件

注册表在 `assets/minecraft/sounds.json`。里面的 `replace: true` 会整体替换同名原版事件，加载资源包之后连相应原版动作的声音也跟着变。当前注册 30 个事件，引用 56 个 `djzc444` 音频文件，OGG 都齐。

| 原版声音事件 | 资源包用途 |
| --- | --- |
| `item.goat_horn.sound.0` 至 `item.goat_horn.sound.7` | 进攻 A-D、防守 A-D 提示音，对应 `djzc444:points/atk_*`、`djzc444:points/dfd_*` |
| `entity.piglin.angry`、`jealous`、`ambient`、`admiring_item`、`celebrate`、`retreat`、`converted_to_zombified` | 步话机赞成、反对、冲锋、撤退、发现敌人、请求支援及掩护语音 |
| `entity.cat.purreow` | Ciallo 语音 |
| `entity.ender_dragon.growl`、`entity.player.levelup` | 分别播敌方占点和己方占点提示 |
| `entity.zombie.ambient` | 板载兵（BZB）语音 |
| `entity.wither.death` | 对局失败提示音 |
| `entity.piglin_brute.angry`、`entity.piglin_brute.death` | 最终进攻和最终抵抗语音 |
| `block.anvil.land` | 航空兵 RWR 提示音、导弹扫描音，音量 `0.5` |
| `entity.enderman.teleport` | 立体机动/航空兵传送音效，`item.chorus_fruit.teleport` 转调到该事件 |
| `music_disc.relic`、`music_disc.wait`、`music_disc.blocks`、`music.dragon` | 分别映射 CT 开场、T 开场、进攻曲和空战曲 |
| `music.menu` | 主菜单音乐（*Deepseek V4.1 flash/CE_PT - 冬季战场*） |

`sounds.json` 里的音频标识写成 `djzc444:<相对路径>`，文件落在 `assets/djzc444/sounds/<相对路径>.ogg`。用命令播声音时先核调用处用的是原版事件 ID 还是资源音频 ID，声音配置本身不定义数据包函数入口。字幕文本由对应条目的 `subtitle` 键提供。

### 9.2 翻译与显示文本

资源包给四种语言，`en_us`、`zh_cn`、`zh_hk`、`zh_tw`，翻译分两个目录。

| 目录 | 用途 | 当前键数 |
| --- | --- | --- |
| `assets/djzc444/lang/` | 冬战自定义界面、物品/成就文本、死亡提示、步话机及占点字幕，含资源包元数据描述键 `djzc.resourcepack.mcmeta.desc` 和新增的 `djzc.map.jc_basic.exit` | 624 |
| `assets/minecraft/lang/` | 覆盖原版死亡文本、旗帜图案名称和唱片曲目名称等 Minecraft 翻译键 | 43 |
| `assets/djzc777/lang/` | 新手教程页文本，键名已并入 `djzc.dialog.*` 通用体系，另有三个保留的 `djzc777.*` 键 | 47 |

声音字幕读 `djzc.msg.*`、`djzc.type_bzb` 这些键，元数据描述走 `translate` 读 `djzc.resourcepack.mcmeta.desc`，带 `fallback` 兜底。依赖这些文本的集成要保留键名和 `%1$s` 之类格式占位符，四种语言文件一起维护。

### 9.3 加载与兼容约定

- 数据包管游戏状态和触发逻辑，资源包管客户端声音和文本。只装数据包，逻辑照样能跑，自定义音频和翻译会缺一截。
- 同名声音事件是整体替换，不会叠加。跟别的资源包一起开，优先级高的 `sounds.json` 可能盖掉冬战映射，得到目标客户端上看实际结果。
- 资源包格式范围钉在 `75`。升级 Minecraft 或改格式元数据之后，实际加载一遍，验声音、字幕、唱片曲目和各语言文本。
- 当前 56 个被引用的冬战 OGG 都有对应文件。新增或重命名资源时同步改声音注册表，顺手核路径大小写和拼写。1.0.7 把早期误拼的 `pionts` 改成 `points`，旧文档里的 `pionts` 说明已经作废。

### 9.4 翻译参考（术语对照）

冬战自有术语以已有语言文件里的译法为准，新增文本沿用下表，别另造近义词。英文只走这一套，避免同一概念出现多种写法。

| 中文 | 英文（en_us） | 繁体（zh_hk / zh_tw） | 说明 |
| --- | --- | --- | --- |
| 战区、点位 | Point（如 `A Point`） | 戰區、點位 | 用 `Point`，**不用** `Zone` / `Combat Zone`；顺序恒为「字母 + Point」，写 `D Point` 不写 `Point D` |
| 占领 | capture / capture the point | 佔領 | 地图点位名作 `A Point`、`C Point`，句首大写 |
| 进攻 X 点 | Attack the X point! | 進攻X點！ | 沿用 `djzc.msg.attack_a~d`，小写 `point` + 冠词 the；不要写成 `Attack Zone X` |
| 防守 X 点 | Defend the X point! | 防守X點！ | 沿用 `djzc.msg.defend_a~d` |
| 启动器 | activator | 啟動器 | 点位启动器，如 `C Point activators` |
| 兵种 / 兵种选择 | class / Class Selection | 兵種 / 兵種選擇 | 沿用 `djzc.dialog.userbook.type_choose` |
| 冬战成员用书 | Dong's MC Warfare Member's Handbook | 冬戰成員用書 | 沿用 `djzc.book_userbook`、`djzc.dialog.userbook` |
| 冬战制作组 | the Dong's MC Warfare Team | 冬戰製作組 | 署名 `djzc.dialog.author1`，配 `Written by %1$s` / `%1$s 編寫` |
| 冬季战场 | Dong's MC Warfare | 冬季戰場 | 项目名，不用 "Minecraft XXX" 这类官方关联命名 |
| 百科全书 | Encyclopedia | 百科全書 | 沿用 `djzc.dialog.wiki` |
| 传送系统 | Teleportation System | 傳送系統 | 成员用书里的传送入口 |
| 步话机 | walkie-talkie | 步話機 | 沿用 `djzc.dialog.userbook.msg` |
| 重新部署 | Redeploy | 重新部署 | 沿用 `djzc.dialog.userbook.redeploy` |
| CT / T 阵营 | Team CT / Team T | CT / T 陣營 | 占点播报用 `... captured by Team T!` |

格式约定：`Zone` 一律改 `Point`（含 README 英文正文）；`Point X` 一律写成 `X Point`；`the X point` 这类带冠词的句式保留小写 point，不算词序问题。`%1$s`、`%2$s` 等占位符和 `keybind` 组件在四种语言里都要原样保留，改译文时不能替换掉。

## 10. 调用示例

管理员开关 boost。

```mcfunction
function djzc444:option/boost
```

玩家交准备状态，目标得先启用。

```mcfunction
trigger djzc.prepare set 1
```

玩家选地图，同样要 `djzc.map` 已启用。

```mcfunction
trigger djzc.map set 1
```

以玩家身份打开动态成员用书、教程主页。

```mcfunction
function djzc444:dialog/user_dialog
function djzc777:open
```

开始一局，会动全局状态，只给管理员用。

```mcfunction
function djzc444:game/start
```

把轨迹换成烟雾，再让通用入口跨 tick 飞一次。用完把 `ray_sleep` 清回 `0`，这个分数是持久的。

```mcfunction
function djzc555:raycast/particle/campfire_cosy_smoke
scoreboard players set @s djzc555.ray_sleep 2
execute as @s at @s run function djzc555:raycast/block
scoreboard players set @s djzc555.ray_sleep 0
```

sleep 模式的结果要等若干 tick，后续逻辑写在 `djzc555:raycast/internal/on_result` 里，参数就是本条射线自己的结果副本，别在调用后立刻读 `result`。要跨 tick 取，把 `ray_keep` 设 `1`，结果落在 `results.u<uid>`，用 `internal/consume_result` 取。

## 11. 兼容性与安全注意事项

- 地图切换会留旧键。`data merge storage djzc:map` 只覆盖写进去的键，从 `dz_djzc` 切到 `jc_basic` 后旧图的机场和空中出生点字段还在。
- 一部分坐标仍然硬编码。`game/start` 把 CT/T 传到 `-405 30 -809` / `-397 30 -809`，`end_custom` 和 `load` 用 `-434 41 -709`，`tutorial/end` 也用这两组。它们属于 `dz_djzc` / `jc_basic` 起始区域，加新地图前得迁走。
- `initialize`、开局/结束、boost 配置这些函数副作用很大，开放给外部调用前先把权限和适用场景说清楚。
- `game/start` 会关命令方块输出、关 `mob_griefing`，重置一大堆计分板、BossBar、展示框和启动器状态，别在对局管理之外随手调

## 12. 后续维护清单

- [ ] 把 `game/start`、`end_custom` 的固定坐标迁到地图元数据或 `unique` 函数（`tutorial/start`、`tutorial/end` 的传送坐标仍写死，一并核）
- [ ] 把 `data/minecraft/tags/block/raycast.json` 接进射线检测，或者明确弃用删掉
- [ ] 施法者标签清理靠 `sort=nearest` 找当前 marker，多人挤在一起同时开火有边缘情况
- [ ] 逐项登记跨命名空间函数、Storage 键、实体标签、谓词和地图依赖
- [ ] 在目标 Minecraft 版本里验传送、兵种限制、地图切换和管理菜单权限

### 12.1 不是BUG/已修复的部分
- [x]  `djzc444:damage_half` / `damage_ltjd` 的 `set_damage` 负值方向，`lib_boom_marker` / `lib_rocket_ltjd` 按扣耐久用（看起来很奇怪，但是，这是有用的）
- [x]  `pack.mcmeta` 声明的数据包格式范围是 `94.1` 到 `101.1`，实际能不能跑还得在目标 Minecraft 版本里验。（其实就是能跑）
- [x] 给管理菜单 `djzc.option=17` 补 OP 校验（启动的管理页面中的所有操作都需要OP权限）
- [x] sleep 模式多条射线并存的结果隔离，marker 副本加 `ray_keep` 分槽，`on_result` 改成带参数的宏调用
- [x] 给需要长期支持的外部调用定稳定性等级和回归用例（这是用于专用地图的项目，一般情况下不会被外部调用）
- [x] 切地图时清 `storage djzc:map` 里没被新图覆盖的旧键（在元数据中添加了机场）
- [x] 高频路径的 Guard Clause 优化：`lib_books`、`time_custom`、`lib_missile_track_do` 改用 `return` 提前终止，省掉重复条件判断；低频的 `game_eula`（60 秒）和 `tutorial/end`（按钮触发）保持原样
- [x] 教程 dialog 的 fallback 与 zh_cn 值逐键对齐；`tutorial_starter` 拆出 body3、`tutorial_c.body2` 与「找不到启动器」文案互换，译文已同步
- [x] `music_af` 从 `djzc444:function/` 迁到 `djzc444:function/game/music_af`，调用方 `type_bzb`、`type_ltjd` 同步改路径
- [x] 启动器高亮去掉多余的 `sort=nearest`（`game_starter_display` / `game_starter_nodisplay`），`@n` 本来就是单个目标
- [x] `djzc.map.jc_basic.exit`「离开靶场」补进四语言，资源包与数据包两侧一致

## 13. Git 提交与更新日志范式

### Git Commit

| 版本名 | 命名格式 | 例 |
| --- | --- | --- |
| 想得出名字就写 | `<版本>[+<主题>+<标记（可选）>] for <MC版本>` | `1.0.6+blockentity hotfix for 1.21.11` |
| 想不出名字，只写日期 | `### <版本>-<日期>-by-<第一作者>/<第N作者> start:<开始日期> end:<结束日期>` | `### 1.0.7 1108-by-CE_PT start:2026/11/05 end:2026/11/07` |

### CHANGELOG

- 文件名现在叫 `CHANGELOG.md`，README 已经改成引用这个名字，维护时别让两边对不上。
- 标题层级用版本号和代号标发布线，用 `start`、测试和 `release` 日期记进度，下面按主题用 `####` 分类，比如「游戏逻辑优化」「数据包结构优化」「BUG 修复」「多语言支持」。
- 条目开头用动作词，说清改了什么、结果如何。功能调整写「增加」「移除」「将……改为……」「从……调整为……」，问题修复写原因和具体问题，别只留一句「已优化」「已修复」。
- 每条项目符号记一项能核实的改动。一项改动带多个结果，用缩进子项展开。测试报告、阶段记录、正式版本变更分开写，按主题归类，别照抄 commit 列表。
- 以中文为主，说人话，可以留点口语。重点对象和功能名加粗，命令、文件名、组件名、字段名用反引号。别整句加粗，也别拿夸张措辞代替实际结果。
- 模板，功能调整写 `- 将<对象>从<原行为>调整为<新行为>，<条件或结果>`，问题修复写 `- 修复了<场景>下因<原因>导致的<具体问题>`。结果多、条件绕的时候再补缩进子项。
