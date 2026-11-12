#不和谐冬战
scoreboard players set harmony djzc.option 0
#换掉旗子
data merge block -396 31 -807 {patterns:[{pattern:"minecraft:globe",color:"yellow"}]}
data merge block -406 31 -807 {patterns:[{pattern:"minecraft:flower",color:"white"}]}

#和谐模式改了盾牌目标，立刻同步一次，不等下一秒；second 仍在兜底
function djzc444:game/lib_armor_sync