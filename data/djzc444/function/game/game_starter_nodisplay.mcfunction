$execute positioned $(x) $(y) $(z) as @n[type=armor_stand,sort=nearest,distance=..3] run effect clear @s
#解除盔甲架高亮
$execute positioned $(x) $(y) $(z) as @n[type=armor_stand,sort=nearest,distance=..3] run waypoint modify @s style set default
$execute positioned $(x) $(y) $(z) as @n[type=armor_stand,sort=nearest,distance=..3] run waypoint modify @s color white
$execute positioned $(x) $(y) $(z) as @n[type=armor_stand,sort=nearest,distance=..3] run attribute @s waypoint_transmit_range base set 0
#将盔甲架从定位栏中清除