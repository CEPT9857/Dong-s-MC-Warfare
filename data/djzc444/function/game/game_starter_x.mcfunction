#大写C/D表示是否被占领，小写c/d表示旋转角度
$execute store result score $(name) djzc.gameflow run data get entity @e[x=$(x),y=$(y),z=$(z),limit=1,type=minecraft:glow_item_frame,distance=..1.5] ItemRotation
$execute if score $(name) djzc.gameflow matches 7 run function djzc444:points/starter_x with storage djzc:map $(name)
#自动修复物品展示框
$execute positioned $(x) $(y) $(z) unless entity @e[x=$(x),y=$(y),z=$(z),limit=1,type=minecraft:glow_item_frame,distance=..1.5] run summon minecraft:glow_item_frame ~ ~ ~ {Facing:$(frame_facing),Item:{id:"minecraft:glow_item_frame"},Invulnerable:1b}