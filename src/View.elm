module View exposing (view)

{-| Render the overall view for the application.


# View Helper

@docs view

-}

import About.View
import Browser
import Html
    exposing
        ( Html
        , div
        , map
        , text
        )
import Html.Attributes exposing (class)
import Router.Routes exposing (Page(..))
import Router.Types exposing (Msg(..))
import Types exposing (Model, Msg(..))


{-| Render the overall application model into HTML.
-}
view : Model navigationKey -> Browser.Document Msg
view model =
    let
        siteTitle : String
        siteTitle =
            model.siteTitle |> Maybe.withDefault ""
    in
    { title = siteTitle
    , body =
        [ div [ class "storm-body" ]
            [ renderRoute model
            ]
        ]
    }


{-| Render the view of the given route.
-}
renderRoute : Model navigationKey -> Html Msg
renderRoute ({ router } as model) =
    case router.page of
        Home ->
            map MsgForAbout (About.View.view model.currentLang router.page model.about)

        _ ->
            Html.h1 [] [ text "404 not found" ]
