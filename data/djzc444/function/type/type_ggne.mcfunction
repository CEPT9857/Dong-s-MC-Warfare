clear @s
#清理物品，防止出错
execute as @s run function djzc444:type/suit/suit_ggne
#发白板盔甲
function djzc444:weapon/wea_cl
function djzc444:weapon/trident_ggne
function djzc666:weapon/missile_ga
give @s golden_carrot[custom_name={translate:"djzc.type_ggne.golden_carrot",fallback:"孩子，你无敌了"}] 32
advancement grant @s only djzc444:fight/wea_ggne

function djzc444:tag_clear
tag @s add GF
tag @s add ggne
#tag相关操作

#发完装备、tag 就位后立刻同步一次，不等下一秒；second 仍在兜底
function djzc444:game/lib_armor_sync