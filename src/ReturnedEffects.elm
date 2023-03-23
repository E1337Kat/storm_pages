module ReturnedEffects exposing
    ( Return
    , Effects(..)
    , map
    , return
    , performEffects
    , foldl
    , listMap
    , addEffect
    , addEffectIf
    , subModuleUpdate
    , andMapEffect
    , singleton
    , mapWith
    , maybeEffects
    , andThen
    , none
    , build
    )

{-| Helper functionality for effects, analogous to elm-return's types and functions.


# Types

@docs Return
@docs Effects


# Helper Functions

@docs map
@docs return
@docs performEffects
@docs foldl
@docs listMap
@docs addEffect
@docs addEffectIf
@docs subModuleUpdate
@docs andMapEffect
@docs singleton
@docs mapWith
@docs maybeEffects
@docs andThen
@docs none
@docs build

-}

import Ellie.Util exposing (condMap)
import Maybe.Extra exposing (unwrap)


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


{-| Apply a function to the model and possibly add an effect.
In other words, first parameter is a function that takes a
model and returns a tuple of ( model, effect )
-}
andThen : (a -> Return (Effects c) b) -> Return (Effects c) a -> Return (Effects c) b
andThen f ( model, effects ) =
    let
        ( updatedModel, newEffect ) =
            model |> f
    in
    ( updatedModel, batch effects newEffect )


{-| Create a Return from model and effects, analogous to Return's return.
-}
return : model -> Effects a -> Return (Effects a) model
return model (Effects effects) =
    ( model, Effects effects )


{-| Add an effects to a return, and the model is not affected.
-}
addEffect : Effects e -> Return (Effects e) model -> Return (Effects e) model
addEffect effectToAdd ( model, theEffect ) =
    ( model, batch theEffect effectToAdd )


{-| Add an effects to a return, but the model is not affected if a condition is meet.
-}
addEffectIf : Bool -> Effects e -> Return (Effects e) model -> Return (Effects e) model
addEffectIf bool effectToAdd =
    condMap
        bool
        (\() -> addEffect effectToAdd)


{-| A general function for updating effects from sub-modules.
-}
subModuleUpdate :
    subModuleMsgParameter
    -> (subModuleEffect -> e)
    -> subModuleModelType
    -> (Maybe subModuleMsgType -> subModuleModelType -> Return (Effects subModuleEffect) subModuleModelType)
    -> (subModuleModelType -> modelType -> modelType)
    -> (subModuleMsgParameter -> subModuleMsgType)
    -> Return (Effects e) modelType
    -> Return (Effects e) modelType
subModuleUpdate subModuleMsg subModuleEffectMapper subModuleModel subModuleUpdateFunction updateModelWithSubModuleModel typeConstructor return_ =
    let
        ( updatedSubModuleModel, updatedSubModuleEffect ) =
            subModuleUpdateFunction (Just (typeConstructor subModuleMsg)) subModuleModel
    in
    return_
        |> map (updateModelWithSubModuleModel updatedSubModuleModel)
        |> addEffect (listMap subModuleEffectMapper updatedSubModuleEffect)


{-| Transform the Model of a Returned effects; the effects will be left untouched.
-}
map : (a -> b) -> Return effects a -> Return effects b
map f theTuple =
    theTuple
        |> Tuple.mapFirst f


{-| Transform the Model of and add a new effects to the queue
-}
mapWith : (a -> b) -> Effects c -> Return (Effects c) a -> Return (Effects c) b
mapWith f newEffect ( model, existingEffect ) =
    ( model |> f, batch existingEffect newEffect )


{-| If the given item is something, call the function mapping it to an effect. Otherwise, return no effects.
-}
maybeEffects : (a -> Effects b) -> Maybe a -> Effects b
maybeEffects f =
    unwrap none f


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
