# 冬季战场数据包接口文档

> 本文依据当前工作区的数据包代码重新整理。项目尚未定义带版本号的 API 契约；本文将游戏菜单、对话框和 `trigger` 交互视为玩家接口，其余函数默认按内部实现处理。
>
> **当前工作区状态：** HEAD 为 `55a55ec`（`### 1.0.7 1104-by-CE_PT`），工作区中存在尚未提交的 `1.0.7-1108-by-CE_PT` 改动（地图选择、百科地图分页、`djzc:game` 存储迁移等）。本文以工作区实际代码为准，而不是以已提交版本为准。

## 1. 基本信息

| 项目 | 内容 |
| --- | --- |
| 数据包 | 冬季战场（Dong's MC Warfare） |
| 当前文档对象 | 工作区当前代码 |
| 版本名 | `1.0.7-1108-by-CE_PT`（开发中） |
| Git HEAD | `55a55ec`（`1.0.7 1104-by-CE_PT`） |
| Minecraft 版本 | Java 版 1.21.11 |
| 数据包格式 | `min_format` `94.1`，`max_format` `101.1` |
| 主要命名空间 | `djzc444` |
| 相关命名空间 | `djzc555`、`djzc666`、`djzc777`、`djzc888` |
| 函数目录 | `data/<namespace>/function/` |
| 函数调用格式 | `function <namespace>:<路径>` |
| 数据包根目录 | `datapacks/djzc444/` |

## 2. 接口约定

- 数据包函数使用命名空间 ID 调用，例如 `function djzc444:option/boost`。
- 函数依赖当前的执行者、位置和维度上下文。调用前应确认它是否要求玩家执行者（`@s`）、特定队伍、实体标签或坐标位置。
- 玩家菜单通过 `trigger` 类型的计分板目标提交选项，再由 tick 函数读取并分发请求。
- `djzc.*` 计分板目标保存游戏流程、玩家统计和内部计算状态。除本文列出的 `trigger` 入口外，其余目标均按内部实现处理，不建议外部直接修改。
- 对话框、物品和记分板显示属于交互接口；其按钮或使用行为所执行的命令，也属于相应接口的一部分。

### 2.1 代码范式

- **按领域拆分函数**：以命名空间区分数据包组件，再按职责将 `.mcfunction` 文件放入 `game/`、`points/`、`tp/`、`type/`、`weapon/`、`dialog/` 等目录。入口函数负责编排，具体操作交由子函数完成。
- **通过生命周期函数轮询和分发**：`load`、`tick` 标签是主要调度入口。`tick` 每个游戏刻检查对局阶段、玩家计分板和谓词，并调用相应处理函数。玩家菜单将请求写入 `trigger` 计分板目标，再由 tick 逻辑处理。
- **用计分板维护状态**：计分板保存玩家状态和统计数据，也控制对局流程、战区进度及菜单请求。函数通过 `execute if/unless score` 判断状态并推进流程。Storage 用于传递结构化参数和动态界面数据。
- **执行上下文是隐式输入**：函数通常不接收显式参数，而是依赖执行者、位置、队伍、标签、谓词和计分板。调用或复用函数时，应核对 `@s`、`@p`、`as`、`at` 等上下文，避免作用于错误实体或位置。
- **交互层调用业务逻辑**：对话框按钮执行 `trigger` 或函数命令；tick 分发器读取请求，再调用兵种、传送、统计等模块处理。
- **地图数据与逻辑解耦**：地图坐标通过 `storage djzc:map` 注入，函数通过宏参数读取 `x`、`y`、`z`、`dx`、`dy`、`dz`、`name` 等字段。新增地图时应提供同结构的 `main.mcfunction` 和 `unique.mcfunction`，而不是复制整套业务函数。
- **地图仍有硬编码残留**：对局开始、教程结束和默认重生点仍写死在 `dz_djzc` / `jc_basic` 起始区域坐标，迁移地图时必须一并核对。

开发时宜沿用“入口负责分发、领域函数负责单项行为”的结构。新增状态前，应先确认它属于玩家计分项还是虚拟玩家计分项，并检查其初始化位置、tick 调度方式及所有读写位置。

## 3. 生命周期入口

数据包通过 `data/minecraft/tags/function/` 注册生命周期函数：

| 入口 | 注册内容 | 用途 |
| --- | --- | --- |
| `minecraft:load` | `djzc444:load`、`djzc555:load`、`djzc666:load`、`djzc777:load`、`djzc888:load` | 初始化计分板、队伍、BossBar、地图元数据，并显示加载提示。数据包加载或执行 `/reload` 时触发。 |
| `minecraft:tick` | `djzc444:tick`、`djzc444:advancement/detection`、`djzc666:tick`、`djzc888:tick` | 按标签顺序执行对局逻辑、成就检测、导弹系统和地图选择。 |

`djzc444:load` 还会：

- 设置 `keep_inventory`、`players_sleeping_percentage` 等游戏规则；
- 授予 `djzc444:fight/root` 和 `djzc444:intro/root` 成就；
- 将世界出生点和玩家出生点设为 `-434 41 -709 -505 0`；
- 创建 `djzc.gameflow`、`djzc.time` 等计分板目标、`starter` / `T` / `CT` 队伍和 `djzc_game:time` / `djzc_point:*` BossBar；
- 调用 `djzc444:game/game_eula` 显示欢迎界面，并每 60 秒重复检查未同意协议的玩家；
- 若 `initialize djzc.option` 不为 `1`，调用 `djzc444:initialize` 执行首次启动配置。

`djzc444:tick` 的主要执行顺序：

1. 对局主时钟和常驻时钟；
2. 准备系统（`game/game_prepare`）；
3. 强制生存模式玩家进入冒险模式；
4. 重新启用所有玩家的 `trigger` 目标；
5. 步话机、成员用书和成书检测；
6. 兵种选择与传送系统（非 debug 模式要求玩家 Y 坐标在 `-100..40`）；
7. 用户协议同意后的阵营选择；
8. 垂直机动、新星、三连发、轰炸指示器、雷枪、烟雾弹、无人机、干扰弹；
9. 阵亡计分板；
10. 占点系统与启动器系统。

首次启动存档时，由 `djzc444:initialize` 执行额外配置：启用 boost、复位 debug / 导弹模式 / 兵种开关、运行一次 `second` 和 `time_initialize`、启动并立即结束一局以写入必要参数、显示血量、发送首次启动提示，最后把 `initialize djzc.option` 设为 `1`。该函数会改变对局状态，不应用来代替普通数据包重载；在已有存档中调用前，应先备份并确认当前状态。

## 4. 玩家输入接口（Trigger）

游戏 tick 会重新启用玩家的 `trigger` 目标，并读取、处理玩家提交的请求。基本调用形式如下：

```mcfunction
trigger <objective> set <value>
```

| 目标 | 已确认用途 | 值域/说明 |
| --- | --- | --- |
| `djzc.prepare` | 提交准备状态 | 准备阶段中，`1` 表示已准备，`0` 表示取消准备。至少一名已加入 CT/T 的玩家在线，且所有 CT/T 玩家均为 `1` 时，游戏开始。 |
| `djzc.type_choose` | 选择兵种 | `1` 近战兵（JZB）；`2` 狙击手（JJS）；`3` 防空兵（FKB）；`4` 立体机动/航空兵（LTJD）；`5` 三叉戟兵（SCJ）；`6` 游骑兵（YQB）；`7` 冈格尼尔（GGNE）；`8` 板载兵（BZB）。 |
| `djzc.tp` | 选择传送目的地 | 见下方传送编号表。目的地是否可用由对应 `tp/` 函数判定。 |
| `djzc.ctmsg` | CT 阵营步话机 | `1` 赞成；`2` 反对；`3` 冲锋；`4` 撤退；`5` 发现敌人；`6` 请求支援；`7` 掩护；`8` 彩蛋；`9-12` 进攻 A-D；`13-16` 防守 A-D。 |
| `djzc.tmsg` | T 阵营步话机 | 编号与 CT 相同；请求由 `function/tmsg/` 中对应编号的函数处理。 |
| `djzc.option` | 成员用书及菜单操作 | `1-7` 侧边栏统计；`8` 统计菜单；`9` 加入 CT；`10` 加入 T；`11` 兵种选择；`12` 步话机；`13` 重新部署；`14` 中止个人音乐；`15` 成员用书；`16` 传送系统；`17` 兵种管理；`18` 地图选择。 |
| `djzc.eula` | 用户协议交互 | 玩家点击同意时提交 `-1`；tick 将其处理为 `1` 并打开阵营选择。`1` 表示已同意。 |
| `djzc.map` | 地图选择 | `1` 冬季战场（`dz_djzc`）；`2` 教程-基础教程（`jc_basic`）。 |

### 4.1 传送编号

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

