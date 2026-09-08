scoreboard players set A+B djzc.gameflow 0
stopsound @a
scoreboard players set A djzc.gameflow -1
scoreboard players set B djzc.gameflow -1
scoreboard players set B+ djzc.gameflow 1

title @a subtitle [{translate:"djzc.msg.a_b",fallback:"A点和B点已被T方占领","color":"red"}]
title @a[team=T] title [{translate:"djzc.msg.a_b.t",fallback:"进攻C点启动器","color":"dark_aqua"}]
title @a[team=CT] title [{translate:"djzc.msg.a_b.ct",fallback:"防守C点启动器","color":"dark_aqua"}]
tellraw @a {translate:"djzc.msg.a_b.desc",fallback:"C点启动器的位置已被高亮，旋转物品展示框会激活启动器。若启动器被全部激活，C点就可以被T阵营占领",color:"green"}
#友情提示

execute as @e[tag=c1] run function djzc444:game/game_starter_display
execute as @e[tag=c2] run function djzc444:game/game_starter_display
execute as @e[tag=c3] run function djzc444:game/game_starter_display
#高亮启动器旁的盔甲架

playsound minecraft:entity.piglin_brute.death player @a[team=CT] -386.00 70.39 -755.52 1000
playsound minecraft:entity.piglin_brute.angry player @a[team=T] -386.00 70.39 -755.52 1000
playsound minecraft:music_disc.pigstep music @a -386.00 70.39 -755.52 1000
