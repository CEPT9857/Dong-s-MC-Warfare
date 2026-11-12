#射线检测系统 - 每 tick 驱动 sleep 模式的射线
#sleep=0 的射线不带 ray_async 标签，不会被这里碰到
execute as @e[tag=djzc555.ray_marker,tag=djzc555.ray_async] at @s run function djzc555:raycast/internal/tick_one
