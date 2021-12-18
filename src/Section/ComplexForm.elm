module Section.ComplexForm exposing (Model, Msg, get, init, update)

import Components.Button as Button
import Components.TextField as TextField
import Html exposing (..)
import Html.Attributes exposing (class)
import Json.Encode as Enc exposing (Value)
import Section


type alias Parser input output =
    input -> Result String output


type alias Data =
    { slug : String
    , number : Int
    }


parseData : Parser Form Data
parseData model =
    Result.map2 Data
        (parseSlugField model.slugField)
        (parseNumberField model.numberField)


strContainsNumber : String -> Bool
strContainsNumber =
    String.toList >> List.any Char.isDigit


parseSlugField : Parser String String
parseSlugField slug =
    if slug |> String.contains " " then
        Err "Slug cannot contain spaces"

    else if strContainsNumber slug then
        Err "Slug cannot contain numbers"

    else
        Ok slug


parseNumberField : Parser String Int
parseNumberField number =
    case String.toInt number of
        Nothing ->
            Err "Insert a valid number"

        Just n ->
            Ok n


type alias Form =
    { slugField : String
    , numberField : String
    }


type alias Model =
    { form : Form
    , submittedValue : Maybe Data
    }


init : Model
init =
    { form =
        { slugField = ""
        , numberField = ""
        }
    , submittedValue = Nothing
    }


type Msg
    = InputSlug String
    | InputNumber String
    | Blur
    | SubmitData Data


updateForm : Model -> (Form -> Form) -> Model
updateForm model mapper =
    { model | form = mapper model.form }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Blur ->
            model

        InputSlug value ->
            updateForm model <| \form -> { form | slugField = String.replace " " "-" value }

        InputNumber value ->
            updateForm model <| \form -> { form | numberField = value }

        SubmitData data ->
            { model | submittedValue = Just data }


viewForm : Form -> Html Msg
viewForm form =
    div [ class "space-y-4" ]
        [ TextField.view
            [ TextField.placeholder "Enter a slug"
            , TextField.value form.slugField
            , TextField.onInput InputSlug
            , TextField.validation (parseSlugField form.slugField)
            ]
        , TextField.view
            [ TextField.placeholder "Enter a number"
            , TextField.value form.numberField
            , TextField.onInput InputNumber
            , TextField.validation (parseNumberField form.numberField)
            ]
        , Button.primary
            [ Button.ifValidated (parseData form) Button.onClick SubmitData
            ]
            "Submit"
        ]


view : Model -> List (Html Msg)
view model =
    [ pre []
        [ text <|
            case model.submittedValue of
                Nothing ->
                    ""

                Just data ->
                    Enc.encode 2 (encodeData data)
        ]
    , viewForm model.form
    ]


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Form validation"
        , example = "TODO"
        , children = view model
        }


encodeData : Data -> Value
encodeData data =
    Enc.object
        [ ( "slug", Enc.string data.slug )
        , ( "number", Enc.int data.number )
        ]
