execute unless entity @s[team=T] unless entity @s[team=CT] run tellraw @s {"translate":"djzc777.tutorial.end.no_team","fallback":"请先选择阵营，再结束新手教程。","color":"red"}
execute if entity @s[team=T] run scoreboard players set @s djzc777.tutorial -1
execute if entity @s[team=CT] run scoreboard players set @s djzc777.tutorial -1
execute if entity @s[team=T] run spawnpoint @s -397 30 -809
execute if entity @s[team=CT] run spawnpoint @s -405 30 -809
execute if entity @s[team=T] run tp @s -397 30 -809
execute if entity @s[team=CT] run tp @s -405 30 -809
execute if entity @s[team=T] run tellraw @s {"translate":"djzc777.tutorial.end.complete","fallback":"加油，特种兵！","color":"gold"}
execute if entity @s[team=CT] run tellraw @s {"translate":"djzc777.tutorial.end.complete","fallback":"加油，特种兵！","color":"gold"}