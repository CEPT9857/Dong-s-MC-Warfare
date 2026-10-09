#雷枪发射与落点处理（由 lib_rocket_single 调用）
#@s = 发射者（玩家），执行位置为发射者所在处
#流程：即时射线检测 → 召唤爆心标记 → 以发射者身份引爆 → 清理本次状态

#清理上一tick遗留的爆心标记（正常情况下不存在，作兜底）
kill @e[tag=ltjd_boom]

#执行基于djzc555的即时射线检测
execute at @s run function djzc555:raycast/rocket

#在射线检测命中/终点位置召唤爆心标记（标记只承载坐标，引爆时读出）
execute if data storage djzc555:raycast result.x run function djzc444:game/lib_rocket_spawn_mark with storage djzc555:raycast result

#以发射者身份引爆（爆心坐标由 lib_rocket_detonate 从标记读出并写入宏来源 storage）
execute if data storage djzc555:raycast result.x run function djzc444:game/lib_rocket_detonate

#清理爆心标记、射线结果与宏来源，避免遗留状态被下一次发射误用
kill @e[tag=ltjd_boom]
data modify storage djzc555:raycast result set value {}
data modify storage djzc444:rocket x set value {}
data modify storage djzc444:rocket y set value {}
data modify storage djzc444:rocket z set value {}
data modify storage djzc444:rocket caster set value {}