### 4.2 地图编号

| 值 | 地图代码 | 说明 |
| --- | --- | --- |
| `1` | `dz_djzc` | 冬季战场，第一张地图；包含机场和空中出生点。 |
| `2` | `jc_basic` | 教程-基础教程；当前没有机场和空中出生点。 |

玩家提交的 `djzc.map` 分值由 `djzc888:game_map_selection` 读取，写入虚拟玩家 `map djzc.map`，再由 `djzc888:map_swich` 加载对应地图配置。

### 4.3 Trigger 调用约束

- 游戏 tick 会重新启用在线玩家的 `trigger` 目标。目标未启用时，玩家无法执行对应的 `trigger` 命令。
- 菜单通过 `trigger <objective> set <value>` 提交请求，再由 tick 分发处理。处理函数通常会清除相应的玩家分值。
- `djzc.option` 既用于接收菜单请求，也保存部分配置值（`boost`、`debug`、`harmony`、`missile_mode`、`track_type` 等虚拟玩家分值）。不要把玩家的该目标分值当作持久配置。
- **`djzc.map` 的复位目前不生效**：`game_map_selection` 末尾的 `scoreboard players reset @s djzc.map` 不在 `as @a` 上下文中，`@s` 在 tick 顶层没有实体。玩家提交过一次地图编号后，该分值会一直保留，并在每个 tick 重复把 `map` 虚拟玩家设为同一编号。实际表现是地图会持续重复加载；多名玩家保留不同编号时，还会按选择器顺序互相覆盖。如需一次性选择，应手动清除该玩家分值或修正该行。
- 对外集成时优先复用游戏内菜单。直接提交 `trigger` 可能绕过界面层限制；还应检查对应处理函数是否校验权限、阵营和对局阶段。
- **权限注意**：管理用书的展示入口受 `select_opbook` 谓词限制，但 tick 对 `djzc.option=17` 的分发没有 OP 判断。能提交该值的玩家可能打开兵种管理对话框；若此入口应仅限 OP 使用，需在分发逻辑中增加权限校验，并在游戏内验证。

### 4.4 兵种选择限制

- 八个兵种的选择函数都会检查 `jzb` / `jjs` / `fkb` / `ltjd` / `scj` / `yqb` / `ggne` / `bzb` 在 `djzc.type` 中的开关。兵种已禁用时，系统会提示“该兵种目前已被游戏禁用”。
- 航空兵（`djzc.type_choose=4`）需要先取得本局解锁进度 `djzc444:tool/hkb`。`advancement/detection` 会在玩家本局击杀数 `djzc.count_kill >= 立体机动 djzc.type`（当前值为 `5`）时授予该进度；未解锁时，系统会显示“击杀数小于5，无法购买”。
- 板载兵（`djzc.type_choose=8`）每局限用一次。选择时会给玩家自己的 `djzc.type` 分值加 `1`，并与虚拟玩家 `神风特攻`（当前值为 `1`）比较；再次选择时，系统会显示“你已玉碎，无法购买”。
- 其他兵种没有额外的击杀门槛。具体配装及重生、传送行为由对应的 `type/` 函数处理。
- 选择成功后，`weapon/books_all` 会同时发放步话机和成员用书。

### 4.5 传送与步话机细则

- 非 debug 模式下，只有当玩家的 Y 坐标在 `-100` 至 `40`（含边界）之间时，tick 才会处理兵种选择和传送请求。debug 模式（`debug djzc.option=1`）不受这一高度限制。
- A、B 点的传送权限由对应的战区流程分值决定：分值为 `0` 时允许 CT 进入并拒绝 T；非 `0` 时允许 T 进入并拒绝 CT。
- C、D 点使用不同状态值：`0` 表示允许 CT 进入；`-1` 表示允许 T 进入；`1`（已开放但尚未占领）时双方都不能直接传送。占领后流程会把分值置为 `-1`。
- C1-C3、D1-D3 启动器点位的分值为 `0` 时允许 CT 进入，非 `0` 时允许 T 进入。出生点、空中出生点和机场仅允许对应阵营进入。
- “最近队友”使用同队选择器，并通过至少 `1` 格的距离排除玩家自身；“随机队友”使用同队随机选择器，但没有明确排除玩家自身。两者都会播放本队的“我来助你”语音。
- 步话机编号 `1-7` 和 `9-16` 只发送给本队；编号 `8` 的 Ciallo 会发送给所有玩家。各编号的默认文案如下：

| 值 | CT/T 步话机 fallback 文案 |
| --- | --- |
| `1-2` | 赞成！、反对！ |
| `3-7` | 和我一起冲上去！、撤退！、发现敌人！、请求支援！、我来助你！ |
| `8` | Ciallo～(∠・ω< )⌒★！ |
| `9-12` | 进攻 A 点！、进攻 B 点！、进攻 C 点！、进攻 D 点！ |
| `13-16` | 防守 A 点！、防守 B 点！、防守 C 点！、防守 D 点！ |

- 机场逻辑由 `djzc444:points/airport_x` 处理：玩家进入机场区域后，`djzc.airport_ct` / `djzc.airport_t` 从 `30` 开始每秒递减；归零且玩家带有 `AF` 标签时，发放空空导弹、空地导弹、雷枪、机炮火箭和干扰弹，并把倒计时重置为 `30`。机场内还会显示补给倒计时 actionbar。
- 如果己方机场内有玩家，且 `75` 格内存在敌方 `AF` 单位，机场会给该玩家授予 `djzc666:tool/missile_sam`，通过成就奖励触发一次地对空导弹发射。
- `jc_basic` 的机场和空中出生点字段在配置文件中被注释掉，因此该地图不会执行机场补给；传送菜单仍会显示 17-20 号按钮，但对应 `tp_af*` 缺少坐标时宏调用会失败（若之前加载过 `dz_djzc`，还可能使用残留的旧坐标）。

### 4.6 阵营选择与准备

- 阵营选择仅在对局未开始时允许（`game djzc.gameflow=0`）。对局进行中，从 T 选择加入 CT（或反向）会被 `option/no_run` 拒绝并提示“系统拒绝了你的要求，因为这是叛逃。”；选择本方阵营不会产生实际变化。
- 准备系统只统计 `team=T` 和 `team=CT` 的玩家，未加入阵营的玩家不会阻止开局。至少一名已入队玩家在线，且所有已入队玩家准备时，`game/game_prepare` 调用 `game/start`。
- `game/end_custom` 会把所有玩家的 `djzc.prepare` 重置为 `0`，并显示“点此再玩一局”的可点击文本。

### 4.7 地图选择与开局前置

- 地图选择对话框由 `djzc444:option=18` 触发，按钮分别提交 `trigger djzc.map set 1` 和 `set 2`。
- 地图配置由 `djzc888:map_swich` 按虚拟玩家 `map djzc.map` 加载。`game/start` 也会调用一次 `map_swich`。
- 含 `$(map_name)` 的动态对话框（成员用书、传送系统、地图选择）依赖 `storage djzc:game.map_name`。该键由地图配置写入；全新存档在首次加载地图前打开这些对话框，会因缺少宏参数而无法渲染。静态 JSON 版成员用书（G 键 / 暂停菜单）本身可正常打开，但其中的地图选择链接同样受此限制。
- 因此，新存档的正确顺序是：先用命令设置 `scoreboard players set map djzc.map 1`（或直接 `function djzc888:dz_djzc/main`）写入地图，再使用成员用书、传送和开局流程。

### 4.8 管理接口

管理用书（`custom_data.tags` 含 `opbook`）可直接调用：

```mcfunction
function djzc444:weapon/book_opbook
```

使用管理用书会打开动态管理菜单（`dialog/op_dialog`），包含：

- Boost 开/关：`djzc444:option/boost`、`unboost`；
- debug 开/关：`scoreboard players set debug djzc.option 0|1`；
- 强制启动/中止：`djzc444:game/start`、`end_custom`；
- 和谐冬战开/关：`do_harmony`、`no_harmony`（会修改地图中的旗帜图案）；
- 导弹制导模式：`djzc666:option/do_missile_vector`（`missile_mode=1`）和 `do_missile_tp`（`missile_mode=0`）；
- 导弹目标判定：`djzc666:option/do_track_predicate`（`track_type=1`）和 `do_track_tag`（`track_type=0`）。

静态管理对话框 `djzc444:op` 也可通过 `/dialog show @s djzc444:op` 直接打开；它不显示实时状态栏，按钮行为与动态版一致。欢迎界面中也向管理员提示了这一入口。

## 5. 对话框接口

### 5.1 静态 JSON 对话框

以下对话框在 `data/djzc444/dialog/` 或 `data/djzc777/dialog/` 中定义，可直接用 `dialog show @s <id>` 打开（要求玩家执行者）：

