module Section.Toggle exposing
    ( Model
    , Msg
    , get
    , init
    , update
    )

import Components.Label as Label
import Components.Toggle as Toggle
import Html exposing (..)
import Html.Attributes exposing (class)
import Section


type alias Model =
    { flag : Bool
    }


init : Model
init =
    { flag = False
    }


type Msg
    = Checked Bool


update : Msg -> Model -> Model
update msg model =
    case msg of
        Checked b ->
            { model | flag = b }


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Toggle"
        , example = """Toggle.view { checked = model.checked, onCheck = Checked }
    [ Toggle.id "toggle-id" ]

Toggle.view { checked = model.checked, onCheck = Checked }
    [ Toggle.id "toggle-id"
    , Toggle.error True
    ]

Toggle.view { checked = model.checked, onCheck = Checked }
    [ Toggle.id "toggle-id"
    , Toggle.disabled True
    ]
"""
        , children =
            [ let
                bStr =
                    if model.flag then
                        "True"

                    else
                        "False"
              in
              pre [ class "overflow-auto" ]
                [ text ("model.checked = " ++ bStr)
                ]
            , label [ Label.class ]
                [ Toggle.view { checked = model.flag, onCheck = Checked } []
                , text "Regular"
                ]
            , label [ Label.class ]
                [ Toggle.view { checked = model.flag, onCheck = Checked }
                    [ Toggle.error True ]
                , text "Error state"
                ]
            , label [ Label.class ]
                [ Toggle.view { checked = model.flag, onCheck = Checked }
                    [ Toggle.disabled True ]
                , text "Disabled"
                ]
            ]
        }
