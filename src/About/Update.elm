module About.Update exposing (init, update, performEffect)

{-| How to update the about me page


# Functions

@docs init, update, performEffect

-}

import About.Types exposing (Effect(..), Model, Msg(..), ReturnWithEffects, defaultModel)
import ReturnedEffects exposing (addEffect, build, singleton)


{-| Initialize the about page.
-}
init : ReturnWithEffects
init =
    singleton defaultModel


{-| Update the about page based on message.
-}
update : Msg -> Model -> ReturnWithEffects
update msg model =
    case msg of
        ClickedChangeLanguageButton ->
            let
                return : ReturnWithEffects
                return =
                    singleton model
            in
            return
                |> addEffect
                    (NoOp
                        |> build
                    )


{-| Transform the effect into a command.
-}
performEffect : Effect -> Cmd Msg
performEffect effect =
    case effect of
        NoOp ->
            Cmd.none