| 对话框 ID | 用途 | 打开方式 |
| --- | --- | --- |
| `djzc444:eula_notice` | 用户协议与欢迎界面 | `game/game_eula` 每 60 秒检查未同意玩家 |
| `djzc444:team_selection` | 阵营选择 | 玩家提交 `djzc.eula=-1` 后由 tick 打开 |
| `djzc444:scoreboard` | 统计信息菜单 | `djzc.option=8` |
| `djzc444:ctmsg` / `djzc444:tmsg` | CT/T 步话机 | 右键带 `msg` 标签的成书，或 `djzc.option=12` |
| `djzc444:type_choose` | 静态兵种选择页（8 个按钮） | `djzc777:tutorial_choose` 内的链接 |
| `djzc444:userbook` | 静态成员用书 | G 键快捷菜单、暂停菜单、百科返回链接 |
| `djzc444:op` | 静态管理用书 | `/dialog show @s djzc444:op` |
| `djzc444:wiki/wiki_notice` | 冬季战场百科全书主页 | 成员用书中的“百科全书”链接 |
| `djzc444:wiki/wiki_before_play` | 玩前必看 | 百科主页 |
| `djzc444:wiki/wiki_map` | 地图速览 | 百科主页 |
| `djzc444:wiki/wiki_map_dz_djzc` | 冬季战场地图页 | 地图速览 |
| `djzc444:wiki/wiki_map_jc_basic` | 教程-基础教程地图页 | 地图速览 |
| `djzc444:wiki/wiki_how_to_play` | 游戏流程 | 百科主页 |
| `djzc444:wiki/wiki_type_intro` | 兵种介绍目录 | 百科主页、地图速览 |
| `djzc444:wiki/wiki_type_jzb` 等 8 个页面 | 八个兵种介绍 | 兵种介绍目录 |
| `djzc444:wiki/wiki_credits` | 制作人名单 | 百科主页 |
| `djzc777:tutorial/root` | 新手教程主页 | `function djzc777:open`、暂停菜单 |
| `djzc777:tutorial_skip` | 教程跳过/入门选择 | 教程主页 |
| `djzc777:tutorial_a` / `b` / `c` | 实境教程提示页 | 教程流程 |
| `djzc777:tutorial_gui1` / `gui2` / `gui3` | 成员用书说明页 | 教程流程 |
| `djzc777:tutorial_choose` | 教程中的兵种选择页 | 教程流程 |
| `djzc777:tutorial_end` | 基础教程结束页 | 教程流程 |
| `djzc777:tutorial_advanced` | 进阶教程占位页 | 教程结束页 |
| `djzc777:tutorial_win` | 胜利提示页 | 教程流程 |

### 5.2 动态（内联）对话框

以下对话框没有对应的静态 JSON 文件，而是由宏函数用 `$dialog show @s { ... }` 内联生成。必须先准备对应的 Storage，再以 `with storage` 调用：

| 入口函数 | 生成内容 | 参数来源 | 触发方式 |
| --- | --- | --- | --- |
| `djzc444:dialog/user_dialog` → `dialog/userbook` | 带实时地图名和剩余时间的成员用书 | `storage djzc:game` | 右键成员用书、`djzc.option=15` |
| `djzc444:dialog/tp_dialog` → `dialog/tp_system` | 20 个传送目的地、当前地图名和剩余时间 | `storage djzc:game` | `djzc.option=16`、成员用书退出按钮 |
| `djzc444:dialog/choose_dialog` → `dialog/type_choose` | 带兵种启用状态和颜色的兵种选择页 | `storage djzc:type_manage` | `djzc.option=11` |
| `djzc444:dialog/manage_dialog` → `dialog/type_manage` | 兵种管理系统（复选框、预设、确认） | `storage djzc:type_manage` | `djzc.option=17` |
| `djzc444:dialog/op_dialog` → `dialog/op` | 带实时状态栏的管理用书 | `storage djzc444:op` | 右键管理用书 |
| `djzc444:dialog/map_dialog` → `dialog/map_selection` | 地图选择页（1/2） | `storage djzc:game` | `djzc.option=18` |

旧版静态对话框 `data/djzc444/dialog/tp_system.json` 已在 1108 改动中删除；传送系统现在只有 `dialog/tp_system` 内联版本。

动态对话框共用的参数约定：

- `djzc:game`：`minute`、`second` 由 `second.mcfunction` 每秒写入；`map_name` 由地图配置写入。缺少任一被 `$(...)` 引用的键，整个宏函数调用会失败，对话框不会显示。
- `djzc:type_manage`：`jzb`…`bzb` 为 `0/1` 开关；`*_color` 为文本颜色；`*_ini` 为复选框初始布尔值；`preset1`…`preset8` 为预设单选初始值；`template_preset`、`template_confirm` 为 `dynamic/run_command` 模板；`minute`、`second` 为时间。
- `djzc444:op`：`boost`、`debug`、`gameflow`、`harmony`、`missile_mode`、`track_type` 为数值；`*_color` 为状态栏颜色。

### 5.3 对话框关系

- 百科主页 `wiki_notice` 链接到 `wiki_before_play`、`wiki_map`、`wiki_how_to_play`、`wiki_type_intro`、`wiki_credits`。
- `wiki_map` 链接到 `wiki_map_dz_djzc`、`wiki_map_jc_basic`、`wiki_type_intro`；两张地图页互相链接，并可返回百科主页。
- `wiki_type_intro` 链接到八个 `wiki_type_*` 页面；每个页面返回兵种介绍目录。
- `wiki_before_play` 和 `wiki_how_to_play` 的正文链接指向 `wiki_map`；两者的退出按钮都返回百科主页 `wiki_notice`。
- `userbook`（静态和动态）的正文链接包括百科、统计、地图选择、管理用书；退出按钮进入传送系统。
- `tutorial_end` 可结束教程、查看进阶占位页或重播教程主页；`tutorial_choose` 可直接打开静态 `djzc444:type_choose`。

### 5.4 快捷入口标签

- `data/minecraft/tags/dialog/quick_actions.json`：`djzc444:userbook`。按 G 键（`key.quickActions`）打开静态成员用书。
- `data/minecraft/tags/dialog/pause_screen_actions.json`：`djzc444:userbook`、`djzc777:tutorial/root`。ESC 暂停菜单可打开成员用书或新手教程。

## 6. 函数接口与模块

以下是主要函数和模块的索引。路径相对于 `data/djzc444/function/`。数据包函数通常不接收独立参数，其输入来自 Minecraft 的执行上下文及计分板、Storage 等状态。

| 模块/函数 ID | 用途 | 调用注意 |
| --- | --- | --- |
| `djzc444:option/boost`、`djzc444:option/unboost` | 启用或关闭 boost 模式 | 会修改多项游戏规则；关闭前建议备份存档。 |
| `djzc444:initialize` | 初始化存档 | 会改变多项游戏状态，不是常规重载入口；不要在已有对局中重复调用。 |
| `djzc444:dialog/user_dialog`、`dialog/tp_dialog`、`dialog/op_dialog`、`dialog/manage_dialog`、`dialog/choose_dialog`、`dialog/map_dialog` | 打开对应动态对话框 | 要求玩家作为 `@s` 执行；会清理相关 `trigger` 分值。 |
| `djzc777:open` | 打开新手教程主页 | 要求玩家作为 `@s` 执行，并显示 `djzc777:tutorial/root`。 |
| `djzc777:tutorial/start`、`djzc777:tutorial/end` | 开始或结束实境新手教程 | 要求玩家作为 `@s` 执行；会修改教程阶段分值、阵营、重生点和玩家位置，且依赖固定地图坐标。 |
| `djzc444:game/start`、`game/end_custom`、`game/end_ct`、`game/end_t` | 开始或结束一局 | 属于内部流程函数；直接调用会改变全局对局状态，不应视为稳定的外部 API。 |
| `djzc444:game/game_flow`、`flow_begin`、`flow_a_b`、`flow_c_d`、`flow_end` | 对局流程状态机 | 由占点、启动器或时钟触发；内部实现。 |
| `djzc444:points/x_point`、`x_point_reset`、`x_occupy_by_t`、`x_occupy_by_ct` | 通用占点更新、复位与占领回调 | `x_occupy_by_ct` 当前没有调用方，属于预留逻辑。 |
| `djzc444:points/starter_x`、`c_starter`、`d_starter` | 启动器激活、C/D 点启动器阶段结算 | 通过宏读取 `storage djzc:map` 中的启动器字段。 |
| `djzc444:points/airport_x` | 机场补给与地对空导弹触发 | 通过宏读取 `airport_ct` / `airport_t`。 |
| `djzc444:game/game_starter_x`、`game_starter_display`、`game_starter_nodisplay`、`game_starter_reset` | 启动器展示框检测、盔甲架高亮/清除、开局复位 | 通过宏读取启动器坐标和 `frame_facing`。 |
| `djzc444:game/lib_*` | 战斗与支援机制 | 由 `tick` 调度；内部实现。 |
| `djzc555:raycast/ground`、`raycast/rocket`、`raycast/spawn_at_result` | 即时射线检测与落点标记 | `ground` 和 `rocket` 参数一致；结果写入 `storage djzc555:raycast result`。 |
| `djzc666:game/lib_missile_*`、`missile_scan`、`missile_fox`、`missile_rifle`、`missile_sam` | 导弹制导、近炸引信、扫描与发射 | 发射函数由成就奖励调用；内部实现。 |
| `djzc888:map_swich`、`dz_djzc/main`、`jc_basic/main`、`game_map_selection`、`tick` | 地图元数据注册与选择 | `map_swich` 按 `map djzc.map` 调用地图配置写入 `storage djzc:map`；`game_map_selection` 由 tick 调用。 |
| `djzc444:option/test_tool/*` | 开发测试工具 | 仅供开发调试，不属于稳定接口。 |

