stopsound @a
execute as @a at @s run playsound minecraft:music_disc.blocks music @s ~ ~ ~ 1000
#友情提示
title @a[team=T] title [{translate:"djzc.msg.c_d.t",fallback:"进攻D点启动器","color":"dark_aqua"}]
title @a[team=CT] title [{translate:"djzc.msg.c_d.ct",fallback:"防守D点启动器","color":"dark_aqua"}]
tellraw @a {translate:"djzc.msg.c_d.desc",fallback:"D点启动器的位置已被高亮，旋转物品展示框会激活启动器。若启动器被全部激活，D点就可以被T阵营占领",color:"green"}
title @a subtitle [{translate:"djzc.msg.c_d",fallback:"C点已被T方占领","color":"red"}]
#高亮启动器旁的盔甲架
execute as @e[tag=d1] run function djzc444:game/game_starter_display
execute as @e[tag=d2] run function djzc444:game/game_starter_display
execute as @e[tag=d3] run function djzc444:game/game_starter_display
#音效
execute as @a[team=T] at @s run playsound minecraft:entity.piglin_brute.angry player @s ~ ~ ~ 1000
execute as @a[team=CT] at @s run playsound minecraft:entity.piglin_brute.death player @s ~ ~ ~ 100