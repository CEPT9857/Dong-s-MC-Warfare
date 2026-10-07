#单次雷枪发射（由 lib_rocket_ltjd 调用）
#@s = 执行右键的玩家
#处理：分数重置 → 射线检测 → 生成爆心标记 → 立即爆炸

#重置右键分数
scoreboard players set @s djzc.r_click6 0

#执行射线检测并在落点引爆
function djzc444:game/lib_rocket_fire

#扣掉雷枪耐久（满16发即耗尽，debug模式不扣）
execute unless score debug djzc.option matches 1 run item modify entity @s weapon.mainhand djzc444:damage_ltjd
execute unless score debug djzc.option matches 1 run item modify entity @s weapon.offhand djzc444:damage_ltjd