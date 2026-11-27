#防止有人在对局进行时试图进入新手教程后，因为trigger没有清空而刷屏
scoreboard players reset @s djzc.option
execute if score @s djzc.option matches 106 run tellraw @s {"translate":"djzc777.tutorial.start.denied","fallback":"对局进行中，暂时不能进入新手教程。","color":"red"}