### 6.1 地图元数据接口（`djzc888`）

- `djzc888:map_swich` 是地图系统的加载入口。它读取虚拟玩家 `map djzc.map` 的分值：`1` 调用 `djzc888:dz_djzc/main`，`2` 调用 `djzc888:jc_basic/main`。
- 每张地图的 `main.mcfunction` 使用 `data merge storage djzc:map { ... }` 写入地图元数据，并写入 `storage djzc:game.map_name`。
- `djzc888:tick` 每 tick 调用 `djzc888:game_map_selection`：读取玩家 `djzc.map` 的 `1/2`，写入虚拟玩家 `map djzc.map`，再调用 `map_swich`。
- `game/start` 也会调用 `map_swich`，确保开局使用当前选择的地图。
- `flow_begin`、`flow_a_b`、`flow_c_d`、`flow_end`、`c_starter`、`d_starter` 会通过 `$function djzc888:$(name)/unique` 调用当前地图的特色函数；`starter_x` 和 `x_occupy_by_*` 通过 `game_flow` 间接进入流程。`$(name)` 来自 `storage djzc:map map_data.name`。
- `storage djzc:map` 的常用字段：

| 键 | 字段 | 用途 |
| --- | --- | --- |
| `map_data` | `name` | 地图代码，用于 `djzc888:$(name)/unique`。 |
| `a_point` / `b_point` / `c_point` / `d_point` | `x`、`y`、`z`、`dx`、`dy`、`dz`、`glass_x`、`glass_y`、`glass_z`、`NAME`、`name`、`gameflow` | 战区范围、玻璃颜色复位坐标、显示名和占领后的流程值（A/B 为 `1`，C/D 为 `2`）。 |
| `airport_ct` / `airport_t` | `x`、`y`、`z`、`dx`、`dy`、`dz`、`name`、`TEAM`、`team`、`ENEMY_TEAM`、`enemy_team` | 机场区域、阵营和补给计分板后缀。 |
| `c1`…`c3` / `d1`…`d3` | `x`、`y`、`z`、`NAME`、`name`、`frame_facing` | 启动器展示框位置、显示名和朝向。 |
| `tp_a`…`tp_af4` | `x`、`y`、`z` | 传送目的地坐标。 |

- 当前地图差异：
  - `dz_djzc` 写入机场 `airport_ct` / `airport_t` 和 `tp_af1`…`tp_af4`；
  - `jc_basic` 的机场和空中出生点字段被注释，不写入；
  - `jc_basic` 的 D 点 `glass_x/glass_y/glass_z` 当前仍为 `-458/60/-761`，与 `dz_djzc` 的 D 点相同，迁移或复位玻璃前应核对。
- **`data merge` 不会删除旧键**：在同一存档中从 `dz_djzc` 切换到 `jc_basic` 时，`airport_ct`、`airport_t`、`tp_af1`…`tp_af4` 等未被 `jc_basic` 覆盖的键会保留旧地图的值。此时 17-20 号传送和机场逻辑仍可能使用旧地图坐标；切换地图后应按需清理 `storage djzc:map`。
- **地图选择前置**：当前没有默认地图；全新存档必须先设置 `map djzc.map`，否则 `map_data` 不存在，开局流程无法加载。详见 4.7。

### 6.2 占点与启动器

- `points/x_point` 每 tick 由 `tick.mcfunction` 以 `with storage djzc:map <point>_point` 调用。仅当 A/B 为 `0`、C/D 为 `1` 时执行。
- 占点进度使用 `djzc.time3` 上的 `T_$(NAME)`（内部累计值，初始 `1040`）和 `T_S$(NAME)`（对外进度，初始 `60`）：
  - 每 tick 取点内最近的一名 T 玩家，使其 `T_$(NAME)` 减 `2`；再取最近的一名 CT 玩家，使其加 `1`；
  - `T_$(NAME) <= 1000` 时 `T_S$(NAME)` 减 `1`，`T_$(NAME)` 重置为 `1040`；
  - `T_$(NAME) > 1040` 时 `T_S$(NAME)` 加 `1`，`T_$(NAME)` 重置为 `1002`；
  - `T_S$(NAME) <= 0` 时调用 `x_occupy_by_t`，并把进度重置为 `60`。
- BossBar `djzc_point:<name>` 显示 `T_S$(NAME)`，上限 `60`；`T_S <= 15` 显示红色，否则蓝色；点内无人时隐藏。
- `x_occupy_by_t` 会把玻璃改为红色、把该点流程值设为地图配置中的 `gameflow`、播放占点音效、给点内 T 玩家增加 `djzc.occupy`，然后调用 `game_flow`。`x_occupy_by_ct` 会把玻璃改回蓝色并复位进度，但当前没有调用方。
- `game_starter_x` 读取展示框 `ItemRotation`：值为 `7` 时调用 `points/starter_x` 激活启动器，并把展示框旋转复位为 `0`。如果展示框实体缺失，会按 `frame_facing` 自动补放一个 `glow_item_frame`。
- `points/starter_x` 会清除启动器高亮、播放音效、把该启动器在 `djzc.gameflow` 中设为 `1`，再调用 `game_flow`。
- `game_starter_display` 会给启动器附近的盔甲架添加发光和定位栏；`game_starter_nodisplay` 会清除发光并把定位栏传输范围设为 `0`。
- C 点启动器全部激活后，`game_flow` 调用 `c_starter`：把 `B+` 设为 `2`，随后 `game_flow` 把 `C` 设为 `1`、`B+` 设为 `0`，C 点开放占领；C1-C3 被置为 `-1`。D 点同理。

### 6.3 导弹系统（`djzc666`）

- 武器：
  - 空空导弹：`blaze_rod`，`custom_data.tags=["djzc.missile.aa"]`，每次发放 `4` 个，冷却 `3` 秒；
  - 空地导弹：`breeze_rod`，`custom_data.tags=["djzc.missile.ag"]`，每次发放 `8` 个，冷却 `3` 秒；
  - 地空导弹发射器：`bone`，`custom_data.tags=["djzc.missile.ga"]`，每次发放 `8` 个，冷却 `3` 秒。
- 发射与扫描由隐藏成就触发：
  - 消耗 `djzc.missile.aa` → `djzc666:tool/missile_fox` → `missile_fox`；
  - 消耗 `djzc.missile.ag` → `djzc666:tool/missile_rifle` → `missile_rifle`；
  - 消耗 `djzc.missile.ga` → `djzc666:tool/missile_sam` → `missile_sam`；
  - 长按使用 `blaze_rod` / `breeze_rod` / `bone` → `missile_scan` / `missile_ag_scan` / `missile_ga_scan`，扫描锥形范围内的玩家并使其发光。
- 导弹实体为 `minecraft:snowball`，带有 `missile`、`AA` / `AG` / `GF_AA` 以及 `CT_*` / `T_*` 标签；`Owner` 保存发射者 UUID，`PortalCooldown` 作为引信倒计时。
- 制导模式由 `missile_mode djzc.option` 控制：`0` 为 TP 瞬移制导，`1` 为向量法 Motion 制导。目标判定由 `track_type djzc.option` 控制：`0` 使用 `AF` / `GF` 标签，`1` 使用 `is_on_ground` / `no_on_ground` 谓词。
- 近炸引信：敌方 `AF` / `GF` 单位距离导弹 `3` 格内时，把 `PortalCooldown` 置 `0`；导弹碰到非可替换方块时也会自爆。
- 伤害：`lib_missile_damage` 对 `AA` 标签造成 `84` 点、半径 `5` 格；对 `AG` 标签造成 `46` 点、半径 `5` 格。`GF_AA` 导弹同时带有 `AA` 标签，因此使用 `84` 点那一档。
- 敌导弹告警在 `djzc.time2` 的 `刻=20` 和 `刻=10` 时执行，即每 0.5 秒一次；对 `100` 格内的敌方空军/地面单位显示“敌导弹”。

