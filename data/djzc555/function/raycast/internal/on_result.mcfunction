#结果回调，hit / miss 末尾都会调用，@s = 射线标记实体
#用 with entity @s data.result 调用，本条射线自己的结果就在参数里
#需要取结果时直接写 $(x) $(y) $(z) $(hit) $(steps) $(uid) 等
#引用了 result 里不存在的键会让整次调用失败，改这里时注意 entity / block 是条件写入的
#sleep>0 时结果延迟产生，把后续逻辑写在这里，别在调用射线后立刻读 storage
#sleep=0 时保持原有写法，调用后同一 tick 读 result 仍然有效
execute if entity @s run return 0
