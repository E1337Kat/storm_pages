module ReviewConfig exposing (config)

{-| Do not rename the ReviewConfig module or the config function, because
`elm-review` will look for these.

To add packages that contain rules, add them to this review project using

    `elm install author/packagename`

when inside the directory containing this file.

-}

import CognitiveComplexity
import Docs.NoMissing exposing (allModules, onlyExposed)
import Docs.ReviewAtDocs
import Docs.ReviewLinksAndSections
import Docs.UpToDateReadmeLinks
import NoDebug.Log
import NoDebug.TodoOrToString
import NoDeprecated
import NoDuplicatePorts
import NoEmptyText
import NoExposingEverything
import NoFloatIds
import NoImportingEverything
import NoInconsistentAliases
import NoLongImportLines
import NoMissingDocumentation
import NoMissingSubscriptionsCall
import NoMissingTypeAnnotation
import NoMissingTypeAnnotationInLetIn
import NoMissingTypeConstructor
import NoMissingTypeExpose
import NoModuleOnExposedNames
import NoPrematureLetComputation
import NoPrimitiveTypeAlias
import NoRecursiveUpdate
import NoRedundantConcat
import NoRedundantCons
import NoSinglePatternCase
import NoTypeAliasConstructorCall
import NoUnmatchedUnit
import NoUnoptimizedRecursion
import NoUnused.CustomTypeConstructorArgs
import NoUnused.CustomTypeConstructors
import NoUnused.Dependencies
import NoUnused.Exports
import NoUnused.Modules
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import NoUnusedPorts
import NoUselessSubscriptions
import Review.Rule exposing (Rule)
import ReviewPipelineStyles
    exposing
        ( andCallThem
        , andTryToFixThemBy
        , exceptThoseThat
        , forbid
        , leftCompositionPipelines
        , leftPizzaPipelines
        , parentheticalApplicationPipelines
        , that
        )
import ReviewPipelineStyles.Fixes
    exposing
        ( convertingToRightComposition
        , convertingToRightPizza
        , makingSingleLine
        )
import ReviewPipelineStyles.Predicates
    exposing
        ( aDataStructure
        , aFlowControlStructure
        , aLambdaFunction
        , aLetBlock
        , aSemanticallyInfixFunction
        , and
        , doNot
        , haveAParentNotSeparatedBy
        , haveAnyNonInputStepThatIs
        , haveFewerStepsThan
        , haveMoreStepsThan
        , separateATestFromItsLambda
        , spanMultipleLines
        )
import Simplify
import UseCamelCase


config : List Rule
config =
    let
        noMultilineLeftPizza =
            [ forbid leftPizzaPipelines
                |> that
                    (spanMultipleLines
                        |> and (haveMoreStepsThan 1)
                    )
                |> andTryToFixThemBy convertingToRightPizza
                |> andCallThem "multiline <| pipeline with several steps"
            , forbid leftPizzaPipelines
                |> that
                    (spanMultipleLines
                        |> and (haveFewerStepsThan 1)
                    )
                |> exceptThoseThat separateATestFromItsLambda
                |> andTryToFixThemBy makingSingleLine
                |> andCallThem "multiline <| pipeline with one step"
            ]

        noSemanticallyInfixFunctionsInLeftPipelines =
            [ forbid leftPizzaPipelines
                |> that (haveAnyNonInputStepThatIs aSemanticallyInfixFunction)
                |> andTryToFixThemBy convertingToRightPizza
                |> andCallThem "<| pipeline with a semantically-infix function"
            , forbid leftCompositionPipelines
                |> that (haveAnyNonInputStepThatIs aSemanticallyInfixFunction)
                |> andTryToFixThemBy convertingToRightComposition
                |> andCallThem "<< pipeline with a semantically-infix function"
            ]
    in
    [ CognitiveComplexity.rule 15 |> Review.Rule.ignoreErrorsForDirectories [ "tests/" ]
    , Docs.NoMissing.rule
        { document = onlyExposed
        , from = allModules
        }
        |> Review.Rule.ignoreErrorsForDirectories [ "tests/" ]
    , Docs.ReviewLinksAndSections.rule
    , Docs.ReviewAtDocs.rule
    , Docs.UpToDateReadmeLinks.rule
    , NoDebug.Log.rule
    , NoDebug.TodoOrToString.rule
    , NoDeprecated.rule NoDeprecated.defaults
    , NoEmptyText.rule
    , NoExposingEverything.rule
    , NoFloatIds.rule
    , NoImportingEverything.rule []
    , NoInconsistentAliases.config
        [ ( "Html.Attributes", "Attr" )
        , ( "Json.Decode", "Decode" )
        , ( "Json.Encode", "Encode" )
        ]
        |> NoInconsistentAliases.noMissingAliases
        |> NoInconsistentAliases.rule
    , NoLongImportLines.rule
    , NoMissingDocumentation.rule |> Review.Rule.ignoreErrorsForDirectories [ "tests/" ]
    , NoMissingSubscriptionsCall.rule |> Review.Rule.ignoreErrorsForDirectories [ "tests/" ]
    , NoMissingTypeAnnotation.rule
    , NoMissingTypeAnnotationInLetIn.rule |> Review.Rule.ignoreErrorsForDirectories [ "tests/" ]
    , NoMissingTypeConstructor.rule
    , NoMissingTypeExpose.rule
    , NoModuleOnExposedNames.rule
    , NoPrematureLetComputation.rule
    , NoPrimitiveTypeAlias.rule
    , NoRecursiveUpdate.rule
    , NoRedundantConcat.rule
    , NoRedundantCons.rule
    , NoSinglePatternCase.rule NoSinglePatternCase.fixInArgument
    , NoTypeAliasConstructorCall.rule
    , NoUnmatchedUnit.rule |> Review.Rule.ignoreErrorsForDirectories [ "tests/" ]
    , NoUnused.CustomTypeConstructorArgs.rule |> Review.Rule.ignoreErrorsForDirectories [ "tests/" ]
    , NoUnused.CustomTypeConstructors.rule []
    , NoUnused.Exports.rule
    , NoUnused.Dependencies.rule
    , NoUnused.Modules.rule
    , NoUnused.Parameters.rule
    , NoUnoptimizedRecursion.rule (NoUnoptimizedRecursion.optOutWithComment "IGNORE TCO")
    , NoUnused.Patterns.rule
    , NoUnused.Variables.rule
    , NoUselessSubscriptions.rule
    , ReviewPipelineStyles.rule
        (noMultilineLeftPizza
            ++ noSemanticallyInfixFunctionsInLeftPipelines
        )
        |> Review.Rule.ignoreErrorsForDirectories [ "tests/" ]
    , Simplify.rule Simplify.defaults
    , UseCamelCase.rule UseCamelCase.default
    , NoDuplicatePorts.rule
    , NoUnusedPorts.rule
    ]
        |> List.map (\r -> Review.Rule.ignoreErrorsForDirectories [ "src/WeCounsel/API/GraphQL", "src/MessageHub/API/GraphQL" ] r)
