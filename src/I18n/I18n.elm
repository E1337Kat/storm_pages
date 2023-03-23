module I18n.I18n exposing (translate, defaultLanguage)

{-| I18n localization types


# Functions

@docs translate, defaultLanguage

-}

import I18n.About
import I18n.Types exposing (LanguageId, languageIdFromString, languageIdToString)
import OpaqueDict
import Router.Routes


{-| The default language on fresh load
-}
defaultLanguage : LanguageId
defaultLanguage =
    languageIdFromString "ca"


{-| Top level translation function
-}
translate : LanguageId -> Router.Routes.Page -> String -> String
translate lang page trans =
    let
        missingTranslation : String
        missingTranslation =
            languageIdToString lang ++ "Translation Missing for key: `" ++ trans ++ "`"
    in
    case page of
        Router.Routes.Home ->
            let
                transSet : Maybe I18n.About.AboutKeys
                transSet =
                    OpaqueDict.get lang I18n.About.translations
            in
            Maybe.map (I18n.About.aboutKeyFromString trans) transSet
                |> Maybe.withDefault missingTranslation

        -- Router.Routes.Home ->
        --     let
        --         transSet : Maybe I18n.Home.HomeKeys
        --         transSet =
        --             OpaqueDict.get lang I18n.Home.translations
        --     in
        --     Maybe.map (I18n.Home.homeKeyFromString trans) transSet
        --         |> Maybe.withDefault missingTranslation
        _ ->
            missingTranslation
