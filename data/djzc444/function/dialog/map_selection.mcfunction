$dialog show @s \
 {\
    type:"multi_action",\
    "pause": false,\
    title:{\
        "translate": "djzc.dialog.map_selection.title",\
        "fallback":"地图选择",\
        "color":"yellow",\
        "bold": true,\
        "hover_event": {\
            "action": "show_text",\
            "value": {\
                "translate": "djzc.dialog.author_write",\
                "fallback": "%1$s 编写",\
                "with":[\
                    {\
                "translate":"djzc.dialog.author1",\
                "fallback":"冬战制作组"\
                    }\
                ]\
            }\
        }\
     },\
     "body":[\
        {\
            "type":"plain_message",\
            "contents":{\
            "translate": "djzc.dialog.map",\
            "fallback":"当前地图：%1$s",\
            "with": [\
                {\
                    "translate": "djzc.dialog.wiki.map_$(map_name).title",\
                    "fallback": "未知地图",\
                    "color": "aqua",\
                    "hover_event": {\
                    "action": "show_text",\
                    "value": {\
                    "translate": "djzc.dialog.wiki.map_$(map_name).body1",\
                    "fallback": "未知地图"\
                    }\
                    }\
                }\
            ]\
        }\
        }\
    ],\
    "columns": 1,\
    "actions":[\
        {\
            "label":{\
                "translate": "djzc.dialog.wiki.map_dz_djzc.title",\
                "fallback": "冬季战场",\
                "color": "aqua"\
            },\
            "tooltip": {\
                "translate": "djzc.dialog.wiki.map_dz_djzc.body1",\
                "fallback": "冬季战场是我们的第一张地图，冬战诞生的地方:)"\
            },\
            "action": {\
                "type": "run_command",\
                "command": "trigger djzc.map set 1"\
            }\
        },\
        {\
            "label":{\
                "translate": "djzc.dialog.wiki.map_jc_basic.title",\
                "fallback": "教程-基础教程",\
                "color": "white"\
            },\
            "tooltip": {\
                "translate": "djzc.dialog.wiki.map_jc_basic.body1",\
                "fallback": "我们的第二张地图，新手教程就是在这里进行的"\
            },\
            "action": {\
                "type": "run_command",\
                "command": "trigger djzc.map set 2"\
            }\
        }\
    ]\
 }