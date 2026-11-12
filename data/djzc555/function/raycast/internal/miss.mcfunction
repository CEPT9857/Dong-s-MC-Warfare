#射线检测 - 未命中处理
#@s = 射线标记实体，已达到最大距离
#将未命中结果（含最终位置）写入 storage djzc555:raycast result

#写入未命中结果
data modify storage djzc555:raycast result set value {hit:0b}

#记录最终坐标（保留3位小数精度，用于轰炸等需要终点位置的场景）
execute store result storage djzc555:raycast result.x double 0.001 run data get entity @s Pos[0] 1000
execute store result storage djzc555:raycast result.y double 0.001 run data get entity @s Pos[1] 1000
execute store result storage djzc555:raycast result.z double 0.001 run data get entity @s Pos[2] 1000

#记录最大距离与步数
execute store result storage djzc555:raycast result.distance double 0.1 run scoreboard players get @s djzc555.ray_dist
execute store result storage djzc555:raycast result.steps int 1 run scoreboard players get @s djzc555.ray_dist
execute store result storage djzc555:raycast result.uid int 1 run scoreboard players get @s djzc555.ray_uid

#把结果复制进本条射线自己的 NBT，回调读副本，不受后续射线覆盖影响
data modify entity @s data.result set from storage djzc555:raycast result

#按 uid 分槽，ray_keep=1 时启用，供跨 tick 或事后查询
execute if score @s djzc555.ray_keep matches 1.. store result storage djzc555:raycast tmp.uid int 1 run scoreboard players get @s djzc555.ray_uid
execute if score @s djzc555.ray_keep matches 1.. run function djzc555:raycast/internal/store_result with storage djzc555:raycast tmp

#结果回调，sleep 模式的后续逻辑挂在这里，参数是本条自己的 result 副本
function djzc555:raycast/internal/on_result with entity @s data.result

#按 UID 移除本条射线施法者的标签
execute as @a[tag=djzc555.ray_caster] if score @s djzc555.ray_uid = @e[tag=djzc555.ray_marker,limit=1,sort=nearest] djzc555.ray_uid run tag @s remove djzc555.ray_caster

#清理：清除射线标记实体
kill @s