### 6.4 射线检测、雷枪与轰炸指示器（`djzc555` / `djzc444:game/lib_*`）

- `djzc555:raycast/ground` 和 `djzc555:raycast/rocket` 参数一致：方块检测、步长 `1` 格、最大 `400` 格、射线路径粒子开启。结果写入 `storage djzc555:raycast result`，包含 `hit`、`x`、`y`、`z`、`distance`；实体检测模式还会写入 `entity` UUID，方块检测模式会写入 `block` 状态。
- 射线检测的计分板参数：`djzc555.ray_dist`、`ray_max`、`ray_type`（`0` 方块、`1` 实体、`2` 方块+实体）、`ray_uid`、`ray_step`（值 ×0.1 = 格数）、`ray_particle`。
- 射线检测的方块判定直接使用 `#minecraft:replaceable`。仓库中另有 `data/minecraft/tags/block/raycast.json`（空气、可替换方块、旗帜、按钮、营火、蜡烛、藤蔓、门、铁轨、告示牌、火把等），但当前函数未引用它，属于待接线/遗留配置。
- **雷枪**（`lib_rocket_ltjd`）：
  - 由主手/副手的诡异菌钓竿右键触发，要求 `custom_data.tags` 含 `djzc.rocket.ltjd`；
  - `lib_rocket_fire` 执行 `raycast/rocket`，在落点召唤 `ltjd_boom` 标记，再由 `lib_rocket_detonate` 以发射者身份引爆；
  - `lib_rocket_boom` 按距离分 16 档：中心 `0.5` 格内 `70` 点，随后每 `0.5` 格递减，`7.5-8.0` 格为 `2` 点；伤害类型 `minecraft:explosion`，只显式排除带 `djzc.rocket_caster` 标签的发射者，同队豁免由 `/damage` 自动处理；
  - 全图可用，不受 `boom_area` 限制；debug 模式不扣耐久；
  - 物品 `max_damage=16`；每次发射应用 `djzc444:damage_ltjd`（`set_damage` 常量 `-0.0625`，`add: true`），代码按 `minecraft:damage~{damage:16}` 没收耐久耗尽的雷枪。
- **轰炸指示器**（`lib_boom_marker`）：
  - 由主手/副手的胡萝卜钓竿右键触发，计分板为 `djzc.r_click5`；
  - 非 debug 模式下，只有位于 `boom_area` 谓词定义的两个区域内才能召唤；debug 模式全图可用；
  - `lib_boom_single` 执行 `raycast/ground`，在落点召唤 `mark3` 标记，并应用 `djzc444:damage_half`（`set_damage` 常量 `-0.5`，`add: true`）；代码在 `minecraft:damage~{damage:2}` 时没收轰炸指示器；
  - `mark3` 的 `djzc.time2` 倒计时由 `game/time_custom` 每 tick 递减，归零后 `lib_boom_marker_damage` 引爆：中心 `144` 点，`14.5` 格处 `10` 点，伤害类型 `minecraft:explosion`；
  - 爆炸不区分敌我，可能误伤队友；发射者不会被自动排除，这与雷枪不同。
- **烟雾弹**：穿透等级 `9` 的箭会被标记为 `smoke`，落地后持续生成 `campfire_cosy_smoke` 粒子；箭自身的 `life=600`（30 秒）到期后消失。
- **干扰弹**：`djzc.r_click2`（鸡蛋）触发 `lib_jam_egg`，在玩家周围生成带 `jam_decoy` / `AF` 或 `GF` 标签的鸡，持续 5 秒后清除。
- **无人机**：`djzc.r_click3`（蓝色鸡蛋）触发 `lib_allay_drone`，生成带 `drone` / `AF` 标签的悦灵，侦察 32 格内敌人并使其发光，200 tick 后自爆。
- **新星 / 三连发 / 垂直机动**：分别由 `lib_nova`、`lib_sanlian3`、`lib_fly` 处理；后两者依赖 `select_fly`、`jump_sneak` 谓词和对应物品标签。

### 6.5 新手教程（`djzc777`）

- **主页入口**：`function djzc777:open` 以当前玩家 `@s` 显示 `djzc777:tutorial/root`。也可通过 ESC 暂停菜单的 `pause_screen_actions` 打开。
- **开始函数**：`function djzc777:tutorial/start` 在 `djzc.gameflow` 的虚拟玩家 `game` 分值为 `1` 时拒绝开始并提示“对局进行中，暂时不能进入新手教程。”。其他情况下，函数将玩家加入 T 队、设置 `djzc777.tutorial=1`、把重生点和玩家位置设为 `(-434, 41, -709)`、调用 `djzc444:type/type_fkb` 并显示“按%1$s前进”。因此该入口会改变阵营和装备，不是只打开对话框。
- **结束函数**：`function djzc777:tutorial/end` 要求执行玩家已加入 T 或 CT。未选阵营时仅提示并不修改状态；T/CT 玩家会将 `djzc777.tutorial` 设为 `-1`，并分别传送至 T `(-397, 30, -809)` 或 CT `(-405, 30, -809)` 出生位置，同时设置对应重生点并发送“加油，特种兵！”。
- **阶段目标**：`djzc777:load` 创建 dummy 目标 `djzc777.tutorial`；已确认的值为 `1`（教程进行中）和 `-1`（教程完成）。函数未设置玩家默认值，目标不是 `trigger`，不应使用 `/trigger` 提交。
- **当前对话框 ID**：主页 `tutorial/root`、开始选择 `tutorial_skip`、实境提示 `tutorial_a`/`tutorial_b`/`tutorial_c`、成员用书说明 `tutorial_gui1`/`tutorial_gui2`/`tutorial_gui3`、兵种选择 `tutorial_choose`、基础教程结束 `tutorial_end`、进阶占位页 `tutorial_advanced`、胜利提示 `tutorial_win`。
- **兼容性**：旧版 `djzc777:tutorial/ch01` 至 `ch08` 对话框已删除，调用方应改用当前页面 ID。`tutorial/start` 和 `tutorial/end` 使用固定地图坐标，迁移地图前必须核对传送点、阵营与兵种效果；直接调用也可能改变玩家所在队伍或装备。进阶页目前仅为占位入口。

### 6.6 统计与其他系统

- `option/scoreboard_*` 系列函数把对应统计目标显示到侧边栏，并清除 `djzc.option`：
  - `1` 总击杀数（`djzc.stat_kill`）；
  - `2` 总阵亡数（`djzc.stat_death`）；
  - `3` CT 击杀数（`djzc.CT`）；
  - `4` T 击杀数（`djzc.T`）；
  - `5` 战斗场次（`djzc.fight`）；
  - `6` 胜利场次（`djzc.fight_win`）；
  - `7` 失败场次（`djzc.fight_lost`）。
- `game/death_scoreboard` 处理无归属死亡：若 T 玩家不是被 CT 击杀，则把最近 CT 的 `djzc.CT` 和 `djzc.count_kill` 加 `1`；CT 玩家反向同理。处理完会把 `djzc.count_die1`、`djzc.T_D_by_CT`、`djzc.CT_D_by_T` 清零。
- `game/music_stop` 停止所有玩家声音；`end_custom` 结束后 10 秒调度一次 `music_stop`。
- `music_af` 停止所有声音并播放 `music.dragon`（空战曲）。
- `tag_clear` 清除当前玩家的 `GF`、`AF` 和八个兵种标签，兵种函数发装备前调用。
- `support/mechanic_wolf`、`support/allay_drone`、`support/swarm_drones`、`support/smoke` 是独立的手动支援工具函数，目前主要供开发测试或手动发放，未接入主 tick 流程。

## 7. 状态与数据约定

### 7.1 主要计分板分组

