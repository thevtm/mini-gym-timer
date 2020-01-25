module SvgPath exposing (Point2D, getPointInCircle, makeCircle, svgPathArc, svgPathMove)


type alias Point2D =
    ( Float, Float )


getPointInCircle : Point2D -> Float -> Float -> Point2D
getPointInCircle ( cx, cy ) radius angleRad =
    ( cx + (sin angleRad * radius), cy + (cos angleRad * radius * -1) )


svgPathMove : Point2D -> String
svgPathMove ( x, y ) =
    -- M x y
    String.join " "
        [ "M"
        , String.fromFloat x
        , String.fromFloat y
        ]


svgPathArc : Float -> Point2D -> String
svgPathArc radius ( x, y ) =
    -- A rx ry x-axis-rotation large-arc-flag sweep-flag x y
    String.join " "
        [ "A"
        , String.fromFloat radius
        , String.fromFloat radius
        , "0"
        , "0 1"
        , String.fromFloat x
        , String.fromFloat y
        ]


makeCircle : Point2D -> Float -> Float -> Float -> String
makeCircle ( cx, cy ) radius rotation length =
    if length > 180 then
        String.join " "
            [ makeCircle ( cx, cy ) radius rotation 180
            , makeCircle ( cx, cy ) radius (rotation + 180) (length - 180)
            ]

    else
        let
            pA =
                getPointInCircle ( cx, cy ) radius (degrees rotation)

            pB =
                getPointInCircle ( cx, cy ) radius (degrees (rotation + length))
        in
        String.join " "
            [ svgPathMove pA
            , svgPathArc radius pB
            ]
