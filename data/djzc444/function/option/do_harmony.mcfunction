#和谐冬战
scoreboard players set harmony djzc.option 1
#换掉旗子
data remove block -396 31 -807 patterns
data remove block -406 31 -807 patterns

#和谐模式改了盾牌目标，立刻同步一次，不等下一秒；second 仍在兜底
function djzc444:game/lib_armor_sync