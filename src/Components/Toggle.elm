module Components.Toggle exposing (Attribute, disabled, error, id, view)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Evt
import Utils


type alias Config msg =
    { error : Bool
    , disabled : Bool
    , attributes : List (Html.Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { error = False
    , disabled = False
    , attributes = []
    }


type Attribute msg
    = Attribute (Config msg -> Config msg)


attribute : Html.Attribute msg -> Attribute msg
attribute attr =
    Attribute <| \c -> { c | attributes = attr :: c.attributes }


id : String -> Attribute msg
id =
    attribute << Attr.id


error : Bool -> Attribute msg
error value =
    Attribute <| \c -> { c | error = value }


disabled : Bool -> Attribute msg
disabled value =
    Attribute <| \c -> { c | disabled = value }


getConfig : List (Attribute msg) -> Config msg
getConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute f) -> f
        , defaultConfig = defaultConfig
        }


view : { checked : Bool, onCheck : Bool -> msg } -> List (Attribute msg) -> Html msg
view flags attrs =
    let
        config =
            getConfig attrs
    in
    span
        [ Attr.class "inline-block w-12"
        , Attr.classList [ ( "cursor-pointer", not config.disabled ) ]
        ]
        [ input
            (List.append
                config.attributes
                [ Attr.type_ "checkbox"
                , Evt.onCheck flags.onCheck
                , Attr.class "hidden"
                , Attr.disabled config.disabled
                ]
            )
            []
        , div
            (List.append
                (if config.disabled then
                    []

                 else
                    [ Evt.onClick <| flags.onCheck (not flags.checked) ]
                )
                [ Attr.class """
                    box-content relative
                    w-full h-6 rounded-full
                    transition-color duration-100
                    """
                , Attr.class <|
                    if config.disabled then
                        "bg-gray-100 border-2 border-gray-200"

                    else if config.error then
                        "bg-rose-700 hover:bg-rose-800"

                    else if flags.checked then
                        "bg-cyan-700 hover:bg-cyan-800"

                    else
                        "bg-gray-300 hover:bg-gray-400"
                ]
            )
            [ span
                [ Attr.class """
                    absolute -translate-y-1/2 top-1/2
                    rounded-full h-4 w-4
                    transition-all ease-out duration-200 
                    """
                , Attr.class <|
                    if config.disabled then
                        "bg-gray-300"

                    else
                        "bg-white shadow"
                , Attr.class <|
                    if flags.checked then
                        "right-1"

                    else
                        "right-7"
                ]
                []
            ]
        ]
