module ReturnedEffects exposing
    ( Return
    , Effects(..)
    , map
    , performEffects
    , foldl
    , listMap
    , addEffect
    , andMapEffect
    , singleton
    , none
    , build
    )

{-| Helper functionality for effects, analogous to elm-return's types and functions.


# Types

@docs Return
@docs Effects


# Helper Functions

@docs map
@docs performEffects
@docs foldl
@docs listMap
@docs addEffect
@docs andMapEffect
@docs singleton
@docs none
@docs build

-}


{-| List of effects
-}
type Effects effect
    = Effects (List effect)


{-| Build effects from an effect.
-}
build : effect -> Effects effect
build e =
    e
        |> List.singleton
        |> Effects


{-| Perform the effects as commands.
-}
performEffects : (e -> Cmd a) -> Effects e -> Cmd a
performEffects f (Effects effects) =
    effects
        |> List.map f
        |> Cmd.batch


{-| Map an effect to a sub-module model.
-}
andMapEffect : (effects1 -> effects2) -> (Return (Effects effects1) model1 -> (Return (Effects effects2) (model1 -> model2) -> Return (Effects effects2) model2))
andMapEffect theEffect =
    andMap << mapEffect theEffect


{-| Map a `Return` into a `Return` containing a `Model` function
-}
andMap : Return (Effects e) a -> Return (Effects e) (a -> b) -> Return (Effects e) b
andMap ( model, effects1 ) ( f, effects2 ) =
    ( f model, [ effects1, effects2 ] |> foldl )


{-| Map on the effect.
-}
mapEffect : (a -> b) -> Return (Effects a) model -> Return (Effects b) model
mapEffect f ( model, Effects a ) =
    ( model, a |> List.map f |> Effects )


{-| Map to each of the effects.
-}
listMap : (a -> b) -> Effects a -> Effects b
listMap f (Effects listOfEffects) =
    List.map f listOfEffects
        |> Effects


{-| Reduce a list of Effects from left.
-}
foldl : List (Effects a) -> Effects a
foldl effects =
    effects
        |> List.foldl batch none


{-| A return value in updates involving side-effects.
-}
type alias Return effects model =
    ( model, effects )


{-| Batch together effects.
-}
batch : Effects a -> Effects a -> Effects a
batch (Effects oneListOfEffects) (Effects anotherListOfEffects) =
    Effects (List.append oneListOfEffects anotherListOfEffects)


{-| Add an effects to a return, and the model is not affected.
-}
addEffect : Effects e -> Return (Effects e) model -> Return (Effects e) model
addEffect effectToAdd ( model, theEffect ) =
    ( model, batch theEffect effectToAdd )


{-| Transform the Model of a Returned effects; the effects will be left untouched.
-}
map : (a -> b) -> Return effects a -> Return effects b
map f theTuple =
    theTuple
        |> Tuple.mapFirst f


{-| A null set of effects, so no effects.
-}
none : Effects a
none =
    Effects []


{-| Create a Return from a given model.
-}
singleton : model -> Return (Effects a) model
singleton model =
    ( model, none )
