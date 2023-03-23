module I18n.Types exposing
    ( LanguageId(..)
    , languageIdToString, languageIdFromString
    )

{-| General types used


# Types

@docs LanguageId


# Helpers

@docs languageIdToString, languageIdFromString

-}


{-| A Language ID
-}
type LanguageId
    = LanguageId String


{-| converts a given string into a LanguageID for the Page
-}
languageIdFromString : String -> LanguageId
languageIdFromString s =
    LanguageId s


{-| converts a given LanguageID into a string
-}
languageIdToString : LanguageId -> String
languageIdToString (LanguageId id) =
    id
