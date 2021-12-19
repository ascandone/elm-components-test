module Section.TextField exposing
    ( Model
    , Msg
    , get
    , init
    , update
    )

import Components.ActionButton as ActionButton
import Components.TextField as TextField
import FeatherIcons
import Html exposing (..)
import Html.Attributes exposing (class)
import Section


type alias Model =
    { textField : String
    }


init : Model
init =
    { textField = "my-mail@example.com"
    }


type Msg
    = Input String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input str ->
            { model | textField = str }


validateEmail : String -> Result String ( String, String )
validateEmail mail =
    case String.split "@" mail of
        [ name, domain ] ->
            Ok ( name, domain )

        _ ->
            Err "Invalid email"


view : Model -> List (Html Msg)
view model =
    [ TextField.view
        [ TextField.value model.textField
        , TextField.onInput Input
        , TextField.validation validateEmail
        , TextField.placeholder "example@gmail.com"
        ]
    , TextField.view
        [ TextField.value ""
        , TextField.placeholder "example@gmail.com"
        ]
    , TextField.view
        [ TextField.value ""
        , TextField.validation (\_ -> Err "Inserisci una mail valida")
        , TextField.placeholder "example@gmail.com"
        ]
    , TextField.view
        [ TextField.value ""
        , TextField.placeholder "example@gmail.com"
        , TextField.disabled True
        ]
    , TextField.view
        [ TextField.value ""
        , TextField.placeholder "example@gmail.com"
        , TextField.icon FeatherIcons.user
        ]
    , TextField.view
        [ TextField.value ""
        , TextField.placeholder "example@gmail.com"
        , TextField.actionIcon [ ActionButton.size ActionButton.sm ] FeatherIcons.x
        ]
    ]


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Text fields"
        , example = """TextField.view
    [ TextField.value model.textField
    , TextField.onInput Input
    , TextField.validation (validateEmail model.textField)
    , TextField.autofocus True
    , TextField.placeholder "example.gmail.com"
    , TextField.icon Icons.user
    ]
"""
        , children =
            [ pre [ class "overflow-auto" ] [ text ("model.textField = " ++ model.textField) ]
            , div [ class "max-w-sm" ] [ Section.spacerContainer (view model) ]
            ]
        }
