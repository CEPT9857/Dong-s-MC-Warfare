#射线检测系统 - 初始化
#djzc555内的逻辑由Deepseek V4 flash和Hy4生成

#提示用户启动成功
tellraw @a [{text:"[djzc555] ",color:"aqua"},{translate:"djzc555.msg.load",fallback:"冬季战场-射线检测系统加载成功",color:green}]

scoreboard objectives add djzc555.ray_dist dummy
#当前步数计数器

scoreboard objectives add djzc555.ray_max dummy
#最大步数限制

scoreboard objectives add djzc555.ray_type dummy
#射线类型：0=方块检测 1=实体检测 2=方块+实体检测

scoreboard objectives add djzc555.ray_uid dummy
#唯一ID，用于关联施法者与标记实体（sleep 模式多射线并存时启用）

scoreboard objectives add djzc555.ray_step dummy
#步长设置（值×0.1=实际格数，1=0.1格，10=1格）
#默认值1（0.1格精度），轰炸等场景可设为10（1格步长）

scoreboard objectives add djzc555.ray_particle dummy
#射线路径粒子特效：0=关闭 1..=开启
#粒子本体由 storage djzc555:raycast particle 配置，预设见 raycast/particle/
#默认值0（关闭），轰炸/雷枪入口会设为1

scoreboard objectives add djzc555.ray_sleep dummy
#每步间隔 tick：0=即时（默认），N=每步 sleep N tick
#sleep>0 时结果延迟产生，后续逻辑要挂到 raycast/internal/on_result

scoreboard objectives add djzc555.ray_timer dummy
#sleep 模式的运行态倒计时（记在射线标记实体上）

scoreboard objectives add djzc555.ray_keep dummy
#是否按 uid 保存结果槽：0=不保存（默认，即时调用方用不上），1=保存
#需要跨 tick 或事后查询时设 1，结果用 raycast/internal/consume_result 取

#重载时清空结果槽，避免上一轮的历史结果混进来
data modify storage djzc555:raycast results set value {}

#粒子默认 end_rod，外部改过就不覆盖
execute unless data storage djzc555:raycast particle.id run function djzc555:raycast/particle/end_rod

#UID 计数器，只在不存在时初始化，避免 reload 打断飞行中的射线
execute unless score #uid djzc555.ray_uid matches 0.. run scoreboard players set #uid djzc555.ray_uid 0