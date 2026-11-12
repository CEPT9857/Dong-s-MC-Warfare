#在射线检测结果位置生成轰炸标记
#宏函数：从 storage djzc555:raycast result 读取坐标并生成 mark3 实体
#用法：function djzc555:raycast/spawn_at_result with storage djzc555:raycast result
#与原 lib_boom_marker 的 mark2→mark3 过渡行为一致

#在命中/终点位置生成轰炸标记实体，临时标签用于精确找到本次生成的那一个
#不能用 @e[tag=mark3,sort=nearest]：这个函数从施法者位置执行，nearest 会挑到场上已有的旧标记
$summon minecraft:marker $(x) $(y) $(z) {Tags:["mark3","djzc444.mark3_new"]}

#在命中/终点位置播放引爆音效（与原 mark2 触地音效一致）
$playsound entity.creeper.primed ambient @a $(x) $(y) $(z) 1.0 1.0

#只给本次生成的标记设倒计时（不加 limit，同 tick 生成多个也能全部覆盖）
scoreboard players set @e[tag=djzc444.mark3_new,type=minecraft:marker] djzc.time2 200
tag @e[tag=djzc444.mark3_new] remove djzc444.mark3_new

#清除射线检测结果存储
data modify storage djzc555:raycast result set value {}
