#射线检测 - 启动器
#@s = 施法者实体（玩家）
#在施法者眼部生成射线标记实体并开始步进
#步长、sleep、粒子参数写进 marker 自己的 data compound，用 with entity @s data 传宏
#sleep=0 走单 tick 同步递归，sleep>0 交给 tick.json 里的 djzc555:tick

#给施法者打标签
tag @s add djzc555.ray_caster

#默认参数（未设置才补，外部设的值不会被覆盖）
execute unless score @s djzc555.ray_max matches 1.. run scoreboard players set @s djzc555.ray_max 500
execute unless score @s djzc555.ray_step matches 1.. run scoreboard players set @s djzc555.ray_step 1
execute unless score @s djzc555.ray_sleep matches 0.. run scoreboard players set @s djzc555.ray_sleep 0
execute unless score @s djzc555.ray_particle matches 0.. run scoreboard players set @s djzc555.ray_particle 0
execute unless score @s djzc555.ray_keep matches 0.. run scoreboard players set @s djzc555.ray_keep 0

#分配唯一ID，用于多人并存时关联施法者与标记
scoreboard players add #uid djzc555.ray_uid 1
scoreboard players operation @s djzc555.ray_uid = #uid djzc555.ray_uid

#在施法者眼部位置生成标记实体，data 里放宏参数
execute anchored eyes positioned ^ ^ ^ run summon minecraft:marker ^ ^ ^ {Tags:["djzc555.ray_marker","djzc555.ray_live"],data:{step:1.0,id:"minecraft:end_rod",delta:"0 0.1 0",speed:"1",count:"0",mode:"force",viewers:"@a"}}

#复制施法者视角方向到标记实体
data modify entity @e[tag=djzc555.ray_live,limit=1] Rotation set from entity @s Rotation

#复制参数到标记实体
scoreboard players operation @e[tag=djzc555.ray_live,limit=1] djzc555.ray_max = @s djzc555.ray_max
scoreboard players operation @e[tag=djzc555.ray_live,limit=1] djzc555.ray_type = @s djzc555.ray_type
scoreboard players operation @e[tag=djzc555.ray_live,limit=1] djzc555.ray_step = @s djzc555.ray_step
scoreboard players operation @e[tag=djzc555.ray_live,limit=1] djzc555.ray_sleep = @s djzc555.ray_sleep
scoreboard players operation @e[tag=djzc555.ray_live,limit=1] djzc555.ray_particle = @s djzc555.ray_particle
scoreboard players operation @e[tag=djzc555.ray_live,limit=1] djzc555.ray_keep = @s djzc555.ray_keep
scoreboard players operation @e[tag=djzc555.ray_live,limit=1] djzc555.ray_uid = @s djzc555.ray_uid
scoreboard players set @e[tag=djzc555.ray_live,limit=1] djzc555.ray_dist 0
scoreboard players set @e[tag=djzc555.ray_live,limit=1] djzc555.ray_timer 0

#步长 ×0.1 写进 marker NBT，step 宏变量从这里取
execute store result entity @e[tag=djzc555.ray_live,limit=1] data.step double 0.1 run scoreboard players get @s djzc555.ray_step

#粒子参数整段从 storage 复制到 marker，id 等宏变量从这里取
data modify entity @e[tag=djzc555.ray_live,limit=1] data.id set from storage djzc555:raycast particle.id
data modify entity @e[tag=djzc555.ray_live,limit=1] data.delta set from storage djzc555:raycast particle.delta
data modify entity @e[tag=djzc555.ray_live,limit=1] data.speed set from storage djzc555:raycast particle.speed
data modify entity @e[tag=djzc555.ray_live,limit=1] data.count set from storage djzc555:raycast particle.count
data modify entity @e[tag=djzc555.ray_live,limit=1] data.mode set from storage djzc555:raycast particle.mode
data modify entity @e[tag=djzc555.ray_live,limit=1] data.viewers set from storage djzc555:raycast particle.viewers

#sleep>0 打异步标签交给 tick，sleep=0 当场跑完整条递归
execute if score @s djzc555.ray_sleep matches 1.. run tag @e[tag=djzc555.ray_live,limit=1] add djzc555.ray_async
execute if score @s djzc555.ray_sleep matches 0 as @e[tag=djzc555.ray_live,limit=1] at @s run function djzc555:raycast/internal/step with entity @s data

#清除临时标签
tag @e[tag=djzc555.ray_live] remove djzc555.ray_live
