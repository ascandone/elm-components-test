module Components.TextField exposing
    ( Attribute
    , autofocus
    , disabled
    , icon
    , onBlur
    , onFocus
    , onInput
    , placeholder
    , validation
    , value
    , view
    )

import FeatherIcons
import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events
import Utils


type alias Config msg =
    { attributes : List (Html.Attribute msg)
    , validation : Result String ()
    , icon : Maybe (Html msg)
    , disabled : Bool
    }


defaultConfig : Config msg
defaultConfig =
    { attributes = []
    , validation = Ok ()
    , icon = Nothing
    , disabled = False
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
disabled b =
    Attribute <| \c -> { c | disabled = b }


autofocus : Bool -> Attribute msg
autofocus =
    attribute << Attrs.autofocus


validation : Result String x -> Attribute msg
validation result =
    Attribute <| \c -> { c | validation = result |> Result.map (\_ -> ()) }


icon : FeatherIcons.Icon -> Attribute msg
icon icon_ =
    let
        iconHtml =
            FeatherIcons.toHtml [] (FeatherIcons.withSize 20.0 icon_)
    in
    Attribute <| \c -> { c | icon = Just iconHtml }


view : List (Attribute msg) -> Html msg
view attrs =
    let
        config =
            getConfig attrs
    in
    div []
        [ div
            [ Attrs.class """
                w-64 border rounded-md z-0
                focus-within:shadow-md
                flex items-center
            """
            , Attrs.classList [ ( "opacity-70 cursor-not-allowed bg-gray-100", config.disabled ) ]
            , Attrs.class <|
                case config.validation of
                    Ok () ->
                        "text-teal-900 border-teal-300 focus-within:border-teal-500 placeholder:text-teal-500"

                    Err _ ->
                        "text-red-800 border-red-500 placeholder:text-red-300"
            ]
            [ input
                (List.append config.attributes
                    [ Attrs.type_ "text"
                    , Attrs.class """
                leading-none placeholder:font-light
                px-4 py-4 w-full h-full rounded-md
                outline-none bg-transparent
                """
                    , Attrs.disabled config.disabled
                    ]
                )
                []
            , case config.icon of
                Nothing ->
                    text ""

                Just html ->
                    span [ Attrs.class "mr-2 " ]
                        [ html ]
            ]
        , case config.validation of
            Ok () ->
                text ""

            Err errMsg ->
                span [ Attrs.class "text-red-800 text-sm" ] [ text errMsg ]
        ]
