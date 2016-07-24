formatList = function() {
    return {
        "func_list":[
            {
                "id": "touch.on",
                "name": "touch.on(id, x, y)",
                "type": "pos"
            },
            {
                "id": "touch.move",
                "name": "touch.move(id, x, y)",
                "type": "pos"
            },
            {
                "id": "app.run",
                "name": "app.run(bid)",
                "type": "bid"
            },
            {
                "id": "screen.find_color",
                "name": "screen.find_color(multicolor, sim, ...)",
                "type": "mpos"
            }
        ],
        "snippet_list":[
            {
                "name":"local ... = ...",
                "content":"local  =  "
            },
            {
                "name":"do ... end",
                "content":"do\n\nend"
            },
            {
                "name":"if ... then ... end",
                "content":"if  then\n\nend"
            }
        ]
    }
}

customFunction = function(funcId, pos_color_list, bid) {
    switch(funcId) {
        case "touch.on":
            return "touch.on(0, " + pos_color_list[1].x + ", " + pos_color_list[1].y + ")";
    }
}