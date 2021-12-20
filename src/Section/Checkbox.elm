module Section.Checkbox exposing
    ( Model
    , Msg
    , get
    , init
    , update
    )

import Components.Checkbox as Checkbox
import Components.Label as Label
import Html exposing (..)
import Html.Attributes exposing (class)
import Section


type alias Model =
    { check1 : Maybe Bool
    , check2 : Bool
    , check3 : Bool
    }


init : Model
init =
    { check1 = Nothing
    , check2 = False
    , check3 = True
    }


type Msg
    = Checked1 Bool
    | Checked2 Bool
    | Checked3 Bool


update : Msg -> Model -> Model
update msg model =
    case msg of
        Checked1 b ->
            { model | check1 = Just b }

        Checked2 b ->
            { model | check2 = b }

        Checked3 b ->
            { model | check3 = b }


view : Model -> List (Html Msg)
view model =
    [ label [ Label.class, Html.Attributes.for "check-1" ]
        [ Checkbox.view
            [ Checkbox.id "check-1"
            , Checkbox.onCheck Checked1
            , Checkbox.checkedMaybe model.check1
            ]
        , text "Indeterminate"
        ]
    , label [ Label.class, Html.Attributes.for "check-2" ]
        [ Checkbox.view
            [ Checkbox.checked model.check2
            , Checkbox.onCheck Checked2
            , Checkbox.id "check-2"
            ]
        , text "Unchecked"
        ]
    , label [ Label.class, Html.Attributes.for "check-3" ]
        [ Checkbox.view
            [ Checkbox.id "check-3"
            , Checkbox.checked model.check3
            , Checkbox.onCheck Checked3
            , Checkbox.id "check-3"
            ]
        , text "Checked"
        ]
    ]


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Checkbox"
        , example = """--indeterminate
Checkbox.view
    [ Checkbox.checkedMaybe Nothing
    , Checkbox.onCheck Checked
    ]

Checkbox.view
    [ Checkbox.checked True
    , Checkbox.onCheck Checked
    ]

Checkbox.view
    [ Checkbox.checked False
    , Checkbox.onCheck Checked
    ]
"""
        , children = view model
        }
