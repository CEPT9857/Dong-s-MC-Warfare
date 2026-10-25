$execute positioned $(x) $(y) $(z) as @n[type=armor_stand,sort=nearest,distance=..3] run effect give @s minecraft:glowing infinite
#高亮盔甲架本身
$execute positioned $(x) $(y) $(z) as @n[type=armor_stand,sort=nearest,distance=..3] run waypoint modify @s style set default
$execute positioned $(x) $(y) $(z) as @n[type=armor_stand,sort=nearest,distance=..3] run waypoint modify @s color white
$execute positioned $(x) $(y) $(z) as @n[type=armor_stand,sort=nearest,distance=..3] run attribute @s waypoint_transmit_range base set 196
#将盔甲架登录到定位栏中