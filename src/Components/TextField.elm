module Components.TextField exposing
    ( Attribute
    , actionIcon
    , autofocus
    , disabled
    , icon
    , id
    , onBlur
    , onFocus
    , onInput
    , placeholder
    , validation
    , value
    , view
    )

import Components.ActionButton as ActionButton
import FeatherIcons
import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events
import Utils


type alias Config msg =
    { attributes : List (Html.Attribute msg)
    , validation : String -> Result String ()
    , icon : Maybe (Html msg)
    , disabled : Bool
    , value : String
    }


defaultConfig : Config msg
defaultConfig =
    { attributes = []
    , validation = \_ -> Ok ()
    , icon = Nothing
    , disabled = False
    , value = ""
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


id : String -> Attribute msg
id =
    attribute << Attrs.id


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
value str =
    Attribute <| \c -> { c | value = str }


placeholder : String -> Attribute msg
placeholder =
    attribute << Attrs.placeholder


disabled : Bool -> Attribute msg
disabled b =
    Attribute <| \c -> { c | disabled = b }


autofocus : Bool -> Attribute msg
autofocus =
    attribute << Attrs.autofocus


validation : (String -> Result String x) -> Attribute msg
validation validate =
    Attribute <| \c -> { c | validation = validate >> Result.map (\_ -> ()) }


icon : FeatherIcons.Icon -> Attribute msg
icon icon_ =
    let
        iconHtml =
            FeatherIcons.toHtml [] (FeatherIcons.withSize 20.0 icon_)
    in
    Attribute <| \c -> { c | icon = Just iconHtml }


actionIcon : List (ActionButton.Attribute msg) -> FeatherIcons.Icon -> Attribute msg
actionIcon attrs icon_ =
    Attribute <| \c -> { c | icon = Just (ActionButton.view attrs icon_) }


view : List (Attribute msg) -> Html msg
view attrs =
    let
        config =
            getConfig attrs

        validationResult =
            config.validation config.value
    in
    div []
        [ div
            [ Attrs.class """
                border rounded-md z-0
                focus-within:shadow-md
                flex items-center
            """
            , Attrs.classList [ ( "opacity-70 cursor-not-allowed bg-gray-100", config.disabled ) ]
            , Attrs.class <|
                case validationResult of
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
                outline-none bg-white
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
        , case validationResult of
            Ok () ->
                text ""

            Err errMsg ->
                span [ Attrs.class "text-red-800 text-sm" ] [ text errMsg ]
        ]
