module Types exposing
    ( Model
    , Msg(..)
    , ReturnWithEffects
    , Effect(..)
    , withRouter
    )

{-| Manage the types for the overall frontend application.


# Types

@docs Model
@docs Msg
@docs ReturnWithEffects
@docs Effect


# Helper Functions

@docs withRouter

-}

-- import Json.Decode as Decode
-- import Json.Encode exposing (Value)

import About.Types
import KeyboardEvent.Types
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

    -- , uuidWithSeeds : UUIDWithSeeds
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


{-| Top-level effects.
-}
type Effect
    = DirectCommand (Cmd Msg)
    | EffectFromRouter Router.Types.Effect
    | EffectFromAbout About.Types.Effect
    | MessageEffect Msg


{-| Alias for return values.
-}
type alias ReturnWithEffects navigationKey =
    Return (Effects Effect) (Model navigationKey)


{-| The messages mapping all the sub-module messages.
-}
type Msg
    = CurrentTimeReceived Posix
    | MsgForAbout About.Types.Msg
    | MsgForKeyboardEvent KeyboardEvent.Types.Msg
    | MsgForRouter Router.Types.Msg
    | PageVisibilityChanged Bool
    | Tick Posix
    | TimeZoneReceived Time.Zone
    | TwentySecondsPassed
