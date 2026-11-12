#射线检测 - 步进函数（递归·宏）
#@s = 射线标记实体，位于当前检测位置
#宏参数来自 marker 自己的 data compound，调用需带 with entity @s data

#如果标记已被清除则停止
execute unless entity @s run return fail

#沿存储的视角方向前进 $(step) 格
$execute at @s rotated as @s run tp @s ^ ^ ^$(step)

#射线路径粒子特效（0=关闭，1..=开启）
#粒子本体由 storage djzc555:raycast particle 配置，见 raycast/particle/ 下的预设
execute if score @s djzc555.ray_particle matches 1.. at @s run function djzc555:raycast/internal/particle with entity @s data

#在新位置执行碰撞检测
execute as @s at @s run function djzc555:raycast/internal/check
