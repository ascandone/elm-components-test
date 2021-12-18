module Components.ActionButton exposing (Attribute, Size, class, filled, ghost, lg, md, onClick, size, sm)

import FeatherIcons
import Html exposing (..)
import Html.Attributes as A
import Html.Events
import Utils


type alias Config msg =
    { attributes : List (Html.Attribute msg)
    , classNames : List String
    , size : Size
    }


defaultConfig : Config msg
defaultConfig =
    { attributes = []
    , classNames = []
    , size = Md
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


getSize : Size -> Float
getSize size_ =
    case size_ of
        Sm ->
            16

        Md ->
            24

        Lg ->
            32


view : Variant -> List (Attribute msg) -> FeatherIcons.Icon -> Html msg
view variant attrs icon =
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
                case variant of
                    Ghost ->
                        "hover:bg-slate-100 "

                    Filled ->
                        "bg-slate-100"
            ]
        )
        [ icon
            |> FeatherIcons.withSize (getSize config.size)
            |> FeatherIcons.withClass (String.join " " config.classNames)
            |> FeatherIcons.toHtml []
        ]


ghost : List (Attribute msg) -> FeatherIcons.Icon -> Html msg
ghost =
    view Ghost


filled : List (Attribute msg) -> FeatherIcons.Icon -> Html msg
filled =
    view Filled
