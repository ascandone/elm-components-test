module Components.Button exposing
    ( Attribute
    , Size
    , asAnchor
    , asButton
    , ghost
    , icon
    , lg
    , md
    , onClick
    , outline
    , primary
    , size
    , sm
    )

import FeatherIcons
import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events
import Utils


type alias Config msg =
    { attributes : List (Html.Attribute msg)
    , renderer : List (Html.Attribute msg) -> List (Html msg) -> Html msg
    , size : Size
    , icon : Maybe FeatherIcons.Icon
    }


type Size
    = Sm
    | Md
    | Lg


sm : Size
sm =
    Sm


md : Size
md =
    Md


lg : Size
lg =
    Lg


defaultConfig : Config msg
defaultConfig =
    { attributes = []
    , renderer = button
    , size = Md
    , icon = Nothing
    }


attribute : Html.Attribute msg -> Attribute msg
attribute attr =
    Attribute <| \config -> { config | attributes = attr :: config.attributes }


onClick : msg -> Attribute msg
onClick =
    attribute << Html.Events.onClick


asButton : Attribute msg
asButton =
    Attribute <| \config -> { config | renderer = button }


asAnchor : Attribute msg
asAnchor =
    Attribute <| \config -> { config | renderer = a }


size : Size -> Attribute msg
size size_ =
    Attribute <| \config -> { config | size = size_ }


icon : FeatherIcons.Icon -> Attribute msg
icon value =
    Attribute <| \config -> { config | icon = Just value }


type Attribute msg
    = Attribute (Config msg -> Config msg)


getConfig : List (Attribute msg) -> Config msg
getConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute f) -> f
        , defaultConfig = defaultConfig
        }


type Variant
    = Primary
    | Outline
    | Ghost


view : Variant -> List (Attribute msg) -> String -> Html msg
view variant attrs label =
    let
        config =
            getConfig attrs
    in
    config.renderer
        (List.append
            config.attributes
            [ Attrs.class """
            leading-none tracking-wider
            rounded-full box-content
            disabled:opacity-80
            transition-color duration-200
            relative
            """
            , Attrs.class <|
                case variant of
                    Primary ->
                        "bg-teal-600 hover:bg-teal-700 text-white font-medium "

                    Outline ->
                        "border-2 border-teal-400 hover:border-teal-600 text-teal-700 font-medium "

                    Ghost ->
                        "text-teal-700 uppercase font-semibold tracking-wide"
            , Attrs.class <|
                case config.size of
                    Lg ->
                        "px-5 py-3 min-w-[10rem] text-lg"

                    Md ->
                        "px-4 py-3 min-w-[8rem] text-base"

                    Sm ->
                        "px-3 py-2 text-sm"
            ]
        )
        [ text label
        , case config.icon of
            Nothing ->
                text ""

            Just icon_ ->
                i [ Attrs.class "absolute right-3 -translate-y-1/2 top-1/2 mr-1" ] [ FeatherIcons.toHtml [] icon_ ]
        ]


primary : List (Attribute msg) -> String -> Html msg
primary =
    view Primary


outline : List (Attribute msg) -> String -> Html msg
outline =
    view Outline


ghost : List (Attribute msg) -> String -> Html msg
ghost =
    view Ghost
