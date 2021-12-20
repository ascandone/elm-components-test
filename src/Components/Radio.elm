module Components.Radio exposing
    ( Attribute
    , checked
    , id
    , value
    , view
    )

import Html exposing (..)
import Html.Attributes as Attrs
import Utils


type Attribute msg
    = Attribute (Config msg -> Config msg)


attribute : Html.Attribute msg -> Attribute msg
attribute attr =
    Attribute <| \c -> { c | attributes = attr :: c.attributes }


value : String -> Attribute msg
value =
    attribute << Attrs.value


id : String -> Attribute msg
id =
    attribute << Attrs.id


checked : Bool -> Attribute msg
checked b =
    Attribute <| \c -> { c | checked = b }


type alias Config msg =
    { attributes : List (Html.Attribute msg)
    , checked : Bool
    }


defaultConfig : Config msg
defaultConfig =
    { attributes = []
    , checked = False
    }


makeConfig : List (Attribute msg) -> Config msg
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute f) -> f
        , defaultConfig = defaultConfig
        }


viewRadio : Config msg -> Html msg
viewRadio config =
    Utils.concatArgs input
        [ config.attributes
        , [ Attrs.checked config.checked
          , Attrs.class "hidden"
          , Attrs.type_ "radio"
          ]
        ]
        []


viewFakeRadio : Config msg -> Html msg
viewFakeRadio config =
    button
        [ Attrs.class """
            w-5 h-5 rounded-full box-border shadow-sm
            flex items-center justify-center cursor-pointer
        """
        , Attrs.class <|
            if config.checked then
                "bg-teal-600"

            else
                "border border-gray-200"
        ]
        [ div
            [ Attrs.class " bg-white rounded-full shadow-sm shadow-gray-500"
            , Attrs.class <|
                if config.checked then
                    "w-2 h-2"

                else
                    "w-0 h-0"
            ]
            []
        ]


view : List (Attribute msg) -> Html msg
view attrs =
    let
        config =
            makeConfig attrs
    in
    div []
        [ viewRadio config
        , viewFakeRadio config
        ]
