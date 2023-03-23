module Router.Routes exposing
    ( Page(..)
    , routes
    )

{-| Route web requests to particular pages.


# Types

@docs Page


# Helper Functions

@docs routes

-}

import Url.Parser exposing (Parser, map, oneOf, s, top)


{-| A specific page in the application.
-}
type Page
    = Home
    | NotFound


{-| Map a request to a page.
-}
routes : Parser (Page -> a) a
routes =
    oneOf
        [ map Home top
        , map NotFound (s "404")
        ]
