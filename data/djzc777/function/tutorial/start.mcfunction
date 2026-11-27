#保护措施，防止BUG
scoreboard players reset @s djzc.option
scoreboard players set d_tip djzc.time2 0
execute if score game djzc.gameflow matches 1 as @s run return run function djzc777:tutorial/option/start_return
#修改地图到新手教程
scoreboard players set map djzc.map 2
function djzc888:map_swich
#加入T方
execute as @s run team join T
#记录为阶段1，清除A/B页已看标记，允许重播时再次触发
execute as @s run scoreboard players set @s djzc.tutorial 1
tag @s remove tutorial_a_seen
tag @s remove tutorial_b_seen
#发放装备
execute as @s run function djzc444:type/type_fkb
#冬战，启动！
function djzc444:game/start
#设定重生点，并传送到起始点
execute as @s run spawnpoint @s -434 41 -709 -505 0
execute as @s run tp @s -434 41 -709 -505 0