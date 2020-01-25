module SvgPathTests exposing (..)

import Expect exposing (Expectation)
import SvgPath exposing (getPointInCircle)
import Test exposing (..)


suite : Test
suite =
    describe "getPointInCircle"
        [ test "should return the correct point" <|
            \_ ->
                getPointInCircle ( 0, 0 ) 1 (degrees 0)
                    |> Expect.equal ( 0, -1 )
        , test "should return the correct point 2" <|
            \_ ->
                getPointInCircle ( 50, 50 ) 40 (degrees 0)
                    |> Expect.equal ( 50, 10 )
        , test "should return the correct point 3" <|
            \_ ->
                getPointInCircle ( 0, 0 ) 12 (degrees 115)
                    |> Expect.equal ( 10.8756934444398, 5.071419140888392 )
        ]
