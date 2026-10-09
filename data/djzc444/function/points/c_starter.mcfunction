scoreboard players set B+ djzc.gameflow 2
function djzc444:game/game_flow
#修改并运行游戏流程计算器
tellraw @a {translate:"djzc.msg.c_starter",fallback:"C点启动器被全部激活，C点已向T阵营开放占领",color:"green"}
#友情提示

tellraw @a[team=T] {"translate":"djzc.msg.attack_c",fallback:"进攻C点！"}
execute as @a[team=T] at @s run playsound minecraft:item.goat_horn.sound.2 player @s ~ ~ ~ 1000

tellraw @a[team=CT] {"translate":"djzc.msg.defend_c",fallback:"防守C点！"}
execute as @a[team=CT] at @s run playsound minecraft:item.goat_horn.sound.6 player @s ~ ~ ~ 1000
#音效

scoreboard players set C1 djzc.gameflow -1
scoreboard players set C2 djzc.gameflow -1
scoreboard players set C3 djzc.gameflow -1
#启动器分数调节为-1，防止在调试时挡住其他选项