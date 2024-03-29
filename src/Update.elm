module Update exposing
    ( init
    , subscriptions
    , update
    , performEffect
    )

{-| Elm architecture updates for the overall application.


# Elm Architecture Functions

@docs init
@docs subscriptions
@docs update


# Helper Functions

@docs performEffect

-}

import About.Types
import About.Update
import Browser.Navigation exposing (Key)
import I18n.I18n exposing (defaultLanguage)
import I18n.Types exposing (LanguageId(..))
import ReturnedEffects
    exposing
        ( Effects
        , addEffect
        , andMapEffect
        , foldl
        , listMap
        , map
        , singleton
        )
import Router.RemoteApi exposing (receivePageVisibility)
import Router.Routes exposing (Page(..))
import Router.Types
import Router.Update
import Time exposing (every)
import Types
    exposing
        ( Effect(..)
        , Model
        , Msg(..)
        , ReturnWithEffects
        )
import Url exposing (Url)


{-| Initialize the overall application.
-}
init : Url -> (navigationKey -> ReturnWithEffects navigationKey)
init url key =
    singleton (Model key Nothing defaultLanguage True (Just ""))
        |> andMapEffect EffectFromRouter (Router.Update.init url key)
        |> andMapEffect EffectFromAbout About.Update.init
        |> maybeActOnInitialState


{-| Update the application given the message.
-}
update : Msg -> (Model navigationKey -> ReturnWithEffects navigationKey)
update uberMessage model =
    let
        return : ReturnWithEffects navigationKey
        return =
            singleton model

        returnMapper : ReturnWithEffects navigationKey -> ReturnWithEffects navigationKey
        returnMapper =
            case uberMessage of
                MsgForRouter msg ->
                    mapEffectAndModel EffectFromRouter Types.withRouter (Router.Update.update msg model.router)

                MsgForAbout msg ->
                    mapEffectAndModel EffectFromAbout Types.withAbout (About.Update.update msg model.about)

                _ ->
                    identity
    in
    return
        |> returnMapper
        |> maybeActOnUpdatedState uberMessage


{-| Map the effect and model from a sub-module into the parent effects and model.
-}
mapEffectAndModel :
    (e -> Effect)
    -> (m -> Model navigationKey -> Model navigationKey)
    -> ( m, Effects e )
    -> ReturnWithEffects navigationKey
    -> ReturnWithEffects navigationKey
mapEffectAndModel effectMapper modelMutator ( subModel, subEffects ) return =
    return
        |> map (modelMutator subModel)
        |> addEffect (subEffects |> listMap effectMapper)


{-| Transform the effect into a command.
-}
performEffect : Key -> Effect -> Cmd Msg
performEffect navigationKey effect =
    case effect of
        EffectFromAbout subEffect ->
            About.Update.performEffect subEffect |> Cmd.map MsgForAbout

        EffectFromRouter subEffect ->
            Router.Update.performEffect navigationKey subEffect |> Cmd.map MsgForRouter


{-| Subscribe to messages.
-}
subscriptions : Model navigationKey -> Sub Msg
subscriptions _ =
    Sub.batch
        [ every 20000 (always Types.TwentySecondsPassed)
        , receivePageVisibility PageVisibilityChanged
        ]


{-| Perhaps act on page request.
-}
maybeActOnPageRequest : ( Model navigationKey, Effects Effect ) -> ReturnWithEffects navigationKey
maybeActOnPageRequest (( model, msg ) as return) =
    let
        updatedEffects : ReturnWithEffects navigationKey
        updatedEffects =
            case model.router.page of
                Home ->
                    ( model
                    , [ msg ]
                        |> foldl
                    )

                _ ->
                    return
    in
    updatedEffects


{-| Perhaps act on the initial state of a given page.
-}
maybeActOnInitialState : ( Model navigationKey, Effects Effect ) -> ReturnWithEffects navigationKey
maybeActOnInitialState return =
    maybeActOnPageRequest return


{-| Perhaps act on the updated state of a given page.
-}
maybeActOnUpdatedState : Msg -> ( Model navigationKey, Effects Effect ) -> ReturnWithEffects navigationKey
maybeActOnUpdatedState originalMsg (( model, _ ) as return) =
    case originalMsg of
        MsgForAbout About.Types.ClickedChangeLanguageButton ->
            let
                nextLang : LanguageId
                nextLang =
                    case model.currentLang of
                        LanguageId "ca" ->
                            LanguageId "en"

                        LanguageId "en" ->
                            LanguageId "jp"

                        LanguageId "jp" ->
                            LanguageId "ca"

                        _ ->
                            LanguageId "en"
            in
            return
                |> map (\m -> { m | currentLang = nextLang })

        -- All we care about for page requests are route changes, so will act only when the original message is for the router and the URL actually changed.
        MsgForRouter (Router.Types.UrlChanged _) ->
            maybeActOnPageRequest return

        PageVisibilityChanged pageVisible ->
            return
                |> map (\model_ -> { model_ | pageVisible = pageVisible })

        _ ->
            return
