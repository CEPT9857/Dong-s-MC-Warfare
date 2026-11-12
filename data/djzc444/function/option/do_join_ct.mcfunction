scoreboard players reset @s djzc.option
team join CT
tellraw @s {translate:"djzc.msg.join_ct",fallback:"您已加入CT"}
#换队后立刻同步一次纹饰和盾牌，不等下一秒；second 仍在兜底
function djzc444:game/lib_armor_sync