module Section.Radio exposing
    ( Model
    , Msg
    , get
    , init
    , update
    )

import Components.Radio as Radio
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events
import Section


type alias Model =
    { value : Maybe String
    }


init : Model
init =
    { value = Nothing
    }


type Msg
    = Input String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input str ->
            { model | value = Just str }


labelClass : Html.Attribute msg
labelClass =
    class "flex items-center gap-x-3 text-gray-800 select-none"


view : Model -> List (Html Msg)
view model =
    [ pre [] [ text (Maybe.withDefault "(no option selected)" model.value) ]
    , div [ class "space-y-3" ]
        [ label [ labelClass, Html.Attributes.for "option-1" ]
            [ Radio.view
                [ Radio.onInput Input
                , Radio.selectedValue model.value
                , Radio.id "option-1"
                ]
                "value-1"
            , text "First option"
            ]
        , label [ labelClass, Html.Attributes.for "option-2" ]
            [ Radio.view
                [ Radio.onInput Input
                , Radio.selectedValue model.value
                , Radio.id "option-2"
                ]
                "value-2"
            , text "Second option"
            ]
        ]
    ]


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Radio"
        , example = """TODO
"""
        , children = view model
        }
