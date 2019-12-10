port module Sounds exposing (playBaap, playBeep, playButton, playCountdown)

import Json.Encode as Encode


port sounds : Encode.Value -> Cmd msg


play : String -> Cmd msg
play soundName =
    Encode.string soundName |> sounds


playBeep : Cmd msg
playBeep =
    play "beep"


playBaap : Cmd msg
playBaap =
    play "baap"


playButton : Cmd msg
playButton =
    play "button"


playCountdown : Int -> Cmd msg
playCountdown seconds =
    case seconds of
        3 ->
            playBeep

        2 ->
            playBeep

        1 ->
            playBaap

        _ ->
            Cmd.none
