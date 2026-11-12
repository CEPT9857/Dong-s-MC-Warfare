clear @s
#清理物品，防止出错
execute as @s[team=CT] run function djzc444:type/suit/suit_jjs
execute as @s[team=T] run function djzc444:type/suit/suit_jjs
#分阵营发盔甲
function djzc444:weapon/wea_heavy_gun
give @s minecraft:golden_apple 32
function djzc444:weapon/wea_light_pistol
give @s minecraft:chorus_fruit 32
give @s minecraft:ender_pearl 16
give @s minecraft:tipped_arrow[potion_contents={potion:strong_harming}] 192
function djzc444:weapon/wea_frag_fly
function djzc444:weapon/rocket_jjs

function djzc444:tag_clear
tag @s add GF
tag @s add jjs
#tag相关操作

#发完装备、tag 就位后立刻同步一次，不等下一秒；second 仍在兜底
function djzc444:game/lib_armor_sync