| 目标/目标前缀 | 用途概览 | 接口级别 |
| --- | --- | --- |
| `djzc.gameflow` | 对局流程、战区和启动器状态 | 内部状态 |
| `djzc.time`、`djzc.time2`、`djzc.time3` | 对局时钟、常驻时钟和占点计算 | 内部状态 |
| `djzc.option` | 菜单请求，也保存 boost/debug/harmony/missile_mode/track_type 等配置 | 玩家可通过 trigger 提交请求；配置分值属于内部状态 |
| `djzc.type` | 兵种选择、兵种启用状态、预设及相关常量 | 内部状态 |
| `djzc.r_click2`、`djzc.r_click3`、`djzc.r_click4`、`djzc.r_click5`、`djzc.r_click6`、`djzc.r_click7` | 物品使用行为检测 | 内部状态；由 `minecraft.used:*` 准则驱动。`r_click5` 为轰炸指示器，`r_click6` 为雷枪，`r_click4`（棕色鸡蛋）当前无读写方。 |
| `djzc.prepare`、`djzc.tp`、`djzc.type_choose`、`djzc.ctmsg`、`djzc.tmsg`、`djzc.eula`、`djzc.map` | 玩家输入 trigger | 玩家交互入口；值域见第 4 节 |
| `djzc777.tutorial` | 新手教程状态 | 普通 dummy 目标；`1` 表示已开始，`-1` 表示已完成；不是玩家 trigger |
| `djzc.stat_*`、`djzc.count_*`、`djzc.fight*`、`djzc.CT`、`djzc.T`、`djzc.occupy` | 统计数据和对局记录 | 用于统计或展示；写入规则见 6.6 |
| `djzc.airport_ct`、`djzc.airport_t` | 机场补给倒计时 | 内部状态；由 `airport_x` 修改 |
| `djzc555.ray_*` | 射线检测参数与运行状态 | 内部状态 |
| `djzc666.track` | 导弹向量制导计算 | 内部状态 |
| `djzc.hp` | 玩家血量显示（`health` 准则） | 显示接口 |

### 7.2 游戏流程状态

`djzc.gameflow` 的虚拟玩家含义：

| 虚拟玩家 | 值 | 含义 |
| --- | --- | --- |
| `game` | `0` / `1` | 未开局 / 对局进行中。 |
| `A`、`B` | `0` / `1` / `-1` | CT 控制 / T 已占领 / 本轮已结算并进入下一阶段。A、B 都变为 `1` 时进入 C 点启动器阶段。 |
| `C`、`D` | `0` / `1` / `2` / `-1` | CT 控制 / 开放占领 / T 已占领（瞬时）/ 已激活并进入下一阶段。 |
| `A+B` | `0` / `2` | A、B 占领数之和；达到 `2` 触发 `flow_a_b`。 |
| `B+`、`C+` | `0` / `1` / `2` | 启动器阶段标记；`1` 表示启动器高亮可激活，`2` 表示全部激活、等待流程推进。 |
| `C1`…`C3`、`D1`…`D3` | `0` / `1` / `-1` | 未激活 / 已激活 / 本轮已结算。 |
| `C123`、`D123` | `0..3` | 三个启动器的激活数之和；达到 `3` 触发对应启动器结算。 |

流程推进：

1. A、B 都被 T 占领（`A+B=2`）→ `flow_a_b`：A/B 置 `-1`，`B+=1`，高亮 C1-C3。
2. C1-C3 全部激活（`C123=3`）→ `c_starter`：`B+=2`，C1-C3 置 `-1`；`game_flow` 把 `C=1`、`B+=0`，C 点开放占领。
3. C 被 T 占领（`C=2`）→ `flow_c_d`：`C+ =1`，`C=-1`，高亮 D1-D3。
4. D1-D3 全部激活（`D123=3`）→ `d_starter`：`C+=2`，D1-D3 置 `-1`；`game_flow` 把 `D=1`、`C+=0`，D 点开放占领。
5. D 被 T 占领（`D=2`）→ `flow_end`：T 胜利（`end_t`）；若 15 分钟耗尽则 CT 胜利（`end_ct`）。

`djzc.time` 的初始值为 `分=15`、`秒=0`、`刻=0`；`time_game` 只在 `game=1` 时运行，分钟降到 `0` 以下时调用 `end_ct`。`djzc.time3` 还保存占点常量 `1040`、`1000`、`60`、`30`、`15`、`0` 以及 `T_A`…`T_D`、`T_SA`…`T_SD`。

### 7.3 Storage

| Storage | 主要键 | 用途 |
| --- | --- | --- |
| `djzc:game` | `minute`、`second`、`map_name` | 动态对话框的时间与当前地图代码。`second.mcfunction` 每秒写入时间；地图配置写入 `map_name`。 |
| `djzc:map` | `map_data`、`a_point`…`d_point`、`airport_ct`、`airport_t`、`c1`…`c3`、`d1`…`d3`、`tp_*` | 地图元数据；见 6.1。 |
| `djzc:type_manage` | `jzb`…`bzb`、`*_color`、`*_ini`、`preset1`…`preset8`、`template_preset`、`template_confirm`、`minute`、`second` | 兵种选择与兵种管理对话框参数。 |
| `djzc444:op` | `boost`、`debug`、`gameflow`、`harmony`、`missile_mode`、`track_type`、`*_color` | 管理用书状态栏参数。 |
| `djzc444:rocket` | `x`、`y`、`z`、`caster` | 雷枪爆心坐标的宏来源；`caster` 在 `spawn_mark` 中读取，但当前发射链未写入，爆炸归属实际由执行上下文承担；每次发射后清理。 |
| `djzc555:raycast` | `result` | 射线检测结果（`hit`、`x`/`y`/`z`、`distance` 等）；读取后清理。 |
| `example:data` | `arr`、`arr_temp` | 仅 `option/test_tool` 开发示例使用。 |

### 7.4 实体标签

| 标签 | 用途 |
| --- | --- |
| `AF` / `GF` | 空中单位 / 地面单位；导弹目标和雷达判定使用。 |
| `jzb`、`jjs`、`fkb`、`ltjd`、`scj`、`yqb`、`ggne`、`bzb` | 玩家当前兵种标签，由 `tag_clear` 清理后重新添加。 |
| `fly` | 可触发垂直机动的物品标签（`select_fly` 谓词）。 |
| `msg`、`userbook`、`opbook` | 成书物品的 `custom_data.tags`，分别对应步话机、成员用书、管理用书。 |
| `mark3` | 轰炸指示器落点标记，倒计时后爆炸。 |
| `ltjd_boom` | 雷枪爆心标记，只承载坐标，引爆后立即清除。 |
| `djzc.rocket_caster` | 雷枪发射者的临时标签，用于 `tag=!` 排除自身。 |
| `AA`、`AG`、`GF_AA`、`CT_AA`、`T_AA`、`CT_AG`、`T_AG`、`CT_GA`、`T_GA`、`missile` | 导弹实体分类与归属。 |
| `jam_decoy` | 干扰弹生成的鸡诱饵。 |
| `drone` | 悦灵无人机。 |
| `smoke` | 烟雾弹箭矢。 |
| `shot` | 新星成就检测用的箭矢标记。 |
| `djzc555.ray_marker`、`djzc555.ray_live`、`djzc555.ray_caster` | 射线检测内部标记实体与施法者标记。 |
| `djzc666_dir` | 导弹向量制导内部标记。 |

### 7.5 谓词

| 谓词 | 用途 |
| --- | --- |
| `djzc444:boom_area` | 轰炸指示器允许召唤的两个固定区域；非 debug 模式使用。 |
| `djzc444:height_under40` | 玩家 Y 坐标在 `-100..40`，用于兵种选择和传送系统的非 debug 限制。 |
| `djzc444:is_on_ground` / `no_on_ground` | 导弹目标判定的地面/空中状态。 |
| `djzc444:jump_sneak` | 同时按下跳跃和潜行，用于垂直机动。 |
| `djzc444:select_fly` | 主手/副手物品带 `fly` 标签。 |
| `djzc444:select_msg` / `select_userbook` / `select_opbook` | 成书物品标签检测。 |
| `djzc444:select_rocket_ltjd` | 物品带 `djzc.rocket.ltjd` 标签，用于雷枪。 |
| `djzc444:select_carrot_on_a_stick` | 手持胡萝卜钓竿（当前由计分板路径替代，保留谓词）。 |
| `djzc444:move_0` | 玩家移动速度为 0。 |
| `djzc666:missile_locked` | 导弹锁定状态（发光效果等级 5）。 |

### 7.6 伤害类型、物品修饰器与附魔

- 伤害类型：`djzc444:missile`（导弹）、`djzc444:mine`（地雷）、`minecraft:explosion`（轰炸指示器、雷枪）。
- 物品修饰器：
  - `djzc444:damage_half`：`set_damage` 常量 `-0.5`，用于轰炸指示器；
  - `djzc444:damage_ltjd`：`set_damage` 常量 `-0.0625`，用于雷枪。
- 附魔：`djzc444:burstshot`（爆炸开火），最高 1 级，增加弩的弹射物数量和散布，与 `#minecraft:exclusive_set/crossbow` 互斥。

### 7.7 成就

| 成就组 | 用途 |
| --- | --- |
| `djzc444:fight/*` | 可见战斗统计与武器成就；`root` 在加载和对局开始时授予；`count_*` 记录本局击杀/占点。 |
| `djzc444:intro/*` | 增益介绍成就；加载时从 `intro/root` 全部授予。 |
| `djzc444:tool/root`、`tool/hkb`、`tool/cl` | 隐藏工具成就；`hkb` 用于航空兵解锁，`cl` 用于刺雷。 |
| `djzc666:tool/*` | 隐藏发射/扫描触发器；奖励函数生成导弹或执行扫描，随后立即撤销。 |

