title @p title [{translate:"djzc.msg.failed_t",fallback:"T阵营战败","color":"red"}]
scoreboard players add @a[team=T] djzc.fight_lost 1

title @a[team=CT] title [{"translate":"djzc.msg.win_ct",fallback:"CT阵营胜利","color":"blue"}]
scoreboard players add @a[team=CT] djzc.fight_win 1

tellraw @a {translate:"djzc.msg.win_ct.desc",fallback:"T阵营未能占领所有战区，CT阵营胜利",color:"green"}
#友情提示

bossbar set djzc_game:time visible false

stopsound @a
execute as @a[team=T] at @s run playsound minecraft:entity.wither.death player @s ~ ~ ~ 1000
execute as @a[team=CT] at @s run playsound entity.ender_dragon.death player @s ~ ~ ~ 1000
#CT胜利

function djzc444:game/end_custom