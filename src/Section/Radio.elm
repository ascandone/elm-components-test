module Section.Radio exposing
    ( Model
    , Msg
    , get
    , init
    , update
    )

import Components.Button as Button
import Components.Label as Label
import Components.Radio as Radio
import Html exposing (..)
import Html.Attributes exposing (class)
import Section


type Option
    = A
    | B


optionToString : Option -> String
optionToString opt =
    case opt of
        A ->
            "Option.A"

        B ->
            "Option.B"


type alias Model =
    { value : Maybe Option
    }


init : Model
init =
    { value = Nothing
    }


type Msg
    = Reset
    | Input Option


update : Msg -> Model -> Model
update msg model =
    case msg of
        Reset ->
            init

        Input opt ->
            { model | value = Just opt }


view : Model -> List (Html Msg)
view model =
    [ pre []
        [ model.value
            |> Maybe.map optionToString
            |> Maybe.withDefault "(no option selected)"
            |> text
        ]
    , div [ class "space-y-3" ]
        [ Button.ghost [ Button.size Button.sm, Button.onClick Reset ] "Reset"
        , label
            [ Label.class
            , Html.Attributes.for "option-1"
            , class "group"
            ]
            [ Radio.generic
                [ Radio.onInput Input
                , Radio.selectedValue model.value
                , Radio.id "option-1"
                ]
                ( "value-1", A )
            , text "First option"
            ]
        , label [ Label.class, Html.Attributes.for "option-2", class "group" ]
            [ Radio.generic
                [ Radio.onInput Input
                , Radio.selectedValue model.value
                , Radio.id "option-2"
                ]
                ( "value-2", B )
            , text "Second option"
            ]
        ]
    ]


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Radio"
        , example = """Radio.generic
    [ Radio.selectedValue model.value
    , Radio.onInput Input
    ]
    ( "option-a", Option.A )

Radio.generic
    [ Radio.selectedValue model.value
    , Radio.onInput Input
    ]
    ( "option-v", Option.B )
"""
        , children = view model
        }
