module About.View exposing (view)

{-| The views for the About Me module


# Functions

@docs view

-}

import About.Types exposing (Model, Msg(..))
import Html
    exposing
        ( Html
        , a
        , br
        , button
        , div
        , h1
        , h3
        , img
        , li
        , p
        , text
        , ul
        )
import Html.Attributes as Attr
import Html.Events exposing (onClick)
import I18n.I18n exposing (translate)
import I18n.Types exposing (LanguageId)
import Router.Routes exposing (Page)


{-| The view model for the about page.
-}
view : LanguageId -> Page -> Model -> Html Msg
view requestedLang currentPage _ =
    div []
        [ div
            [ Attr.class "main-content"
            ]
            [ h1 [] [ text (translate requestedLang currentPage "greet") ]
            , p [] [ text (translate requestedLang currentPage "bio") ]
            , p
                [ Attr.class "salutations" ]
                [ text (translate requestedLang currentPage "salutations") ]
            , p
                [ Attr.class "signature" ]
                [ text (translate requestedLang currentPage "signature") ]
            , ul []
                [ li []
                    [ a
                        [ Attr.href "https://twitter.com/kellieinthelab"
                        ]
                        [ text "My super weird twitter (@KellieInTheLab)" ]
                    ]
                , li []
                    [ a
                        [ Attr.href "https://github.com/e1337kat" ]
                        [ text "My dope github" ]
                    ]
                ]
            , div
                [ Attr.class "storm-images"
                ]
                [ h3 [] [ text "Storm:" ]
                , br [] []
                , div
                    [ Attr.class "storm-face" ]
                    [ img
                        [ Attr.src "nyaasets/strom_face.png"
                        , Attr.title "Cute stupid face."
                        ]
                        []
                    , p [] [ text (translate requestedLang currentPage "nyaa") ]
                    ]
                , div
                    [ Attr.class "storm-ball"
                    ]
                    [ img
                        [ Attr.src "nyaasets/storm_ball.png"
                        , Attr.title "Cute ball animal."
                        ]
                        []
                    , p [] [ text (translate requestedLang currentPage "purr") ]
                    ]
                ]
            ]
        , div [ Attr.class "footer" ]
            [ p [] [ text "Pick a language. Current Language:" ]
            , p [] [ text (translate requestedLang currentPage "currentLang") ]
            , button
                [ onClick ClickedChangeLanguageButton ]
                [ text "Change Language" ]
            ]
        ]