### 7.8 翻译键与地图解耦

- 地图相关显示文本统一使用 `djzc.map.<地图代码>.*`，例如 `djzc.map.dz_djzc.point_a`、`djzc.map.jc_basic.respawn_sky_ct`。
- 百科地图页标题和简介使用 `djzc.dialog.wiki.map_<地图代码>.title` / `.body1`。
- 新增地图时，应同时补充：
  - `assets/djzc444/lang/*.json` 中的 `djzc.map.<code>.*` 键；
  - `djzc.dialog.wiki.map_<code>.title` / `.body1` 键；
  - `data/djzc444/dialog/wiki/wiki_map_<code>.json`；
  - `wiki_map.json` 中的页面链接；
  - `djzc888:<code>/main.mcfunction` 和 `unique.mcfunction`。
- 数据包内 `assets/djzc444/lang/` 提供备用翻译（当前 616 键 × 4 语言），`assets/minecraft/lang/` 另有 43 键 × 4 语言；配套资源包提供更完整的 619 键 × 4 语言。对话框同时提供 `fallback`，但完整本地化仍需加载资源包。

### 7.9 实测注意事项

以下条目来自实际调试，代码重构后仍适用：

- **队伍名不可从实体 NBT 读取**：`Team` 不是实体 NBT 字段，`data modify storage … set from entity @s Team` 会静默不执行并保留目标路径原值；伤害选择器的 `team=!` 只接受字面量队伍名，不接受变量或选择器。需要按队伍分派时，应使用 `execute if entity @s[team=CT]` 分支配合字面量，或按队伍拆分函数。
- **marker 没有 `Owner` 字段**：`Owner` 只存在于可驯服生物与抛射物上。若要给 marker 记录归属，必须用自定义键（如 `data.owner`）显式写入；引用 marker 自身的 `UUID` 只会得到 marker 自己的 UUID。`nbt={UUID:[I;a,b,c,d]}` 这种整数组形式的比较是有效的。
- **`by` 选择器解析为空时，整条 `/damage` 会被静默跳过**：表现为“特效与音效正常但零伤害”。排查时应单独验证选择器能否命中，而不是先怀疑伤害数值。
- **宏参数来源与执行者是两件事**：`execute as <实体> run function … with entity @s` 会把执行者一并切换，使函数内 `@s` 变成该实体。若函数里要用 `by @s` 表示“发射者”，必须保持发射者为执行者，只把另一个实体作为宏参数来源（先把所需字段读进 storage，再 `with storage` 调用）。雷枪曾因把爆心标记设为执行者，导致 `by @s` 指向标记、`positioned` 退化，爆炸特效与音效一并消失。
- **`/damage` 的归属与友军豁免都由命令与执行上下文承担**：
  - 以某玩家为执行者运行伤害函数时，`/damage` 会自动继承该执行者为伤害来源，击杀时能正常显示击杀者，不需要显式写 `by`；
  - 同队豁免是自动的：`/damage` 内部按队伍 `friendlyFire` 规则判定，同队成员天然不掉血，不需要 `team=!` 选择器；只有把发射者本人排除需要显式写（如雷枪的 `tag=!djzc.rocket_caster`）；
  - 反面情形：显式写 `damage … by <玩家>` 会额外触发一层友伤判定，实测对敌方玩家静默拦截伤害（表现为“只能炸到无阵营玩家”），应避免。
- **玩家数据里没有可读的名字字段**：`data modify … set from entity @s Name` 取不到值，需要标识玩家时用 `UUID`，并在选择器中以 `nbt={UUID:…}` / `nbt=!{UUID:…}` 使用。
- **`data modify storage <id> set value {…}` 语法不合法**：`data modify` 必须带路径，清空 storage 只能逐键穷举（如 `data modify storage djzc444:rocket x set value []`）。
- **`data merge storage` 不会清除旧键**：地图切换时，未被新地图配置覆盖的 `airport_*`、`tp_af*` 等键会保留上一张地图的值；需要清理时逐键 `data remove`。
- **宏函数缺少变量会整体失败**：`with storage` 调用时，函数正文引用的任一 `$(key)` 在 Storage 中不存在，整次调用报错且不执行。动态对话框因此依赖 `map_name`、`minute`、`second` 等键始终存在。
- 排查“赋值后读回为空”的问题时，注意目标路径往往在写入后又被后续清理指令覆盖；建议用**哨兵值**法判定一条 `data modify` 是否真的执行过。

## 8. 配套资源包接口

本节依据 `赛扬的冬季战场 v1.0.6 Ultimate` 资源包整理。资源包是客户端资源层，不提供数据包函数或 `trigger` 入口；其集成点是原版声音事件替换、音频文件和语言键。资源包元数据声明 `min_format` 与 `max_format` 均为 `75`，应以目标 Minecraft 客户端实际加载结果为准。

### 8.1 声音事件

注册表位于 `assets/minecraft/sounds.json`。其中的 `replace: true` 会替换同名原版声音事件，因此加载资源包不仅新增冬战音效，也会改变相应原版动作的声音。当前注册 30 个事件，引用 56 个 `djzc444` 音频文件，均有对应 OGG：

| 原版声音事件 | 资源包用途 |
| --- | --- |
| `item.goat_horn.sound.0` 至 `item.goat_horn.sound.7` | 进攻 A-D、防守 A-D 提示音，对应 `djzc444:points/atk_*`、`djzc444:points/dfd_*`。 |
| `entity.piglin.angry`、`jealous`、`ambient`、`admiring_item`、`celebrate`、`retreat`、`converted_to_zombified` | 步话机赞成、反对、冲锋、撤退、发现敌人、请求支援及掩护语音。 |
| `entity.cat.purreow` | Ciallo 语音。 |
| `entity.ender_dragon.growl`、`entity.player.levelup` | 分别播放敌方占点和己方占点提示。 |
| `entity.zombie.ambient` | 板载兵（BZB）语音。 |
| `entity.wither.death` | 对局失败提示音。 |
| `entity.piglin_brute.angry`、`entity.piglin_brute.death` | 最终进攻和最终抵抗语音。 |
| `block.anvil.land` | 航空兵 RWR 提示音、导弹扫描音，音量设为 `0.5`。 |
| `entity.enderman.teleport` | 立体机动/航空兵传送音效；`item.chorus_fruit.teleport` 转调到该事件。 |
| `music_disc.relic`、`music_disc.wait`、`music_disc.blocks`、`music.dragon` | 分别映射 CT 开场、T 开场、进攻曲和空战曲。 |
| `music.menu` | 主菜单音乐（*Deepseek V4.1 flash/CE_PT - 冬季战场*）。 |

`sounds.json` 中的音频标识使用 `djzc444:<相对路径>`，文件对应 `assets/djzc444/sounds/<相对路径>.ogg`。集成方若使用命令播放声音，应核对调用处使用的是原版事件 ID 还是资源音频 ID；声音配置本身并不定义数据包函数入口。字幕文本由对应声音条目的 `subtitle` 键提供。

### 8.2 翻译与显示文本

资源包提供四种语言：`en_us`、`zh_cn`、`zh_hk`、`zh_tw`。翻译分布在两个目录：

| 目录 | 用途 | 当前键数 |
| --- | --- | --- |
| `assets/djzc444/lang/` | 冬战自定义界面、物品/成就文本、死亡提示、步话机及占点字幕；包含资源包元数据描述键 `djzc.resourcepack.mcmeta.desc`。 | 619 |
| `assets/minecraft/lang/` | 覆盖原版死亡文本、旗帜图案名称和唱片曲目名称等 Minecraft 翻译键。 | 43 |

声音字幕会读取 `djzc.msg.*`、`djzc.type_bzb` 等键；元数据描述通过 `translate` 字段读取 `djzc.resourcepack.mcmeta.desc`，并以 `fallback` 文本作为回退。依赖这些文本的集成应保留键名及 `%1$s` 等格式占位符，四种语言文件也应同步维护。

### 8.3 加载与兼容约定

- 资源包和数据包职责不同：数据包负责游戏状态与触发逻辑，资源包提供客户端声音和文本。仅安装数据包时，相关逻辑仍可能运行，但自定义音频/翻译不完整。
- 同名声音事件采用整体替换而非叠加。若与其他资源包同时启用，优先级较高的 `sounds.json` 定义可能覆盖冬战映射；需在目标客户端检查实际生效结果。
- 资源包格式范围固定声明为 `75`。更新 Minecraft 或调整格式元数据后，应实际加载验证声音、字幕、唱片曲目和各语言文本。
- 当前清单中 56 个被引用的冬战 OGG 均有对应文件；新增或重命名资源时，须同步更新声音注册表并检查路径大小写和拼写。1.0.7 已将早期误拼的 `pionts` 路径修正为 `points`，旧文档中的 `pionts` 说明已失效。

