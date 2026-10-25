#教程-基础教程特有的内容


#开局时（A=0，B=0），被flow_begin调用
#execute if score A djzc.gameflow matches 0 if score B djzc.gameflow matches 0 run say begin

#C点启动器阶段（B+=1），被flow_a_b调用
#execute if score B+ djzc.gameflow matches 1 run say B+

#C点激活（C123=3），被point/c_starter调用
#execute if score C123 djzc.gameflow matches 3 run say C123

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

#D点被T占领（D=2）
#execute if score D djzc.gameflow matches 2 run say D!!
#D点被CT占领（D=0）
#execute if score D djzc.gameflow matches 0 run say !!D