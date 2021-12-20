module Section.Radio exposing
    ( Model
    , Msg
    , get
    , init
    , update
    )

import Components.Radio as Radio
import Html exposing (Html)
import Section


type alias Model =
    {}


init : Model
init =
    {}


type Msg
    = Input String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input _ ->
            model


view : Model -> List (Html Msg)
view model =
    [ Radio.view [ Radio.checked True ]
    , Radio.view [ Radio.checked False ]
    ]


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Radio"
        , example = """TODO
"""
        , children = view model
        }
