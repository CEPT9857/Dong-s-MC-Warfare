# T：白板（quartz）和 CT 的青金石材料都改成红石，全身槽位都扫
data modify storage djzc444:armor_sync filter set value '*[minecraft:trim={material:"minecraft:quartz",pattern:"minecraft:wild"}]'
data modify storage djzc444:armor_sync modifier set value "djzc444:armor_t_trim"
function djzc444:game/lib_armor_sync/all_of_player with storage djzc444:armor_sync

data modify storage djzc444:armor_sync filter set value '*[minecraft:trim={material:"minecraft:lapis",pattern:"minecraft:wild"}]'
function djzc444:game/lib_armor_sync/all_of_player with storage djzc444:armor_sync

scoreboard players set @s djzc444.armor_team 2
