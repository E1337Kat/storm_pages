module Router.Update exposing
    ( init
    , update
    , performEffect
    )

{-| Manage changes to routing.


# Elm Architecture Functions

@docs init
@docs update


# Helper Functions

@docs performEffect

-}

import Browser exposing (UrlRequest(..))
import Browser.Navigation exposing (Key, load)
import ReturnedEffects exposing (build, none, singleton)
import Router.RemoteApi exposing (loadUrlInNewTab)
import Router.Routes exposing (Page(..), routes)
import Router.Types exposing (Effect(..), Model, Msg(..), ReturnWithEffects)
import Url exposing (Url)
import Url.Parser exposing (parse)


{-| Initialize the router.
-}
init : Url -> navigationKey -> ReturnWithEffects navigationKey
init url key =
    singleton
        { page = Maybe.withDefault NotFound <| parse routes url
        , key = key
        }


{-| Update the router based on message.
-}
update : Msg -> Model navigationKey -> ReturnWithEffects navigationKey
update msg model =
    case msg of
        UrlChanged url ->
            ( { model | page = Maybe.withDefault NotFound <| parse routes url }
            , none
            )

        UrlRequested urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model, load (Url.toString url) )
                        |> Tuple.mapSecond (DirectCommand >> build)

                External "" ->
                    ( model, Cmd.none )
                        |> Tuple.mapSecond (DirectCommand >> build)

                External url ->
                    ( model, loadUrlInNewTab url )
                        |> Tuple.mapSecond (DirectCommand >> build)


{-| Transform the effect into a command.
-}
performEffect : Key -> Effect -> Cmd Msg
performEffect _ effect =
    case effect of
        DirectCommand cmd ->
            cmd
