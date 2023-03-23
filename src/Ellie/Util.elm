module Ellie.Util exposing
    ( msgToCmd
    , condMap
    , flip
    )

{-| This library provides some common utility functions used throughout the app.


# Elm Architecture

@docs msgToCmd


# Mapping Helpers

@docs condMap


# Miscellaneous

@docs flip

-}

-- import Json.Encode exposing (Value, object)
-- import Time exposing (Posix)
-- import Json.Decode as Decode exposing (Decoder)

import Task


{-| Take a function, the first argument, and return a new function that accepts the same parameters as the original function, but in reverse order.
-}
flip : (a -> b -> c) -> b -> a -> c
flip function argB argA =
    function argA argB


{-| Apply a mapper if the conditional is true.

The mapper is applied lazily, so as not to evaluate it too early.

-}
condMap : Bool -> (() -> (a -> a)) -> a -> a
condMap conditional f =
    if conditional then
        f ()

    else
        identity


{-| Convert a message into a command.

    -- Basically syntactic sugar for
        Task.succeed |> Task.perform identity

-}
msgToCmd : msg -> Cmd msg
msgToCmd message =
    message
        |> Task.succeed
        |> Task.perform identity



-- {-| Apply the mapper function to the given values, if both are present.
-- E.g. the below sets the audio and video values only if they are present.
--             defaultStream
--                 |> assignTokBoxStreamId (Just streamId)
--                 |> maybeMap maybeHasAudio maybeHasVideo setStreamHasAudioAndVideo
-- -}
-- maybeMap2 : Maybe a -> Maybe b -> (a -> b -> c -> c) -> c -> c
-- maybeMap2 maybeItemOne maybeItemTwo mapper mappee =
--     case ( maybeItemOne, maybeItemTwo ) of
--         ( Just one, Just two ) ->
--             mapper one two mappee
--         _ ->
--             mappee
-- {-| Determine whether the given time is within the given time range of the the given current time.
-- -}
-- timeWithin : Int -> Maybe Posix -> Maybe Posix -> Bool
-- timeWithin timeRangeMilliseconds maybeCurrentTime maybeComparisonTime =
--     let
--         timeInRange : Posix -> Posix -> Bool
--         timeInRange currentTime comparisonTime =
--             abs (Time.posixToMillis currentTime - Time.posixToMillis comparisonTime) < timeRangeMilliseconds
--     in
--     Maybe.map2 timeInRange maybeCurrentTime maybeComparisonTime
--         |> Maybe.withDefault False
-- {-| Turn a list of words into a sentence.
--     toSentence [ "apple", "orange", "grape" ] -- "apple, orange, and grape"
-- -}
-- toSentence : List String -> String
-- toSentence words =
--     case words of
--         [] ->
--             ""
--         [ one ] ->
--             one
--         [ one, another ] ->
--             one ++ " and " ++ another
--         _ ->
--             let
--                 commafied : String -> String -> String
--                 commafied oneWord anotherWord =
--                     oneWord ++ ", " ++ anotherWord
--                 reversed : List String
--                 reversed =
--                     List.reverse words
--                 lastWord : String
--                 lastWord =
--                     List.head reversed |> Maybe.withDefault ""
--                 remainder : List String
--                 remainder =
--                     List.tail reversed |> Maybe.withDefault []
--             in
--             List.foldl commafied "" remainder
--                 ++ "and "
--                 ++ lastWord
-- {-| Get a list of tuples of every five minutes of the day.
--     everyFiveMinutesOfDay -- [("00:00:00","12:00 am"),("00:05:00","12:05 am"), ...
-- -}
-- everyFiveMinutesOfDay : List ( String, String )
-- everyFiveMinutesOfDay =
--     let
--         minutesIncrement : Int
--         minutesIncrement =
--             5
--         amOrPm : Int -> String
--         amOrPm minutes =
--             if minutes < (12 * 60) then
--                 "am"
--             else
--                 "pm"
--         twentyFourHour : Int -> Int
--         twentyFourHour minutes =
--             floor (toFloat minutes / 60)
--         twelveHourHour : Int -> Int
--         twelveHourHour minutes =
--             let
--                 baseHour : Int
--                 baseHour =
--                     minutes
--                         |> twentyFourHour
--                         |> modBy 12
--             in
--             case baseHour of
--                 0 ->
--                     12
--                 _ ->
--                     baseHour
--         hourMinutes : Int -> Int
--         hourMinutes minutes =
--             modBy 60 minutes
--         -- Of form "13:05:00" for 1:05pm
--         valueText : Int -> String
--         valueText minutes =
--             [ minutes |> twentyFourHour |> String.fromInt |> String.padLeft 2 '0'
--             , ":"
--             , minutes |> hourMinutes |> String.fromInt |> String.padLeft 2 '0'
--             , ":00"
--             ]
--                 |> List.foldr (++) ""
--         -- Human readable text for time, like "1:05pm"
--         displayText : Int -> String
--         displayText minutes =
--             [ minutes |> twelveHourHour |> String.fromInt
--             , ":"
--             , minutes |> hourMinutes |> String.fromInt |> String.padLeft 2 '0'
--             , " "
--             , minutes |> amOrPm
--             ]
--                 |> List.foldr (++) ""
--     in
--     List.range 0 (floor (toFloat ((24 * 60) - minutesIncrement) / toFloat minutesIncrement))
--         |> List.map (\n -> n * minutesIncrement)
--         |> List.map (\n -> ( valueText n, displayText n ))
-- {-| Remove non-numbers from a string, as in phone input validation.
--     removeNonNumbers "(423) 555-6666" -- "4235556666"
-- -}
-- removeNonNumbers : String -> String
-- removeNonNumbers originalText =
--     case Regex.fromString "[^0-9]" of
--         Nothing ->
--             originalText
--         Just regex ->
--             Regex.replace regex (always "") originalText
-- {-| Join messages together, mostly used for error validation messages.
--     joinedMessages [ "one message", "another message" ] -- " one message another message"
-- -}
-- joinedMessages : List String -> String
-- joinedMessages messages =
--     let
--         combineMessages : String -> String -> String
--         combineMessages message priorMessage =
--             priorMessage ++ " " ++ message
--     in
--     List.foldl combineMessages "" messages
-- {-| Determine whether the given SMS number is valid.
--     smsValidation "(423) 555 -" -- (False,["SMS phone number needs to be 10 digits long."])
-- -}
-- smsValidation : String -> ( Bool, List String )
-- smsValidation smsNumber =
--     if
--         smsNumber
--             |> removeNonNumbers
--             |> String.trim
--             |> (\sms -> List.member (String.length sms) (List.range 1 9))
--     then
--         ( False, [ "SMS phone number needs to be 10 digits long." ] )
--     else
--         ( True, [] )
-- {-| Determine whether the given email is valid.
--     emailValidation "bob,smith@example.com" -- (False,["Email cannot contain a comma."])
-- -}
-- emailValidation : String -> ( Bool, List String )
-- emailValidation email =
--     let
--         trimmedEmail : String
--         trimmedEmail =
--             String.trim email
--         makeValidation : (String -> Bool) -> String -> ( Bool, List String ) -> ( Bool, List String )
--         makeValidation f message ( valid, messages ) =
--             if f trimmedEmail then
--                 ( False, message :: messages )
--             else
--                 ( valid, messages )
--         commaValidation : ( Bool, List String ) -> ( Bool, List String )
--         commaValidation =
--             makeValidation (String.contains ",") "Email cannot contain a comma."
--         spaceValidation : ( Bool, List String ) -> ( Bool, List String )
--         spaceValidation =
--             makeValidation (String.contains " ") "Email cannot contain a space."
--         atSignValidation : ( Bool, List String ) -> ( Bool, List String )
--         atSignValidation =
--             makeValidation (\email_ -> (0 < String.length email_) && not (String.contains "@" email_)) "Email missing \"@\""
--     in
--     ( True, [] )
--         |> commaValidation
--         |> spaceValidation
--         |> atSignValidation
-- {-| Decode a JSON string value and pass the successful result to the given function.
-- -}
-- decodeStringAndThen : (String -> a) -> Decoder a
-- decodeStringAndThen f =
--     Decode.string |> Decode.andThen (f >> Decode.succeed)
