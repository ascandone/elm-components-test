module Main exposing (Model, main)

import Browser
import Html exposing (..)
import Section exposing (Section)
import Section.ActionBtn
import Section.Autocomplete
import Section.Button
import Section.Card
import Section.Checkbox
import Section.ComplexForm
import Section.FormField
import Section.Switch
import Section.TextField


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { textFieldModel : Section.TextField.Model
    , switchModel : Section.Switch.Model
    , autocompleteModel : Section.Autocomplete.Model
    , actionBtnModel : Section.ActionBtn.Model
    , checkBoxModel : Section.Checkbox.Model
    , complexFormModel : Section.ComplexForm.Model
    , formFieldModel : Section.FormField.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { textFieldModel = Section.TextField.init
      , checkBoxModel = Section.Checkbox.init
      , switchModel = Section.Switch.init
      , autocompleteModel = Section.Autocomplete.init
      , actionBtnModel = Section.ActionBtn.init
      , complexFormModel = Section.ComplexForm.init
      , formFieldModel = Section.FormField.init
      }
    , Cmd.none
    )


type Msg
    = TextFieldMsg Section.TextField.Msg
    | SwitchMsg Section.Switch.Msg
    | CheckedMsg Section.Checkbox.Msg
    | AutocompleteMsg Section.Autocomplete.Msg
    | ActionBtnMsg Section.ActionBtn.Msg
    | ComplexFormMsg Section.ComplexForm.Msg
    | FormFieldMsg Section.FormField.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FormFieldMsg subMsg ->
            let
                ( newModel, cmd ) =
                    Section.FormField.update subMsg model.formFieldModel
            in
            ( { model | formFieldModel = newModel }
            , Cmd.map FormFieldMsg cmd
            )

        SwitchMsg subMsg ->
            ( { model | switchModel = Section.Switch.update subMsg model.switchModel }
            , Cmd.none
            )

        TextFieldMsg subMsg ->
            ( { model | textFieldModel = Section.TextField.update subMsg model.textFieldModel }
            , Cmd.none
            )

        AutocompleteMsg subMsg ->
            let
                ( newModel, cmd ) =
                    Section.Autocomplete.update subMsg model.autocompleteModel
            in
            ( { model | autocompleteModel = newModel }
            , Cmd.map AutocompleteMsg cmd
            )

        ActionBtnMsg subMsg ->
            ( { model | actionBtnModel = Section.ActionBtn.update subMsg model.actionBtnModel }
            , Cmd.none
            )

        CheckedMsg subMsg ->
            ( { model | checkBoxModel = Section.Checkbox.update subMsg model.checkBoxModel }
            , Cmd.none
            )

        ComplexFormMsg subMsg ->
            ( { model | complexFormModel = Section.ComplexForm.update subMsg model.complexFormModel }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    Section.viewSections
        [ Section.Button.get
        , Section.ActionBtn.get model.actionBtnModel ActionBtnMsg
        , Section.TextField.get model.textFieldModel TextFieldMsg
        , Section.Autocomplete.get model.autocompleteModel AutocompleteMsg
        , Section.Switch.get model.switchModel SwitchMsg
        , Section.Checkbox.get model.checkBoxModel CheckedMsg
        , Section.Card.get
        , Section.FormField.get model.formFieldModel FormFieldMsg

        --, Section.ComplexForm.get model.complexFormModel ComplexFormMsg
        ]
