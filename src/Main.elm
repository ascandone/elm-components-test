module Main exposing (Model, main)

import Browser
import Components.Autocomplete as Autocomplete
import Html exposing (..)
import Section exposing (Section)
import Section.ActionBtn
import Section.Autocomplete
import Section.Button
import Section.Card
import Section.Checkbox
import Section.Switch
import Section.TextField


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { textFieldModel : Section.TextField.Model
    , switchModel : Section.Switch.Model
    , autocompleteModel : Section.Autocomplete.Model
    , flag : Bool
    , selectedValue : Int
    , actionBtnModel : Section.ActionBtn.Model
    , checkBoxModel : Section.Checkbox.Model
    }


init : () -> ( Model, Cmd Msg )
init () =
    ( { textFieldModel = Section.TextField.init
      , checkBoxModel = Section.Checkbox.init
      , switchModel = Section.Switch.init
      , flag = False
      , selectedValue = 0
      , autocompleteModel = Section.Autocomplete.init
      , actionBtnModel = Section.ActionBtn.init
      }
    , Cmd.none
    )


type Msg
    = TextFieldMsg Section.TextField.Msg
    | SwitchMsg Section.Switch.Msg
    | CheckedMsg Section.Checkbox.Msg
    | AutocompleteMsg Section.Autocomplete.Msg
    | ActionBtnMsg Section.ActionBtn.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
        ]
