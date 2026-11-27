#不走寻常路：B点先于A点被占领时，授予当时在B点内的T队玩家
#坐标由 detection.mcfunction 从 storage djzc:map b_point 传入
$execute as @a[x=$(x),y=$(y),z=$(z),dx=$(dx),dy=$(dy),dz=$(dz),team=T] run advancement grant @s only djzc444:fight/unusual
