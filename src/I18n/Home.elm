module I18n.Home exposing
    ( HomeI18n(..), HomeKeys, HomeKey(..)
    , homeKeyFromString, translations
    )

{-| Translations for a given Module


# Types

@docs HomeI18n, HomeKeys, HomeKey


# Functions

@docs homeKeyFromString, translations

-}

import I18n.Types exposing (LanguageId(..), languageIdToString)
import OpaqueDict exposing (OpaqueDict)


{-| A entry key
-}
type HomeKey
    = Greet String


{-| The set of keys used
-}
type alias HomeKeys =
    { langId : LanguageId
    , greet : HomeKey
    }


{-| What actually hold all the transaltions
-}
type HomeI18n
    = OpaqueDict LanguageId HomeKeys


asString : HomeKey -> String
asString key =
    case key of
        Greet t ->
            t


homeKeyFromString : String -> HomeKeys -> String
homeKeyFromString string transSet =
    case string of
        "greet" ->
            transSet.greet |> asString

        _ ->
            "No Home Page Translation for key: `" ++ string ++ "`"


{-| the translations on the page
-}
translations : OpaqueDict LanguageId HomeKeys
translations =
    OpaqueDict.fromList languageIdToString
        [ ( LanguageId "ca", ca )
        , ( LanguageId "en", en )
        , ( LanguageId "jp", jp )
        ]


ca : HomeKeys
ca =
    { langId = LanguageId "ca"
    , greet = Greet "Un lloc web d\"Ellie (per al seu gat)"
    }


en : HomeKeys
en =
    { langId = LanguageId "en"
    , greet = Greet "A website by Ellie (for her cat)"
    }


jp : HomeKeys
jp =
    { langId = LanguageId "jp"
    , greet = Greet "ウェブサイトをエーリーの作る\u{3000}「彼女の猫に」"
    }
