gamerule command_block_output false
gamerule mob_griefing false
schedule clear djzc444:game/music_stop
stopsound @a
function djzc444:game/time_initialize
function djzc444:game/flow_begin

execute as @a[team=CT] run spawnpoint @s -405 30 -809
execute as @a[team=T] run spawnpoint @s -397 30 -809
#设定双方默认重生点为dz_djzc配装处

tp @a[team=CT] -405 30 -809
tp @a[team=T] -397 30 -809
#传送到dz_djzc配装处

bossbar set djzc_game:time visible true
bossbar set djzc_game:time value 900

fill -467 62 -764 -469 62 -758 netherite_block
#填平D点大坑

scoreboard players reset @a djzc.CT
scoreboard players reset @a djzc.T
scoreboard players reset @a djzc.occupy
scoreboard players reset @a djzc.count_die
scoreboard players reset @a djzc.count_kill
scoreboard players reset @a djzc.gameflow
scoreboard players reset @a djzc.type
#重置必要的计分板

gamemode adventure @a[team=T]
gamemode adventure @a[team=CT]

advancement grant @a only djzc444:fight/root

advancement revoke @a from djzc444:fight/count

function djzc444:points/x_point_reset with storage djzc:map a_point
function djzc444:points/x_point_reset with storage djzc:map b_point
function djzc444:points/x_point_reset with storage djzc:map c_point
function djzc444:points/x_point_reset with storage djzc:map d_point
#还原信标光柱为蓝色

scoreboard players set A djzc.gameflow 0
scoreboard players set B djzc.gameflow 0
scoreboard players set A+B djzc.gameflow 0
scoreboard players set B+ djzc.gameflow 0
scoreboard players set C djzc.gameflow 0
scoreboard players set C+ djzc.gameflow 0
scoreboard players set D djzc.gameflow 0
#还原四个点及启动器在游戏流程计算器的状态
scoreboard players set C1 djzc.gameflow 0
scoreboard players set C2 djzc.gameflow 0
scoreboard players set C3 djzc.gameflow 0
scoreboard players set C123 djzc.gameflow 0
scoreboard players set D1 djzc.gameflow 0
scoreboard players set D2 djzc.gameflow 0
scoreboard players set D3 djzc.gameflow 0
scoreboard players set D123 djzc.gameflow 0
#启动器在游戏流程计算器的状态
function djzc444:game/game_starter_reset with storage djzc:map c1
function djzc444:game/game_starter_reset with storage djzc:map c2
function djzc444:game/game_starter_reset with storage djzc:map c3
function djzc444:game/game_starter_reset with storage djzc:map d1
function djzc444:game/game_starter_reset with storage djzc:map d2
function djzc444:game/game_starter_reset with storage djzc:map d3
#重置启动器展示框

function djzc444:game/game_starter_nodisplay
#重置启动器盔甲架

scoreboard objectives setdisplay list djzc.count_kill
#将击杀数显示在玩家列表中

gamemode adventure @a[team=T]
gamemode adventure @a[team=CT]
#转为冒险模式