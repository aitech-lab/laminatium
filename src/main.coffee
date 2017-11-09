###

Параметры:

  wall_offset  - отступ от стены [мм]
  board_w      - ширина доски [мм]
  board_h      - высота доски [мм]
  room_polygon - полигон комнаты 
  room_polygon_offset - полигон комнты с отсупом 
  room_bbox    - габариты комнаты
  flooring[]   - массив ламинатин
  
Алгоритм:
  1) сжимаем полигон на wall offset

###

# стартовая инициализация после загрузки

# Размеры канваса px
W = 800
H = 800

$ = require "jquery"
{rnd, poly2svg, path2svg, offset, clip} = require "./utils.coffee"

class Room
    constructor:(@svg)->
        do @random

    random:=>
        @poly = for i in [0..4]
            x = (1+rnd(4))*1000
            y = (1+rnd(4))*1000
            w = (2+rnd(4))*1000
            h = (2+rnd(4))*1000
            [
                { X: x  , Y: y  }
                { X: x+w, Y: y  }
                { X: x+w, Y: y+h}
                { X: x  , Y: y+h}
            ]
        
        glued_poly = offset @poly, 0
        glued_path = @svg.path poly2svg glued_poly
        glued_path.attr
            "vector-effect":"non-scaling-stroke"
            fill: "white"
            stroke: "gray"
            strokeWidth: 4
        
        @offseted_poly = offset glued_poly, -50
        @offseted_path = @svg.path poly2svg @offseted_poly
        @offseted_path.attr
            "vector-effect":"non-scaling-stroke"
            fill: "none"
            stroke: "red"
            strokeWidth: 1

        # blocks = @svg.path poly2svg @poly
        # blocks.attr
        #     "vector-effect":"non-scaling-stroke"
        #     "stroke-dasharray": "2, 5" 
        #     fill: "none"
        #     stroke: "gray"
        #     strokeWidth: 0.5


        g = @svg.group glued_path, @offseted_path
        g.attr
            transform: "scale(0.1)"
        
class Flooring
    constructor: (@svg, @room, @w=1380, @h=190)->
        @boards = [] 
        for j in [0..50]
            for i in [0..6]
                x = i*@w
                y = j*@h
                x+= @w/2 if j%2
                @boards.push [
                    { X: x   , Y: y   }
                    { X: x+@w, Y: y   }
                    { X: x+@w, Y: y+@h}
                    { X: x   , Y: y+@h}
                ]

        @clipped_boards = clip @boards, @room.offseted_poly

        g = @svg.group()
        g.attr
            transform: "scale(0.1)"
        for b, i in @clipped_boards
            p = @svg.path path2svg b
            p.attr
                "class": "flooring"
                "vector-effect":"non-scaling-stroke"
                fill: "none"
                stroke: "white"
                strokeWidth: 0.5
            setTimeout ((p)->p.animate {fill:"lightGray"}, 400), i*20, p
            
            p.mouseover @mouseover
            p.mouseout  @mouseout
            g.add p

        # boards_path = @svg.path poly2svg @boards
        # boards_path.attr
        #     "vector-effect":"non-scaling-stroke"
        #     fill: "none"
        #     stroke: "blue"
        #     strokeWidth: 1
        
    mouseover: ->
        @animate {fill: "darkGray"}, 200
    mouseout: ->
        @animate {fill: "lightGray"}, 200 
$ ->
    svg = Snap "100%", "100%"
    room = new Room svg
    flooring = new Flooring svg, room