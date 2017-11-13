
path2svg = (path)->
    svg = path.map (point, j)->
        pref = if j is 0 then "M" else "L"
        "#{pref}#{point.X},#{point.Y}"
    svg+="Z"

poly2svg = (poly) ->
    svg_path = poly.reduce (svg, path)->
        svg += path2svg path
    , ""

offset = (poly, delta)->
    co = new ClipperLib.ClipperOffset()
    offseted = new ClipperLib.Paths()
    co.AddPaths(poly,  ClipperLib.JoinType.jtMiter, ClipperLib.EndType.etClosedPolygon);
    co.MiterLimit = 10;
    co.ArcTolerance = 0.25;
    co.Execute offseted, delta
    offseted

clip = (subj, clip)->
    subj = offset subj, -10
    cpr = new ClipperLib.Clipper()
    cpr.AddPaths subj, ClipperLib.PolyType.ptSubject, true
    cpr.AddPaths clip, ClipperLib.PolyType.ptClip, true
    result = new ClipperLib.Paths();
    cpr.Execute(
        ClipperLib.ClipType.ctIntersection, 
        result, 
        ClipperLib.PolyFillType.pftNonZero, 
        ClipperLib.PolyFillType.pftNonZero)
    result = offset result, 9
    result

area = (poly)->
    console.log poly
    ClipperLib.JS.AreaOfPolygons poly

path_bbox = (path)->
    min_x = min_y =  Infinity
    max_x = max_y = -Infinity
    # ищем крайние точки
    path.map (p)->
        min_x = p.X if min_x > p.X
        min_y = p.Y if min_y > p.Y
        max_x = p.X if max_x < p.X
        max_y = p.Y if max_y < p.Y

    l: min_x # left
    t: min_y # top 
    r: max_x # right
    b: max_y # bottom

poly_bbox = (poly)->
    bbox = l: Infinity, t: Infinity, r:-Infinity, b:-Infinity
    # расширяем bbox полигона по включенным в него примитивам
    poly.map (path)->
        b = path_bbox path
        bbox.l = b.l if bbox.l > b.l
        bbox.t = b.t if bbox.t > b.t
        bbox.r = b.r if bbox.r < b.r
        bbox.b = b.b if bbox.b < b.b 
    bbox.w = bbox.r-bbox.l # ширина
    bbox.h = bbox.b-bbox.t # высотыа
    return bbox 

point_inside_path = (point, polygon) ->
    x = point.X
    y = point.Y
    inside = false
    i = 0
    j = polygon.length - 1
    while i < polygon.length
        xi = polygon[i].X
        yi = polygon[i].Y
        xj = polygon[j].X
        yj = polygon[j].Y
        intersect =((yi > y) isnt (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
        if intersect
            inside = !inside
        j = i++
    inside

point_inside = (point, poly)->
    for path in poly
        if point_inside_path point, path
            return true
    false

module.exports = 
    rnd: (r)-> Math.random()*r|0
    poly2svg: poly2svg
    path2svg: path2svg
    poly_bbox: poly_bbox
    path_bbox: path_bbox
    area: area
    point_inside: point_inside
    offset: offset
    clip: clip