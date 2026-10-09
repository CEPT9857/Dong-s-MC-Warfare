$setblock $(glass_x) $(glass_y) $(glass_z) minecraft:red_stained_glass
#更改点位颜色
$scoreboard players set $(NAME) djzc.gameflow $(gameflow)
#修改游戏流程计算器
execute as @a[team=T] at @s run playsound entity.player.levelup music @s ~ ~ ~ 1000
execute as @a[team=CT] at @s run playsound entity.ender_dragon.growl music @s ~ ~ ~ 1000
#音效
$scoreboard players set T_S$(NAME) djzc.time3 60
$execute as @a[x=$(x),y=$(y),z=$(z),dx=$(dx),dy=$(dy),dz=$(dz),team=T] at @s run scoreboard players add @s djzc.occupy 1

function djzc444:game/game_flow
#运行游戏流程计算器

$tellraw @a {translate:"djzc.msg.$(name)_occupy_by_t",fallback:"$(NAME)点已被T阵营占领!",color:"green"}
#友情提示

$bossbar set djzc_point:$(name) visible false
#关闭bossbar