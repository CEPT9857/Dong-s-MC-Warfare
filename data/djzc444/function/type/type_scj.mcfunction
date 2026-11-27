clear @s
#清理物品，防止出错
execute as @s run function djzc444:type/suit/suit_scj
#发白板盔甲
give @s minecraft:chorus_fruit 16
give @s minecraft:golden_apple 32
function djzc444:weapon/trident_yh
give @s minecraft:ender_pearl[custom_name={translate:"djzc.type_scj.ender_pearl",fallback:"%1$s",with:[{translate:"item.minecraft.ender_pearl"}]}] 16
function djzc444:weapon/trident_yzxf
give @s minecraft:potion[potion_contents={potion:strong_strength}] 4

function djzc444:tag_clear
tag @s add GF
tag @s add scj
#tag相关操作

#发完装备、tag 就位后立刻同步一次，不等下一秒；second 仍在兜底
function djzc444:game/lib_armor_sync