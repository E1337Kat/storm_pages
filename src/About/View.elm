module About.View exposing (view)

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


view : Model -> Html Msg
view _ =
    div []
        [ div
            [ Attr.class "main-content"
            ]
            [ h1
                [ Attr.attribute "data-translate" "greet"
                ]
                []
            , p
                [ Attr.attribute "data-translate" "bio"
                ]
                []
            , p
                [ Attr.class "salutations"
                , Attr.attribute "data-translate" "salutations"
                ]
                []
            , p
                [ Attr.class "signature"
                , Attr.attribute "data-translate" "signature"
                ]
                []
            , ul []
                [ li []
                    [ a
                        [ Attr.href "https://twitter.com/kellieinthelab"
                        ]
                        [ text "My super weird twitter (@KellieInTheLab)" ]
                    ]
                , li []
                    [ a
                        [ Attr.href "https://github.com/e1337kat"
                        ]
                        [ text "My dope github" ]
                    ]
                ]
            , div
                [ Attr.class "storm-images"
                ]
                [ h3 []
                    [ text "Storm:" ]
                , br []
                    []
                , div
                    [ Attr.class "storm-face"
                    ]
                    [ img
                        [ Attr.src "img/strom_face.png"
                        , Attr.title "Cute stupid face."
                        ]
                        []
                    , p
                        [ Attr.attribute "data-translate" "nyaa"
                        ]
                        []
                    ]
                , div
                    [ Attr.class "storm-ball"
                    ]
                    [ img
                        [ Attr.src "img/storm_ball.png"
                        , Attr.title "Cute ball animal."
                        ]
                        []
                    , p
                        [ Attr.attribute "data-translate" "purr"
                        ]
                        []
                    ]
                ]
            ]
        , div [ Attr.class "footer" ]
            [ p []
                [ text "Pick a language. Current Language:" ]
            , p
                [ Attr.attribute "data-translate" "current-lang"
                ]
                []
            , button
                [ onClick ClickedChangeLanguageButton ]
                [ text "Change Language" ]
            ]
        ]
