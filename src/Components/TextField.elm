module Components.TextField exposing
    ( Attribute
    , autofocus
    , disabled
    , onBlur
    , onFocus
    , onInput
    , placeholder
    , validation
    , value
    , view
    )

import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events
import Utils


type alias Config msg =
    { attributes : List (Html.Attribute msg)
    , validation : Result String ()
    }


defaultConfig : Config msg
defaultConfig =
    { attributes = []
    , validation = Ok ()
    }


getConfig : List (Attribute msg) -> Config msg
getConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute f) -> f
        , defaultConfig = defaultConfig
        }


type Attribute msg
    = Attribute (Config msg -> Config msg)


attribute : Html.Attribute msg -> Attribute msg
attribute attr =
    Attribute <| \c -> { c | attributes = attr :: c.attributes }


onInput : (String -> msg) -> Attribute msg
onInput =
    attribute << Html.Events.onInput


onFocus : msg -> Attribute msg
onFocus =
    attribute << Html.Events.onFocus


onBlur : msg -> Attribute msg
onBlur =
    attribute << Html.Events.onBlur


value : String -> Attribute msg
value =
    attribute << Attrs.value


placeholder : String -> Attribute msg
placeholder =
    attribute << Attrs.placeholder


disabled : Bool -> Attribute msg
disabled =
    attribute << Attrs.disabled


autofocus : Bool -> Attribute msg
autofocus =
    attribute << Attrs.autofocus


validation : Result String x -> Attribute msg
validation result =
    Attribute <| \c -> { c | validation = result |> Result.map (\_ -> ()) }


view : List (Attribute msg) -> Html msg
view attrs =
    let
        config =
            getConfig attrs
    in
    div [ Attrs.class "w-64" ]
        [ input
            (List.append config.attributes
                [ Attrs.type_ "text"
                , Attrs.class """
                leading-none
                placeholder:font-light
                px-4 py-4 border rounded-md
                min-w-full
                outline-none focus:shadow-md
                z-0
                disabled:opacity-70 disabled:cursor-not-allowed disabled:bg-gray-100
                """
                , Attrs.class <|
                    case config.validation of
                        Ok () ->
                            "text-teal-900 border-teal-300 focus:border-teal-500 placeholder:text-teal-500"

                        Err _ ->
                            "text-red-800 border-red-500 placeholder:text-red-300"
                ]
            )
            []
        , case config.validation of
            Ok () ->
                text ""

            Err errMsg ->
                span [ Attrs.class "text-red-800 text-sm" ] [ text errMsg ]
        ]
