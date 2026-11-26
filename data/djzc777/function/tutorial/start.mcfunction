#保护措施，防止BUG
execute if score game djzc.gameflow matches 1 run return run tellraw @s {"translate":"djzc777.tutorial.start.denied","fallback":"对局进行中，暂时不能进入新手教程。","color":"red"}
#修改地图到新手教程
scoreboard players set map djzc.map 2
function djzc888:map_swich
#冬战，启动！
function djzc444:game/start
#加入T方
execute as @s run team join T
#记录为阶段1
execute as @s run scoreboard players set @s djzc.tutorial 1
#设定重生点，并传送到起始点
execute as @s run spawnpoint @s -434 41 -709 -505 0
execute as @s run tp @s -434 41 -709 -505 0
#发放装备
execute as @s run function djzc444:type/type_fkb