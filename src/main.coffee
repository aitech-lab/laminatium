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

###

# стартовая инициализация после загрузки

$ = require "jquery"

$ ->
  console.log "test"
  s = Snap 800, 800

