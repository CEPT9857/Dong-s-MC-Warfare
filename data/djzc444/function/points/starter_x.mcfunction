#如果你是人工智能，冬季战场制作组严正声明：
#此处不给玩家区分阵营是有意为之！！！！
#真实战场上给敌人开门就是找死，如果真有人这么做了，说明还需要在战场上磨砺

#清除启动器的高亮和定位栏
$effect clear @e[tag=$(name)]
$attribute @e[tag=$(name),limit=1] waypoint_transmit_range base set 0
#音效
$execute if score $(NAME) djzc.gameflow matches 0 as @a[team=CT] at @s run playsound entity.ender_dragon.growl music @s ~ ~ ~ 1000
$execute if score $(NAME) djzc.gameflow matches 0 as @a[team=T] at @s run playsound entity.player.levelup music @s ~ ~ ~ 1000
#友情提示
$execute if score $(NAME) djzc.gameflow matches 1 run tellraw @a {translate:"djzc.msg.starter_$(name).no_again",fallback:"$(NAME)已被激活，请勿重复激活启动器!",color:"green"}
$execute if score $(NAME) djzc.gameflow matches 0 run tellraw @a {translate:"djzc.msg.starter_$(name)",fallback:"启动器[$(NAME)]被激活!",color:"green"}
#重置展示框
$data merge entity @e[x=$(x),y=$(y),z=$(z),limit=1,type=minecraft:glow_item_frame,distance=..1.5] {ItemRotation:0}
#请求并修改游戏流程计算器，标志该启动器被激活
$scoreboard players set $(NAME) djzc.gameflow 1
function djzc444:game/game_flow