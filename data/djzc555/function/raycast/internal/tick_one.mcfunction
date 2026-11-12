#单条 sleep 射线的每 tick 计时器，@s = 射线标记实体
scoreboard players add @s djzc555.ray_timer 1
execute unless score @s djzc555.ray_timer >= @s djzc555.ray_sleep run return fail
scoreboard players set @s djzc555.ray_timer 0
function djzc555:raycast/internal/step with entity @s data
