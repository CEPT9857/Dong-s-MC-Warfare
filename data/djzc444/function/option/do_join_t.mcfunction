scoreboard players reset @s djzc.option
team join T
tellraw @s {translate:"djzc.msg.join_t",fallback:"您已加入T"}
#换队后立刻同步一次纹饰和盾牌，不等下一秒；second 仍在兜底
function djzc444:game/lib_armor_sync