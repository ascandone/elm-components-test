module Section.Switch exposing
    ( Model
    , Msg
    , get
    , init
    , update
    )

import Components.Switch as Switch
import Html exposing (..)
import Html.Attributes exposing (class)
import Section


type alias Model =
    { selectedValue : Int
    }


init : Model
init =
    { selectedValue = 0
    }


type Msg
    = Selected Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        Selected n ->
            { model | selectedValue = n }


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Switch"
        , example = """Switch.view
    { selected = model.selectedValue
    , onSelected = Selected
    }
    [ Switch.item First "First"
    , Switch.item Second "Second"
    , Switch.item Third "Third"
    ]
"""
        , children =
            [ let
                selectedValue =
                    case model.selectedValue of
                        0 ->
                            "First"

                        1 ->
                            "Second"

                        2 ->
                            "Third"

                        _ ->
                            "??"
              in
              pre [ class "overflow-auto" ]
                [ text ("selected = MyTab." ++ selectedValue)
                ]
            , Switch.view { selected = model.selectedValue, onSelected = Selected }
                [ Switch.item 0 "First"
                , Switch.item 1 "Second"
                , Switch.item 2 "Third"
                ]
            ]
        }
