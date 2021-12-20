module Components.Radio exposing
    ( Attribute
    , generic
    , id
    , name
    , onInput
    , selectedValue
    , string
    )

import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events
import Maybe.Extra
import Utils


type Attribute msg value
    = Attribute (Config msg value -> Config msg value)


attribute : Html.Attribute msg -> Attribute msg value
attribute attr =
    Attribute <| \c -> { c | attributes = attr :: c.attributes }


onInput : (value -> msg) -> Attribute msg value
onInput onInput_ =
    Attribute <| \c -> { c | onInput = Just onInput_ }


selectedValue : Maybe value -> Attribute msg value
selectedValue value_ =
    Attribute <| \c -> { c | selectedValue = value_ }


id : String -> Attribute msg value
id =
    attribute << Attrs.id


name : String -> Attribute msg value
name =
    attribute << Attrs.name


type alias Config msg value =
    { attributes : List (Html.Attribute msg)
    , selectedValue : Maybe value
    , onInput : Maybe (value -> msg)
    }


defaultConfig : Config msg value
defaultConfig =
    { attributes = []
    , selectedValue = Nothing
    , onInput = Nothing
    }


makeConfig : List (Attribute msg value) -> Config msg value
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute f) -> f
        , defaultConfig = defaultConfig
        }


viewRadio : Config msg value -> ( String, value ) -> Html msg
viewRadio config ( strValue_, value_ ) =
    let
        mapOnInput onInput_ =
            Html.Events.onInput (\_ -> onInput_ value_)
    in
    Utils.concatArgs input
        [ config.attributes
        , Maybe.Extra.mapToList mapOnInput config.onInput
        , [ Attrs.class "hidden"
          , Attrs.type_ "radio"
          , Attrs.value strValue_
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
                "w-2 h-2 transition-all duration-200 ease-out"

            else
                "w-0 h-0"
        ]
        []


viewFakeRadio : Config msg value -> ( String, value ) -> Html msg
viewFakeRadio config ( _, value_ ) =
    let
        checked =
            config.selectedValue == Just value_

        mapOnInput onInput_ =
            Html.Events.onClick (onInput_ value_)
    in
    Utils.concatArgs button
        [ Maybe.Extra.mapToList mapOnInput config.onInput
        , [ Attrs.class """
            w-5 h-5 rounded-full box-border shadow-sm
            flex items-center justify-center
            cursor-pointer hover:ring group-hover:ring ring-teal-200
            transition-color duration-100 ease-out
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


generic : List (Attribute msg value) -> ( String, value ) -> Html msg
generic attrs pair =
    let
        config =
            makeConfig attrs
    in
    div []
        [ viewRadio config pair
        , viewFakeRadio config pair
        ]


string : List (Attribute msg String) -> String -> Html msg
string attrs value_ =
    generic attrs ( value_, value_ )
