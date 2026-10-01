execute if score game djzc.gameflow matches 1 run tellraw @s {"translate":"djzc777.tutorial.start.denied","fallback":"对局进行中，暂时不能进入新手教程。","color":"red"}
execute unless score game djzc.gameflow matches 1 run team join T
execute unless score game djzc.gameflow matches 1 run scoreboard players set @s djzc777.tutorial 1
execute unless score game djzc.gameflow matches 1 run spawnpoint @s -360 20 -745
execute unless score game djzc.gameflow matches 1 run tp @s -360 20 -745
execute unless score game djzc.gameflow matches 1 run function djzc444:type/type_fkb
execute unless score game djzc.gameflow matches 1 run title @s actionbar {"translate":"djzc777.tutorial.start.actionbar","fallback":"沿着光柱前进","color":"gold"}