# 换队 / 发装备 / 切和谐模式时主动请求一次，second 每秒再兜一次底
# armor_team：1=CT，2=T，0/无分数=还没同步过
execute as @a[team=CT] unless score @s djzc444.armor_team matches 1 run function djzc444:game/lib_armor_sync/ct
execute as @a[team=T] unless score @s djzc444.armor_team matches 2 run function djzc444:game/lib_armor_sync/t

# 新发的白板（quartz）也要触发一次，队伍没变但材料还是白的
# 装备四个槽和背包都看一眼，主动请求时当场换色，没请求时最多等一秒
execute as @a[team=CT] if items entity @s armor.* *[minecraft:trim={material:"minecraft:quartz",pattern:"minecraft:wild"}] run function djzc444:game/lib_armor_sync/ct
execute as @a[team=T] if items entity @s armor.* *[minecraft:trim={material:"minecraft:quartz",pattern:"minecraft:wild"}] run function djzc444:game/lib_armor_sync/t
execute as @a[team=CT] if items entity @s container.* *[minecraft:trim={material:"minecraft:quartz",pattern:"minecraft:wild"}] run function djzc444:game/lib_armor_sync/ct
execute as @a[team=T] if items entity @s container.* *[minecraft:trim={material:"minecraft:quartz",pattern:"minecraft:wild"}] run function djzc444:game/lib_armor_sync/t

# 盾牌：按和谐模式、队伍和 scj tag 换一次
execute as @a run function djzc444:game/lib_armor_sync/shield_one
