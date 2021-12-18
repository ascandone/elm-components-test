module Section.Checkbox exposing
    ( Model
    , Msg
    , get
    , init
    , update
    )

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
            { model | flag = model.flag }


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Checkbox"
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
            , div []
                [ Toggle.view { checked = model.flag, onCheck = Checked }
                    [ Toggle.id "flag" ]
                , label [ Html.Attributes.for "flag", class "px-4" ] [ text "checkbox label" ]
                ]
            , div []
                [ Toggle.view { checked = model.flag, onCheck = Checked }
                    [ Toggle.id "flag2", Toggle.error True ]
                , label [ Html.Attributes.for "flag2", class "px-4" ] [ text "checkbox label" ]
                ]
            , div []
                [ Toggle.view { checked = model.flag, onCheck = Checked }
                    [ Toggle.id "flag3", Toggle.disabled True ]
                , label [ Html.Attributes.for "flag3", class "px-4" ] [ text "checkbox label" ]
                ]
            ]
        }
