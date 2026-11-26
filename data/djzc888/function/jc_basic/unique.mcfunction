#教程-基础教程特有的内容

#开局时（A=0，B=0），被flow_begin调用
#execute if score A djzc.gameflow matches 0 if score B djzc.gameflow matches 0 run say begin

#C点启动器阶段（B+=1），被flow_a_b调用
#execute if score B+ djzc.gameflow matches 1 run say B+

#激活任意C点启动器（C1/C2/C3 任一=1）：阶段5 -> tutorial_starter -> 6
#starter_x 激活单个启动器后会调 game_flow->unique，此刻 C123 尚未归零、C1/C2/C3 之一为1
execute if score C1 djzc.gameflow matches 1 as @a if score @s djzc.tutorial matches 5 run dialog show @s djzc777:tutorial/tutorial_starter
execute if score C1 djzc.gameflow matches 1 as @a if score @s djzc.tutorial matches 5 run scoreboard players set @s djzc.tutorial 6
execute if score C2 djzc.gameflow matches 1 as @a if score @s djzc.tutorial matches 5 run dialog show @s djzc777:tutorial/tutorial_starter
execute if score C2 djzc.gameflow matches 1 as @a if score @s djzc.tutorial matches 5 run scoreboard players set @s djzc.tutorial 6
execute if score C3 djzc.gameflow matches 1 as @a if score @s djzc.tutorial matches 5 run dialog show @s djzc777:tutorial/tutorial_starter
execute if score C3 djzc.gameflow matches 1 as @a if score @s djzc.tutorial matches 5 run scoreboard players set @s djzc.tutorial 6

#C点激活（C123=3），被point/c_starter调用：阶段7 -> tutorial_c -> 8
#c_starter 第一行调用 unique，此刻 C123=3（C1/C2/C3 尚未置-1），一次事件只弹一次
execute if score C123 djzc.gameflow matches 3 as @a if score @s djzc.tutorial matches 7 run dialog show @s djzc777:tutorial/tutorial_c
execute if score C123 djzc.gameflow matches 3 as @a if score @s djzc.tutorial matches 7 run scoreboard players set @s djzc.tutorial 8

#D点启动器阶段（C+=1，D123=0），被flow_c_d调用
#execute if score C+ djzc.gameflow matches 1 if score D123 djzc.gameflow matches 0 run say C+

#D点激活（D123=3），被point/d_starter调用
#execute if score D123 djzc.gameflow matches 3 run say D123

#结束阶段（D=2），被flow_end调用
#execute if score D djzc.gameflow matches 2 run say end

#A点被T占领（A=1）
#execute if score A djzc.gameflow matches 1 run say A!!
#A点被CT占领（A=0）
#execute if score A djzc.gameflow matches 0 run say !!A

#B点被T占领（B=1）
#execute if score B djzc.gameflow matches 1 run say B!!
#B点被CT占领（B=0）
#execute if score B djzc.gameflow matches 0 run say !!B

#C点被T占领（C=2）
#execute if score C djzc.gameflow matches 2 run say C!!
#C点被CT占领（C=0）
#execute if score C djzc.gameflow matches 0 run say !!C

#占领D点（D=2）：阶段9 -> tutorial_d -> 10
execute if score D djzc.gameflow matches 2 as @a if score @s djzc.tutorial matches 9 run dialog show @s djzc777:tutorial/tutorial_d
execute if score D djzc.gameflow matches 2 as @a if score @s djzc.tutorial matches 9 run scoreboard players set @s djzc.tutorial 10
#D点被CT占领（D=0）
#execute if score D djzc.gameflow matches 0 run say !!D