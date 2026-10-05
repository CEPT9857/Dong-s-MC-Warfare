#目前没做反占机制，仅供未来参考
$setblock $(glass_x) $(glass_y) $(glass_z) minecraft:blue_stained_glass
#更改点位颜色
$scoreboard players set $(NAME) djzc.gameflow 0
#修改此处游戏流程计算器为0
execute as @a[team=CT] at @s run playsound entity.player.levelup music @s
execute as @a[team=T] at @s run playsound entity.ender_dragon.growl music @s
#音效
$scoreboard players set T_S$(NAME) djzc.time3 60
$execute as @a[x=$(x),y=$(y),z=$(z),dx=$(dx),dy=$(dy),dz=$(dz),team=T] at @s run scoreboard players add @s djzc.occupy 1

function djzc444:game/game_flow
#运行游戏流程计算器

$tellraw @a {translate:"djzc.msg.$(name)_occupy_by_ct",fallback:"$(NAME)点已被CT阵营占领!",color:"green"}
#友情提示

$bossbar set djzc_point:$(name) visible false
#关闭bossbar

#A点：setblock -395 27 -768 minecraft:air
#B点：setblock -398 27 -768 minecraft:air
#C点：setblock -395 27 -754 minecraft:air
#D点：setblock -398 27 -754 minecraft:air
#拟加入彩蛋：如果在地图map_djzc中，通过清除红石块联动地图，暂不处理