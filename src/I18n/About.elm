module I18n.About exposing
    ( AboutKeys, AboutKey(..)
    , aboutKeyFromString, translations
    )

{-| Translations for a given Module


# Types

@docs AboutKeys, AboutKey


# Functions

@docs aboutKeyFromString, translations

-}

import I18n.Types exposing (LanguageId(..), languageIdToString)
import OpaqueDict exposing (OpaqueDict)


{-| A entry key
-}
type AboutKey
    = Greet String
    | Bio String
    | Salutations String
    | Signature String
    | Nyaa String
    | Purr String
    | CurrentLang String


{-| The set of keys used
-}
type alias AboutKeys =
    { langId : LanguageId
    , greet : AboutKey
    , bio : AboutKey
    , salutations : AboutKey
    , signature : AboutKey
    , nyaa : AboutKey
    , purr : AboutKey
    , currentLang : AboutKey
    }


{-| Get the key's actual text.
-}
asString : AboutKey -> String
asString key =
    case key of
        Greet t ->
            t

        Bio t ->
            t

        Salutations t ->
            t

        Signature t ->
            t

        Nyaa t ->
            t

        Purr t ->
            t

        CurrentLang t ->
            t


{-| get an about key from a string..
-}
aboutKeyFromString : String -> AboutKeys -> String
aboutKeyFromString string transSet =
    case string of
        "greet" ->
            transSet.greet |> asString

        "bio" ->
            transSet.bio |> asString

        "salutations" ->
            transSet.salutations |> asString

        "signature" ->
            transSet.signature |> asString

        "nyaa" ->
            transSet.nyaa |> asString

        "purr" ->
            transSet.purr |> asString

        "currentLang" ->
            transSet.currentLang |> asString

        _ ->
            "No About Page Translation for key: `" ++ string ++ "`"


{-| the translations on the page
-}
translations : OpaqueDict LanguageId AboutKeys
translations =
    OpaqueDict.fromList languageIdToString
        [ ( LanguageId "ca", ca )
        , ( LanguageId "en", en )
        , ( LanguageId "jp", jp )
        ]


{-| Translations for language key `ca`.
-}
ca : AboutKeys
ca =
    { langId = LanguageId "ca"
    , greet = Greet "Un lloc web d\"Ellie (per al seu gat)"
    , bio = Bio "Quan vaig començar a fer un lloc web per a ús personal, vaig acabar realitzant un lloc web. Aleshores, un dia, vaig descobrir que es pot comprar una URL amb emojis. El meu primer pensament va ser: \"noi, segur que podria divertir-me amb això!\" Així que vaig comprar una url. Aquest domini per ser exactes. Em va semblar divertit, però ara ni tan sols sé què posar-hi. Mentrestant, tindré aquest paràgraf i alguns enllaços a les meves altres coses ximples."
    , salutations = Salutations "Gràcies per llegir👋"
    , signature = Signature "Ellie Peterson"
    , nyaa = Nyaa "meuuu"
    , purr = Purr "grrr grrr grrr grrr"
    , currentLang = CurrentLang "Català"
    }


{-| Translations for language key `en`.
-}
en : AboutKeys
en =
    { langId = LanguageId "en"
    , greet = Greet "A website by Ellie (for her cat)"
    , bio = Bio "When I first set out to make a website for personal use, I ended up not actually making a website. Then one day I found out that one can buy a URL with emojis in it. My first thought was, \"boy, I sure could have some fun with this!\" So I bought a url. This domain to be exact. I thought it was funny, but now I don\"t even know what to put on it. In the mean time, I will have this paragraph and some links to my other silly things."
    , salutations = Salutations "Thank you for Reading👋"
    , signature = Signature "Ellie Peterson"
    , nyaa = Nyaa "meowww"
    , purr = Purr "grrr grrr grrr grrr"
    , currentLang = CurrentLang "English"
    }


{-| Translations for language key `jp`.
-}
jp : AboutKeys
jp =
    { langId = LanguageId "jp"
    , greet = Greet "ウェブサイトをエーリーの作る\u{3000}「彼女の猫に」"
    , bio = Bio "私の日本語のレブルはまだ低いだよ。そしで、この文が訳しない"
    , salutations = Salutations "これを読んでありがとう👋"
    , signature = Signature "えーリ・ペーターソン"
    , nyaa = Nyaa "ニャアア"
    , purr = Purr "ゴロゴロゴロゴロ"
    , currentLang = CurrentLang "日本語"
    }
