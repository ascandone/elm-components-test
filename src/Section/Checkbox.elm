module Section.Checkbox exposing
    ( Model
    , Msg
    , get
    , init
    , update
    )

import Components.Checkbox as Checkbox
import Html exposing (..)
import Section


type alias Model =
    { checked : Bool
    }


init : Model
init =
    { checked = False
    }


type Msg
    = Checked Bool


update : Msg -> Model -> Model
update msg model =
    case msg of
        Checked b ->
            { model | checked = b }


view : Model -> List (Html Msg)
view model =
    [ Checkbox.view []
    , Checkbox.view [ Checkbox.checked True ]
    , Checkbox.view [ Checkbox.checked False ]
    ]


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Checkbox"
        , example = "TODO"
        , children = view model
        }
