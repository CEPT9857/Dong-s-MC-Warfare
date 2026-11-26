clear @s
#清理物品，防止出错
function djzc444:weapon/elytra_bzb
function djzc666:weapon/missile_aa
function djzc444:weapon/rocket_bzb
function djzc444:weapon/rocket_10

function djzc444:tag_clear
tag @s add AF
tag @s add bzb
#tag相关操作

advancement grant @s only djzc444:fight/wea_bzb
function djzc444:game/music_af
playsound minecraft:entity.zombie.ambient player @a ~ ~ ~ 1000
#一阵强劲的音乐响起

#发完装备、tag 就位后立刻同步一次，不等下一秒；second 仍在兜底
function djzc444:game/lib_armor_sync