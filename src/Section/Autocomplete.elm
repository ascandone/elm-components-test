module Section.Autocomplete exposing
    ( Model
    , Msg
    , get
    , init
    , update
    )

import Components.Autocomplete as Autocomplete
import Html exposing (..)
import Html.Attributes exposing (class)
import Section


type alias Model =
    { autocompleteModel1 : Autocomplete.Model
    , autocompleteModel2 : Autocomplete.Model
    , autocompleteModel3 : Autocomplete.Model
    }


init : Model
init =
    { autocompleteModel1 = Autocomplete.init
    , autocompleteModel2 = Autocomplete.init
    , autocompleteModel3 = Autocomplete.init
    }


type Msg
    = AutoCompleteteMsg1 Autocomplete.Msg
    | AutoCompleteteMsg2 Autocomplete.Msg
    | AutoCompleteteMsg3 Autocomplete.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AutoCompleteteMsg1 subMsg ->
            let
                ( newModel, cmd ) =
                    Autocomplete.update subMsg model.autocompleteModel1
            in
            ( { model | autocompleteModel1 = newModel }
            , Cmd.map AutoCompleteteMsg1 cmd
            )

        AutoCompleteteMsg2 subMsg ->
            let
                ( newModel, cmd ) =
                    Autocomplete.update subMsg model.autocompleteModel2
            in
            ( { model | autocompleteModel2 = newModel }
            , Cmd.map AutoCompleteteMsg2 cmd
            )

        AutoCompleteteMsg3 subMsg ->
            let
                ( newModel, cmd ) =
                    Autocomplete.update subMsg model.autocompleteModel3
            in
            ( { model | autocompleteModel3 = newModel }
            , Cmd.map AutoCompleteteMsg3 cmd
            )


options : List Autocomplete.Option
options =
    List.range 0 20
        |> List.map String.fromInt
        |> List.map (\i -> Autocomplete.simpleOption ("item--" ++ i))


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Autocomplete text fields"
        , example = """Autocomplete.view [ Autocomplete.placeholder "search something" ]
    { model = model.autocompleteModel
    , toMsg = AutocompleteMsg
    , options =
        Just
            [ Autocomplete.option "ITA" "Italy"
            , Autocomplete.option "GER" "Germany"
            , Autocomplete.option "FRA" "France"
            ]
    }

Autocomplete.view [ Autocomplete.placeholder "search something" ]
    { model = model.autocompleteModel
    , toMsg = AutocompleteMsg
    , options = Nothing
    }

Autocomplete.view
    [ Autocomplete.placeholder "Enter branch name..."
    , Autocomplete.freshOption
        (\\s ->
           [ text "Add `"
           , bold [] [ text s ]
           , text "`"
           ]
       )
    ]
    { model = model.autocompleteModel
    , toMsg = AutocompleteMsg
    , options = Nothing
    }"""
        , children =
            [ pre [ class "overflow-auto" ]
                [ if model.autocompleteModel1.selected then
                    text ("id = " ++ model.autocompleteModel1.value)

                  else
                    text "No items selected"
                ]
            , Autocomplete.view [ Autocomplete.placeholder "enter \"item\"" ]
                { model = model.autocompleteModel1
                , toMsg = AutoCompleteteMsg1
                , options = Just options
                }
            , Autocomplete.view [ Autocomplete.placeholder "search something" ]
                { model = model.autocompleteModel2
                , toMsg = AutoCompleteteMsg2
                , options = Nothing
                }
            , Autocomplete.view
                [ Autocomplete.placeholder "Enter branch name..."
                , Autocomplete.freshOption
                    (\s ->
                        [ text ""
                        , text "Add `"
                        , span [ class "font-medium text-gray-700" ] [ text s ]
                        , text "`"
                        ]
                    )
                ]
                { model = model.autocompleteModel3
                , toMsg = AutoCompleteteMsg3
                , options =
                    Just
                        [ Autocomplete.simpleOption "main"
                        , Autocomplete.simpleOption "dev"
                        , Autocomplete.simpleOption "hotfix"
                        , Autocomplete.simpleOption "experimental"
                        , Autocomplete.simpleOption "release-candidate"
                        ]
                }
            ]
        }
