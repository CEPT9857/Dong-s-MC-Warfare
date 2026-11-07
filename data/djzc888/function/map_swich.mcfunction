#根据计分板，选择地图
#然后读取地图命令存储，然后抄送到主游戏的命令存储中
execute if score map djzc.map matches 1 run function djzc888:dz_djzc/main
execute if score map djzc.map matches 2 run function djzc888:jc_basic/main