## 9. 模块目录

| 目录 | 职责概览 |
| --- | --- |
| `advancement/` | 可见战绩、介绍成就与隐藏工具成就及相关检测 |
| `armor_ct/`、`armor_t/` | 两阵营护甲配置 |
| `buff/` | 增益效果及清理逻辑 |
| `ctmsg/`、`tmsg/` | 两阵营步话机消息处理 |
| `dialog/` | 对话框、菜单、动态界面和地图选择 |
| `game/` | 对局流程、输入分发、时钟、战斗与支援机制 |
| `option/` | 管理选项、阵营、统计、测试工具 |
| `points/` | A-D 战区、启动器、机场逻辑 |
| `support/` | 手动支援工具函数 |
| `tp/` | 传送目的地处理 |
| `type/` | 兵种选择、配装与兵种管理预设 |
| `weapon/` | 武器、装备和成书发放 |

数据驱动目录：

| 目录 | 职责概览 |
| --- | --- |
| `predicate/` | 位置、装备、按键、状态等谓词 |
| `damage_type/` | `missile`、`mine` 伤害类型 |
| `enchantment/` | `burstshot` 附魔 |
| `item_modifier/` | 轰炸指示器与雷枪的耐久修饰器 |
| `dialog/wiki/` | 百科页面静态对话框 |

其他命名空间承担扩展职责：

| 命名空间 | 已确认职责/调用 |
| --- | --- |
| `djzc444` | 主数据包：流程、占点、兵种、传送、对话框、武器、统计。 |
| `djzc555` | 即时射线检测；`djzc444:game/lib_boom_single` 调用 `raycast/ground`，`djzc444:game/lib_rocket_fire` 调用 `raycast/rocket`，`raycast/spawn_at_result` 生成落点标记。 |
| `djzc666` | 导弹武器、制导、近炸引信、扫描和导弹系统配置；`djzc444` 的机场、兵种和管理菜单会调用其函数。 |
| `djzc777` | 新手教程；`djzc777:open` 打开主页，`djzc777:tutorial/start` 和 `djzc777:tutorial/end` 控制实境教程开始与结束。 |
| `djzc888` | 地图系统；`djzc888:map_swich` 按 `djzc.map` 选择 `dz_djzc` 或 `jc_basic`，其 `main.mcfunction` 把 A/B/C/D 点、启动器、机场和传送点写入 `storage djzc:map`；`djzc888:tick` 处理地图选择。 |

## 10. 调用示例

管理员在游戏命令环境中调用配置函数：

```mcfunction
function djzc444:option/boost
```

玩家提交准备状态（需目标已启用）：

```mcfunction
trigger djzc.prepare set 1
```

玩家选择地图（需 `djzc.map` 目标已启用）：

```mcfunction
trigger djzc.map set 1
```

以玩家身份打开动态成员用书：

```mcfunction
function djzc444:dialog/user_dialog
```

打开新手教程主页：

```mcfunction
function djzc777:open
```

开始一局（会改变全局状态，仅建议管理员使用）：

```mcfunction
function djzc444:game/start
```

## 11. 兼容性与安全注意事项

- 当前 `pack.mcmeta` 声明支持的数据包格式范围为 `94.1` 至 `101.1`。实际兼容性仍须在目标 Minecraft 版本中验证。
- **地图切换会保留旧键**：`data merge storage djzc:map` 只覆盖写入的键；从 `dz_djzc` 切到 `jc_basic` 后，旧地图的机场和空中出生点字段仍可能存在。
- **部分坐标仍硬编码**：`game/start` 把 CT/T 传送到 `-405 30 -809` / `-397 30 -809`，`end_custom` 和 `load` 使用 `-434 41 -709`，`tutorial/end` 也使用上述两组坐标。这些坐标属于 `dz_djzc` / `jc_basic` 起始区域，新增地图前必须迁移。
- **`game/start` 的流程复位顺序**：`start` 先调用 `flow_begin`，之后才把 A/B/C/D 等流程分值清零。因此 `flow_begin` 调用的地图 `unique` 函数（例如 `dz_djzc/unique` 的开局填坑）读到的可能是上一局残留的流程值。
- `initialize`、对局开始/结束及 boost 配置等函数会产生明显副作用。将其开放给外部调用前，应明确所需权限和适用场景。
- `game/start` 会关闭命令方块输出、关闭 `mob_griefing`，并重置大量计分板、BossBar、展示框和启动器状态；不要在非对局管理场景中随意调用。
- `dz_djzc/unique.mcfunction` 保留命令方块时代彩蛋：它会根据 A/B/C/D 流程值在固定坐标放置或清除红石块，并在开局/结束阶段填平或打开 D 点大坑。迁移地图时需要保留或重写这些地图特有行为。
- 管理菜单的 `djzc.option=17` 分发没有 OP 校验；`select_opbook` 只限制右键展示入口，不能阻止玩家直接提交 trigger。
- 本文不构成版本兼容承诺。若修改 trigger 编号、计分板、Storage 键、对话框 ID 或函数副作用，应同步更新接口文档。

## 12. 后续维护清单

- [ ] 为 `djzc.map` 增加默认值，或在 `game/start` 前校验 `storage djzc:map map_data` 是否存在；避免全新存档无法开局。
- [ ] 修正 `djzc888:game_map_selection` 中 `scoreboard players reset @s djzc.map` 的上下文，使地图选择成为一次性请求，避免每 tick 重复加载地图。
- [ ] 在切换地图时清理 `storage djzc:map` 中未被新地图覆盖的旧键（机场、空中出生点等）。
- [ ] 将 `game/start`、`end_custom`、`tutorial/start`、`tutorial/end` 的固定坐标迁移到地图元数据或地图 `unique` 函数。
- [ ] 调整 `game/start` 的流程分值复位顺序，确保 `flow_begin` / 地图 `unique` 读到干净的开局状态。
- [ ] 核对 `jc_basic` 的 D 点 `glass_x/glass_y/glass_z`，当前值与 `dz_djzc` 相同。
- [ ] 核对 `djzc444:damage_half` / `damage_ltjd` 的 `set_damage` 负值方向：`add: true` 下负值通常表示修复而非扣耐久，而 `lib_boom_marker` / `lib_rocket_ltjd` 按“扣耐久”使用这两个修饰器。
- [ ] 为管理菜单 `djzc.option=17` 增加或验证 OP 权限校验；当前通用分发路径未见该检查。
- [ ] 逐项登记跨命名空间函数、Storage 键、实体标签、谓词和地图依赖。
- [ ] 在目标 Minecraft 版本中验证传送、兵种限制、地图切换和管理菜单权限行为。
- [ ] 为需要长期支持的外部调用定义稳定性等级及回归用例。

## 13. Git 提交与更新日志范式

### Git Commit

| 版本名 | 命名格式 | 例 |
| --- | --- | --- |
| 如果想得出名字就写 | `<版本>[+<主题>+<标记（可选）>] for <MC版本>` | `1.0.6+blockentity hotfix for 1.21.11` |
| 如果想不出名字，只写日期就行 | `### <版本>-<日期>-by-<第一作者>/<第N作者> start:<开始日期> end:<结束日期>` | `### 1.0.7 1108-by-CE_PT start:2026/11/05 end:2026/11/07` |

### CHANGELOG

- **文件名**：当前更新日志文件为 `CHANGELOG.md`；README 已改为引用此名称。维护时应保持 README 与实际文件名一致。
- **标题层级**：用版本号和代号标明发布线，用 `start`、测试和 `release` 日期记录进度；再按主题使用 `####` 标题分类，例如“游戏逻辑优化”“数据包结构优化”“BUG 修复”和“多语言支持”。
- **条目句式**：开头用动作词，说明改动对象和结果。功能调整常用“增加”“移除”“将……改为……”或“从……调整为……”；问题修复则说明原因和具体问题，避免只写“已优化”或“已修复”。
- **信息组织**：每条项目符号记录一项可核实的变化。若一项改动包含多个结果，可用缩进子项展开。测试报告、阶段记录和正式版本变更应分开，并按主题归类，不要直接照抄 commit 列表。
- **格式与语气**：以中文为主，表达直接、具体，可保留适度口语。重点对象和功能名可加粗；命令、文件名、组件名和字段名用反引号。格式应便于阅读和检索，避免整句加粗或用夸张措辞代替实际结果。
- **推荐模板**：功能调整可写为 `- 将<对象>从<原行为>调整为<新行为>，<条件或结果>`；问题修复可写为 `- 修复了<场景>下因<原因>导致的<具体问题>`。涉及多个结果或复杂条件时，再补充缩进子项。