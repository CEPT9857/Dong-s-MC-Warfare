#保护措施，防止BUG
execute if score game djzc.gameflow matches 1 run tellraw @s {"translate":"djzc777.tutorial.start.denied","fallback":"对局进行中，暂时不能进入新手教程。","color":"red"}
#加入T方
execute unless score game djzc.gameflow matches 1 run team join T
#记录为阶段1
execute unless score game djzc.gameflow matches 1 run scoreboard players set @s djzc.tutorial 1
#设定重生点，并传送到起始点
execute unless score game djzc.gameflow matches 1 run spawnpoint @s -434 41 -709 -505 0
execute unless score game djzc.gameflow matches 1 run tp @s -434 41 -709 -505 0
#发放装备
execute unless score game djzc.gameflow matches 1 run function djzc444:type/type_fkb