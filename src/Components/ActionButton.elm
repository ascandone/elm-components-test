module Components.ActionButton exposing (Attribute, class, onClick, view)

import FeatherIcons
import Html exposing (..)
import Html.Attributes as A
import Html.Events
import Utils


type alias Config msg =
    { attributes : List (Html.Attribute msg)
    , classNames : List String
    }


defaultConfig : Config msg
defaultConfig =
    { attributes = []
    , classNames = []
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


view : List (Attribute msg) -> FeatherIcons.Icon -> Html msg
view attrs icon =
    let
        config =
            makeConfig attrs
    in
    button
        (List.append
            config.attributes
            [ A.class "hover:bg-slate-100 px-2 py-2 rounded-full" ]
        )
        [ icon
            |> FeatherIcons.withSize 24
            |> FeatherIcons.withClass (String.join " " config.classNames)
            |> FeatherIcons.toHtml []
        ]
