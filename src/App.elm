module App exposing (main)

import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Sounds exposing (playButton, playCountdown)
import Svg exposing (path, svg)
import Svg.Attributes
    exposing
        ( d
        , fill
        , stroke
        , strokeWidth
        , viewBox
        )
import SvgPath exposing (makeCircle)
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type State
    = Idle
    | Prepare Int
    | Exercise Int
    | Finished


isRunning : State -> Bool
isRunning state =
    case state of
        Prepare _ ->
            True

        Exercise _ ->
            True

        _ ->
            False


toString : Model -> String
toString model =
    case model.state of
        Idle ->
            "idle"

        Prepare seconds ->
            "starting in " ++ String.fromInt (model.prepareTimer - seconds) ++ " seconds"

        Exercise seconds ->
            "running for " ++ String.fromInt (model.exerciseTimer - seconds) ++ " seconds"

        Finished ->
            "finished"


type alias Model =
    { prepareTimer : Int
    , exerciseTimer : Int
    , state : State
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { prepareTimer = 10
      , exerciseTimer = 40
      , state = Idle
      }
    , Cmd.none
    )


totalRunningTime : Model -> Int
totalRunningTime model =
    model.prepareTimer + model.exerciseTimer


runningTime : Model -> Int
runningTime model =
    case model.state of
        Prepare seconds ->
            seconds

        Exercise seconds ->
            model.prepareTimer + seconds

        Finished ->
            totalRunningTime model

        _ ->
            0



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.state of
        Prepare _ ->
            Time.every 1000 Tick

        Exercise _ ->
            Time.every 1000 Tick

        _ ->
            Sub.none



-- UPDATE


type Msg
    = Start
    | Stop
    | Finish
    | Tick Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            ( { model | state = Prepare 0 }, playButton )

        Stop ->
            ( { model | state = Finished }, playButton )

        Tick _ ->
            case model.state of
                Prepare seconds ->
                    if seconds >= model.prepareTimer then
                        ( { model | state = Exercise 0 }, Cmd.none )

                    else
                        ( { model | state = Prepare (seconds + 1) }, playCountdown (model.prepareTimer - seconds) )

                Exercise seconds ->
                    if seconds >= model.exerciseTimer then
                        ( { model | state = Finished }, Cmd.none )

                    else
                        ( { model | state = Exercise (seconds + 1) }, playCountdown (model.exerciseTimer - seconds) )

                _ ->
                    ( model, Cmd.none )

        Finish ->
            ( { model | state = Finished }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        dimensions =
            { width = 100, height = 100 }

        center =
            ( dimensions.width / 2, dimensions.height / 2 )

        angleStep =
            360 / toFloat (model.prepareTimer + model.exerciseTimer)

        prepareSeconds =
            case model.state of
                Prepare seconds ->
                    seconds

                Exercise _ ->
                    model.prepareTimer

                Finished ->
                    model.prepareTimer

                _ ->
                    0

        exerciseSeconds =
            case model.state of
                Exercise seconds ->
                    seconds

                Finished ->
                    model.exerciseTimer

                _ ->
                    0
    in
    div
        [ class "wrapper" ]
        [ div
            [ class "container"
            , onClick
                (if isRunning model.state then
                    Stop

                 else
                    Start
                )
            ]
            [ svg
                [ Svg.Attributes.class "graphic"
                , viewBox "0 0 100 100"
                ]
                [ -- Total Time Circle
                  path
                    [ stroke "grey"
                    , fill "none"
                    , strokeWidth "3"
                    , d (makeCircle center 40 0 360)
                    ]
                    []
                , -- Prepare Time Circle
                  path
                    [ stroke "yellow"
                    , fill "none"
                    , strokeWidth "3"
                    , d (makeCircle center 40 0 (toFloat prepareSeconds * angleStep))
                    ]
                    []
                , -- Exercise Time Circle
                  path
                    [ stroke "green"
                    , fill "none"
                    , strokeWidth "3"
                    , d (makeCircle center 40 (toFloat model.prepareTimer * angleStep) (toFloat exerciseSeconds * angleStep))
                    ]
                    []
                ]
            ]
        ]
