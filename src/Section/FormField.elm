module Section.FormField exposing (Model, Msg, get, init, update)

import Components.Autocomplete as Autocomplete
import Components.FormField as FormField
import Components.TextField as TextField
import Html exposing (..)
import Html.Attributes as Attrs
import Section


type alias Model =
    { email : String
    , flag : Bool
    , cap : Autocomplete.Model
    }


init : Model
init =
    { email = ""
    , flag = False
    , cap = Autocomplete.init
    }


type Msg
    = InputEmail String
    | Toggle Bool
    | CapAutocompleteMsg Autocomplete.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputEmail str ->
            ( { model | email = str }
            , Cmd.none
            )

        CapAutocompleteMsg subMsg ->
            let
                ( newModel, cmd ) =
                    Autocomplete.update subMsg model.cap
            in
            ( { model | cap = newModel }
            , Cmd.map CapAutocompleteMsg cmd
            )

        Toggle flag ->
            ( { model | flag = flag }
            , Cmd.none
            )


view : Model -> List (Html Msg)
view model =
    [ div [ Attrs.class "mb-32" ]
        [ FormField.view [ FormField.id "user-email" ]
            [ FormField.label "Email"
            , FormField.textField
                [ TextField.placeholder "user@mail.com"
                , TextField.value model.email
                , TextField.onInput InputEmail
                ]
            ]
        , FormField.view [ FormField.id "user-flag" ]
            [ FormField.label "Flag"
            , FormField.toggle { checked = model.flag, onCheck = Toggle } []
            ]
        , FormField.view [ FormField.id "cap" ]
            [ FormField.label "Cap"
            , FormField.autoComplete [ Autocomplete.placeholder "00123" ]
                { model = model.cap
                , toMsg = CapAutocompleteMsg
                , options =
                    Just
                        [ Autocomplete.simpleOption "00123"
                        , Autocomplete.simpleOption "00425"
                        , Autocomplete.simpleOption "11456"
                        , Autocomplete.simpleOption "00129"
                        ]
                }
            ]
        ]
    ]


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Form field"
        , example = """FormField.view [ FormField.id "user-email" ]
    [ FormField.label "Email"
    , FormField.textField [ TextField.placeholder "user@mail.com" ]
    ]

-- Alternative possible API
FormField.view [ FormField.id "user-email" ]
    { label = FormField.textLabel "Email"
    , form = FormField.textField [ TextField.placeholder "user@mail.com" ]
    }
"""
        , children = view model
        }
