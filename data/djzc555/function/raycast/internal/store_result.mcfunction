#按 uid 把本次结果写进独立槽，ray_keep=1 时由 hit / miss 调用
#宏参数来自 storage djzc555:raycast tmp，调用前先写 tmp.uid
$data modify storage djzc555:raycast results.u$(uid) set from storage djzc555:raycast result
