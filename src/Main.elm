module Main exposing
    ( Flags
    , main
    )

{-| Entrypoint to the Frontend application.


# Types

@docs Flags


# Function

@docs main

-}

import Browser
import Browser.Navigation exposing (Key)
import ReturnedEffects exposing (performEffects)
import Router.Types
import Types exposing (Model, Msg(..))
import Update exposing (performEffect, subscriptions)
import Url exposing (Url)
import View exposing (view)


{-| The application entrypoint into the application, for the Elm Architecture.
-}
main : Program Flags (Model Key) Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = MsgForRouter << Router.Types.UrlChanged
        , onUrlRequest = MsgForRouter << Router.Types.UrlRequested
        }


{-| Initialize, mapping effects to commands.
-}
init : Flags -> (Url -> (Key -> ( Model Key, Cmd Msg )))
init _ url key =
    Update.init url key
        |> Tuple.mapSecond (performEffects (performEffect key))


{-| The flags passed in to Elm at initialization.
-}
type alias Flags =
    { doIt : Maybe Bool }


{-| Update, mapping effects to commands.
-}
update : Msg -> (Model Key -> ( Model Key, Cmd Msg ))
update msg model =
    Update.update msg model
        |> Tuple.mapSecond (performEffects (performEffect model.key))
