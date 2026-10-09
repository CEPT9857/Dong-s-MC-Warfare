$execute as @p[x=$(x),y=$(y),z=$(z),dx=$(dx),dy=$(dy),dz=$(dz),team=T] at @p run scoreboard players remove T_$(NAME) djzc.time3 2
#如果T在X点内，扣除占点分数
$execute as @p[x=$(x),y=$(y),z=$(z),dx=$(dx),dy=$(dy),dz=$(dz),team=CT] at @p run scoreboard players add T_$(NAME) djzc.time3 1
#如果CT在X点内，增加占点分数

$execute store result bossbar djzc_point:$(name) value run scoreboard players get T_S$(NAME) djzc.time3
#存储占点分数到bossbar
$execute as @p[x=$(x),y=$(y),z=$(z),dx=$(dx),dy=$(dy),dz=$(dz)] at @p run bossbar set djzc_point:$(name) visible true
$bossbar set djzc_point:$(name) players @a
#显示bossbar
$execute if score T_S$(NAME) djzc.time3 <= 15 djzc.time3 run bossbar set djzc_point:$(name) color red
$execute if score T_S$(NAME) djzc.time3 > 15 djzc.time3 run bossbar set djzc_point:$(name) color blue
#改bossbar颜色

$execute if score T_$(NAME) djzc.time3 <= 1000 djzc.time3 run scoreboard players remove T_S$(NAME) djzc.time3 1
$execute if score T_$(NAME) djzc.time3 <= 1000 djzc.time3 run scoreboard players set T_$(NAME) djzc.time3 1040
#小于1000时退位

$execute if score T_S$(NAME) djzc.time3 <= 0 djzc.time3 run function djzc444:points/x_occupy_by_t with storage djzc:map $(name)_point
$execute if score T_S$(NAME) djzc.time3 <= 0 djzc.time3 run scoreboard players set T_S$(NAME) djzc.time3 60
#引用占点函数

$execute if score T_$(NAME) djzc.time3 > 1040 djzc.time3 run scoreboard players add T_S$(NAME) djzc.time3 1
$execute if score T_$(NAME) djzc.time3 > 1040 djzc.time3 run scoreboard players set T_$(NAME) djzc.time3 1002
#超过1040时进位
$execute if score T_S$(NAME) djzc.time3 > 60 djzc.time3 run scoreboard players set T_S$(NAME) djzc.time3 60
#超过30时限制最大值

$execute as @p at @s unless entity @p[x=$(x),y=$(y),z=$(z),dx=$(dx),dy=$(dy),dz=$(dz)] run bossbar set djzc_point:$(name) visible false
#如果点里没有人，关闭bossbar