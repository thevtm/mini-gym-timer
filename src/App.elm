module App exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
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


toString : Model -> String
toString model =
    case model.state of
        Idle ->
            "idle"

        Prepare seconds ->
            "starting in " ++ String.fromInt (model.prepareTimer - seconds) ++ " seconds"

        Exercise seconds ->
            "running for " ++ String.fromInt seconds ++ " seconds"

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
    | Finish
    | Tick Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            ( { model | state = Prepare 0 }, Cmd.none )

        Tick _ ->
            case model.state of
                Prepare seconds ->
                    if seconds >= model.prepareTimer then
                        ( { model | state = Exercise 0 }, Cmd.none )

                    else
                        ( { model | state = Prepare (seconds + 1) }, Cmd.none )

                Exercise 10 ->
                    ( { model | state = Finished }, Cmd.none )

                Exercise seconds ->
                    ( { model | state = Exercise (seconds + 1) }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Finish ->
            ( { model | state = Finished }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "m-8" ]
        [ div [ class "m-2" ] [ text ("Status: " ++ toString model) ]
        , button [ class "p-2 mr-2 bg-gray-200", onClick Start ] [ text "Start" ]
        , button [ class "p-2 bg-gray-200", onClick Finish ] [ text "Stop" ]
        ]
