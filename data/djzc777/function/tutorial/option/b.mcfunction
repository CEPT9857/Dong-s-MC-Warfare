#101 一键占领B点
#地图ID检测，防止玩家在正常游戏中使用该工具，下一级函数自动清trigger，不会有BUG
execute unless score map djzc.map matches 2 as @s run return run function djzc444:option/no_clever
scoreboard players reset @s djzc.option
scoreboard players set T_SB djzc.time3 0
function djzc777:tutorial/advance
