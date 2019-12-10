module App exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class, disabled)
import Html.Events exposing (onClick)
import Json.Encode as Encode
import Sounds exposing (playBaap, playBeep, playButton, playCountdown)
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


canStart : State -> Bool
canStart state =
    case state of
        Idle ->
            True

        Finished ->
            True

        _ ->
            False


canStop : State -> Bool
canStop state =
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
    div [ class "m-8" ]
        [ div [ class "m-2" ] [ text ("Status: " ++ toString model) ]
        , button [ class "p-2 mr-2 bg-gray-200", onClick Start, disabled (not (canStart model.state)) ] [ text "Start" ]
        , button [ class "p-2 bg-gray-200", onClick Stop, disabled (not (canStop model.state)) ] [ text "Stop" ]
        ]
