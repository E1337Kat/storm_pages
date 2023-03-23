module Router.Types exposing
    ( Model
    , Msg(..)
    , Effect(..)
    , ReturnWithEffects
    )

{-| Types for routing web requests to pages in the application.


# Types

@docs Model
@docs Msg
@docs Effect
@docs ReturnWithEffects

-}

import Browser exposing (UrlRequest)
import ReturnedEffects exposing (Effects, Return)
import Router.Routes exposing (Page)
import Url exposing (Url)


{-| The router model, containing page and [key][bn].

We have to use the navigation key as a generic type to work with [elm program test][kn].

[bn]: https://package.elm-lang.org/packages/elm/browser/latest/Browser.Navigation
[kn]: https://package.elm-lang.org/packages/avh4/elm-program-test/latest/ProgramTest

-}
type alias Model navigationKey =
    { page : Page
    , key : navigationKey
    }


{-| Alias for return values.
-}
type alias ReturnWithEffects navigationKey =
    Return (Effects Effect) (Model navigationKey)


{-| Effects of the router.
-}
type Effect
    = DirectCommand (Cmd Msg)
    | GoToPagePath String


{-| Router message events.
-}
type Msg
    = UrlChanged Url
    | UrlRequested UrlRequest
    | Go Page
