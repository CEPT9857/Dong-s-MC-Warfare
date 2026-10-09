title @a[team=CT] title [{translate:"djzc.msg.failed_ct",fallback:"CT阵营战败","color":"red"}]
scoreboard players add @a[team=CT] djzc.fight_lost 1

title @a[team=T] title [{translate:"djzc.msg.win_t",fallback:"T阵营胜利","color":"blue"}]
scoreboard players add @a[team=T] djzc.fight_win 1

tellraw @a {translate:"djzc.msg.win_t.desc",fallback:"T阵营占领了所有战区，T阵营胜利",color:"green"}
#友情提示

stopsound @a
execute as @a[team=T] at @s run playsound entity.ender_dragon.death player @s ~ ~ ~ 1000
execute as @a[team=CT] at @s run playsound minecraft:entity.wither.death player @s ~ ~ ~ 1000
#T胜利

function djzc444:game/end_custom