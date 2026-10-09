title @a title [{translate:"djzc.msg.begin",fallback:"冬季战场初始化","color":"aqua"}]
title @a subtitle [{translate:"djzc.msg.begin.desc",fallback:"加油，特种兵","color":"dark_aqua"}]
#修改游戏流程计算器，提示游戏开始
scoreboard players set game djzc.gameflow 1
#占戈哥欠走己！
execute as @a[team=T] at @s run playsound minecraft:music_disc.wait music @s ~ ~ ~ 1000
execute as @a[team=CT] at @s run playsound minecraft:music_disc.relic music @s ~ ~ ~ 100