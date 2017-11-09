
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
    co.MiterLimit = 2;
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

module.exports = 
    rnd: (r)-> Math.random()*r|0
    poly2svg: poly2svg
    path2svg: path2svg
    offset: offset
    clip: clip