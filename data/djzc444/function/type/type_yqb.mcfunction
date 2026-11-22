clear @s
#清理物品，防止出错
execute as @s run function djzc444:type/suit/suit_yqb
#发白板盔甲
give @s minecraft:golden_apple 32
function djzc444:weapon/spear_yqb
function djzc444:weapon/wea_frag_fly
function djzc444:weapon/wea_light_pistol
function djzc444:weapon/rocket_jjs
give @s tipped_arrow[potion_contents={potion:strong_harming}] 96
give @s minecraft:arrow 128
function djzc444:tag_clear
tag @s add GF
tag @s add yqb
#tag相关操作

#发完装备、tag 就位后立刻同步一次，不等下一秒；second 仍在兜底
function djzc444:game/lib_armor_sync