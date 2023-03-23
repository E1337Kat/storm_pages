module About.Types exposing
    ( Model, Msg(..), ReturnWithEffects, Effect(..)
    , defaultModel
    )

{-| The types for the About Me area


# Types

@docs Model, Msg, ReturnWithEffects, Effect


# Functions

@docs defaultModel

-}

import ReturnedEffects exposing (Effects, Return)


{-| The "About Me" model
-}
type alias Model =
    { statusText : String
    }


{-| Alias for return values.
-}
type alias ReturnWithEffects =
    Return (Effects Effect) Model


{-| The default "about me" model.
-}
defaultModel : Model
defaultModel =
    { statusText = "Ready"
    }


{-| Messages the About Page can handle
-}
type Msg
    = ClickedChangeLanguageButton


{-| Effects the About Page can handle
-}
type Effect
    = NoOp
