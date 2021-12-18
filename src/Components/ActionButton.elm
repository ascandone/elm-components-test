module Components.ActionButton exposing
    ( Attribute
    , Size
    , class
    , filled
    , ghost
    , lg
    , md
    , onClick
    , size
    , sm
    , variant
    , view
    )

import FeatherIcons
import Html exposing (..)
import Html.Attributes as A
import Html.Events
import Utils


type alias Config msg =
    { attributes : List (Html.Attribute msg)
    , classNames : List String
    , size : Size
    , variant : Variant
    }


defaultConfig : Config msg
defaultConfig =
    { attributes = []
    , classNames = []
    , size = Md
    , variant = Ghost
    }


type Attribute msg
    = Attribute (Config msg -> Config msg)


makeConfig : List (Attribute msg) -> Config msg
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute f) -> f
        , defaultConfig = defaultConfig
        }


class : String -> Attribute msg
class value =
    Attribute <| \c -> { c | classNames = value :: c.classNames }


attribute : Html.Attribute msg -> Attribute msg
attribute value =
    Attribute <| \c -> { c | attributes = value :: c.attributes }


onClick : msg -> Attribute msg
onClick =
    attribute << Html.Events.onClick


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


size : Size -> Attribute msg
size value =
    Attribute <| \c -> { c | size = value }


type Variant
    = Ghost
    | Filled


variant : Variant -> Attribute msg
variant value =
    Attribute <| \c -> { c | variant = value }


ghost : Variant
ghost =
    Ghost


filled : Variant
filled =
    Filled


getSize : Size -> Float
getSize size_ =
    case size_ of
        Sm ->
            18

        Md ->
            24

        Lg ->
            32


view : List (Attribute msg) -> FeatherIcons.Icon -> Html msg
view attrs icon =
    let
        config =
            makeConfig attrs
    in
    button
        (List.append
            config.attributes
            [ A.class "rounded-full"
            , A.class <|
                case config.size of
                    Sm ->
                        "p-1"

                    Md ->
                        "p-2"

                    Lg ->
                        "p-3"
            , A.class <|
                case config.variant of
                    Ghost ->
                        "hover:bg-slate-100 "

                    Filled ->
                        "bg-slate-100 hover:bg-slate-900 hover:text-slate-100 transition-color duration-100"
            ]
        )
        [ icon
            |> FeatherIcons.withSize (getSize config.size)
            |> FeatherIcons.withClass (String.join " " config.classNames)
            |> FeatherIcons.toHtml []
        ]
