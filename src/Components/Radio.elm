module Components.Radio exposing
    ( Attribute
    , id
    , name
    , onInput
    , selectedValue
    , view
    )

import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events
import Maybe.Extra
import Utils


type Attribute msg
    = Attribute (Config msg -> Config msg)


attribute : Html.Attribute msg -> Attribute msg
attribute attr =
    Attribute <| \c -> { c | attributes = attr :: c.attributes }


onInput : (String -> msg) -> Attribute msg
onInput onInput_ =
    Attribute <| \c -> { c | onInput = Just onInput_ }


selectedValue : Maybe String -> Attribute msg
selectedValue value_ =
    Attribute <| \c -> { c | selectedValue = value_ }


id : String -> Attribute msg
id =
    attribute << Attrs.id


name : String -> Attribute msg
name =
    attribute << Attrs.name


type alias Config msg =
    { attributes : List (Html.Attribute msg)
    , selectedValue : Maybe String
    , onInput : Maybe (String -> msg)
    }


defaultConfig : Config msg
defaultConfig =
    { attributes = []
    , selectedValue = Nothing
    , onInput = Nothing
    }


makeConfig : List (Attribute msg) -> Config msg
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute f) -> f
        , defaultConfig = defaultConfig
        }


viewRadio : Config msg -> String -> Html msg
viewRadio config value_ =
    Utils.concatArgs input
        [ config.attributes
        , Maybe.Extra.mapToList Html.Events.onInput config.onInput
        , [ Attrs.class "hidden"
          , Attrs.type_ "radio"
          , Attrs.value value_
          , Attrs.checked (config.selectedValue == Just value_)
          ]
        ]
        []


viewInnerCircle : Bool -> Html msg
viewInnerCircle checked =
    div
        [ Attrs.class "bg-white rounded-full shadow-sm shadow-gray-500"
        , Attrs.class <|
            if checked then
                "w-2 h-2"

            else
                "w-0 h-0"
        ]
        []


viewFakeRadio : Config msg -> String -> Html msg
viewFakeRadio config value_ =
    let
        checked =
            config.selectedValue == Just value_
    in
    Utils.concatArgs button
        [ Maybe.Extra.mapToList (\onInput_ -> Html.Events.onClick (onInput_ value_)) config.onInput
        , [ Attrs.class """
            w-5 h-5 rounded-full box-border shadow-sm
            flex items-center justify-center
            cursor-pointer hover:ring ring-teal-200
        """
          , Attrs.class <|
                if checked then
                    "bg-teal-600"

                else
                    "border border-gray-300 hover:border-teal-500"
          ]
        ]
        [ viewInnerCircle checked
        ]


view : List (Attribute msg) -> String -> Html msg
view attrs value_ =
    let
        config =
            makeConfig attrs
    in
    div []
        [ viewRadio config value_
        , viewFakeRadio config value_
        ]
