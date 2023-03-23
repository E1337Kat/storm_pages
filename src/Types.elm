module Types exposing
    ( Model
    , Msg(..)
    , ReturnWithEffects
    , Effect(..)
    , withRouter, withAbout
    )

{-| Manage the types for the overall frontend application.


# Types

@docs Model
@docs Msg
@docs ReturnWithEffects
@docs Effect


# Helper Functions

@docs withRouter, withAbout

-}

import About.Types
import I18n.Types exposing (LanguageId)
import ReturnedEffects
    exposing
        ( Effects
        , Return
        )
import Router.Types
import Time exposing (Posix)


{-| The model containing all the sub-module models in the application.
WARNING: The order here must match that of the main init and update functions!
-}
type alias Model navigationKey =
    { key : navigationKey
    , currentTime : Maybe Posix
    , currentLang : LanguageId
    , pageVisible : Bool
    , siteTitle : Maybe String
    , router : Router.Types.Model navigationKey
    , about : About.Types.Model
    }


{-| Update the router.
-}
withRouter : Router.Types.Model k -> Model k -> Model k
withRouter router model =
    { model | router = router }


{-| Update the about.
-}
withAbout : About.Types.Model -> Model k -> Model k
withAbout about model =
    { model | about = about }


{-| Top-level effects.
-}
type Effect
    = EffectFromRouter Router.Types.Effect
    | EffectFromAbout About.Types.Effect



-- | MessageEffect Msg


{-| Alias for return values.
-}
type alias ReturnWithEffects navigationKey =
    Return (Effects Effect) (Model navigationKey)


{-| The messages mapping all the sub-module messages.
-}
type Msg
    = MsgForAbout About.Types.Msg
      -- | MsgForKeyboardEvent
    | MsgForRouter Router.Types.Msg
    | PageVisibilityChanged Bool
      -- | Tick Posix
      -- | TimeZoneReceived
    | TwentySecondsPassed
