#地图特殊事件
$function djzc888:$(name)/unique

scoreboard players set C+ djzc.gameflow 2
function djzc444:game/game_flow with storage djzc:map map_data
#修改并运行游戏流程计算器
tellraw @a {translate:"djzc.msg.d_starter",fallback:"D点启动器被全部激活，D点已向T阵营开放占领",color:"green"}
#友情提示

tellraw @a[team=T] {"translate":"djzc.msg.attack_d",fallback:"进攻D点！"}
execute as @a[team=T] at @s run playsound minecraft:item.goat_horn.sound.3 player @s ~ ~ ~ 1000

tellraw @a[team=CT] {"translate":"djzc.msg.defend_d",fallback:"防守D点！"}
execute as @a[team=CT] at @s run playsound minecraft:item.goat_horn.sound.7 player @s ~ ~ ~ 1000
#音效

scoreboard players set D1 djzc.gameflow -1
scoreboard players set D2 djzc.gameflow -1
scoreboard players set D3 djzc.gameflow -1
#启动器分数调节为-1，防止在调试时挡住其他选项