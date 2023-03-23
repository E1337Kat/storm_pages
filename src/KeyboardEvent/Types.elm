module KeyboardEvent.Types exposing
    ( keyDecoder
    , Msg(..)
    , Model(..)
    )

{-| Functionality for interpreting keyboard events.


# JSON Decoders

@docs keyDecoder


# Types

@docs Msg
@docs Model

-}

import Json.Decode as Decode


{-| The Msg represents a key pressed event. In other words, it says that "this particular key was pressed."
-}
type Msg
    = KeyPressed Model


{-| The Model represents which key was pressed.
-}
type Model
    = Backspace
    | Character Char
    | Control String
    | ArrowLeft
    | ArrowRight
    | ArrowUp
    | ArrowDown
    | EnterKey
    | TabKey


{-| Decode a key event from JSON

    Json.Decode.decodeString keyDecoder "{ \"key\": \"blah\" }" -- Ok (KeyPressed (Control "blah")) : Result Json.Decode.Error Msg

-}
keyDecoder : Decode.Decoder Msg
keyDecoder =
    Decode.map toKey (Decode.field "key" Decode.string)


{-| Convert a string to a key message.
-}
toKey : String -> Msg
toKey string =
    let
        theKey : Model
        theKey =
            case string of
                "ArrowLeft" ->
                    ArrowLeft

                "ArrowRight" ->
                    ArrowRight

                "ArrowDown" ->
                    ArrowDown

                "ArrowUp" ->
                    ArrowUp

                "Backspace" ->
                    Backspace

                "Enter" ->
                    EnterKey

                "Tab" ->
                    TabKey

                _ ->
                    case String.uncons string of
                        Just ( char, "" ) ->
                            Character char

                        _ ->
                            Control string
    in
    KeyPressed theKey
