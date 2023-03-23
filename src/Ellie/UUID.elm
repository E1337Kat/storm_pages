module Ellie.UUID exposing
    ( UUID
    , UUIDWithSeeds
    , next
    , step
    , toString
    )

{-| Create UUIDs


# Types

@docs UUID
@docs UUIDWithSeeds


# Helper Methods

@docs next
@docs step
@docs toString

-}

-- import Random exposing (initialSeed)

import UUID exposing (Seeds)


{-| Alias the UUID type itself
-}
type alias UUID =
    UUID.UUID


{-| Seeds to be used with UUID-generation.
-}
type UUIDWithSeeds
    = UUIDWithSeeds ( UUID, Seeds )


{-| Represent a UUID as a string.
-}
toString : UUIDWithSeeds -> String
toString (UUIDWithSeeds ( uuid, _ )) =
    UUID.toString uuid


{-| Get the next UUID and seeds.
-}
next : UUIDWithSeeds -> UUIDWithSeeds
next (UUIDWithSeeds ( _, seeds )) =
    seeds
        |> UUID.step
        |> UUIDWithSeeds


{-| Get the next UUID and seeds.
-}
step : UUIDWithSeeds -> ( UUIDWithSeeds, UUIDWithSeeds )
step ((UUIDWithSeeds ( _, seeds )) as original) =
    seeds
        |> UUID.step
        |> UUIDWithSeeds
        |> Tuple.pair original



-- {-| Get the initial flag seeds.
-- -}
-- initialUUIDSeeds : FlagSeeds -> UUIDWithSeeds
-- initialUUIDSeeds seeds =
--     let
--         firstSeeds : FlagSeeds -> Seeds
--         firstSeeds { seed1, seed2, seed3, seed4 } =
--             Seeds (initialSeed seed1) (initialSeed seed2) (initialSeed seed3) (initialSeed seed4)
--     in
--     seeds
--         |> firstSeeds
--         |> UUID.step
--         |> UUIDWithSeeds
