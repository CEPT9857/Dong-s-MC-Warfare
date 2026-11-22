clear @s
#清理物品，防止出错
execute as @s run function djzc444:type/suit/suit_jzb
#发白板盔甲
function djzc444:weapon/wea_heavy_axe
function djzc444:weapon/wea_heavy_sword
give @s minecraft:golden_apple 32
function djzc444:weapon/wea_heavy_pistol
give @s minecraft:chorus_fruit 5
give @s minecraft:potion[potion_contents={potion:strong_strength}] 4
give @s minecraft:arrow 192
give @s minecraft:enchanted_golden_apple 5

function djzc444:tag_clear
tag @s add GF
tag @s add jzb
#tag相关操作

#发完装备、tag 就位后立刻同步一次，不等下一秒；second 仍在兜底
function djzc444:game/lib_armor_sync