module Main exposing (Model, main)

import Browser
import Components.ActionButton as ActionButton
import Components.Autocomplete as Autocomplete
import Components.Button as Button
import Components.Card as Card
import Components.Switch as Switch
import Components.TextField as TextField
import Components.Toggle as Toggle
import FeatherIcons
import Html exposing (..)
import Html.Attributes exposing (class)


validateEmail : String -> Result String ( String, String )
validateEmail mail =
    case String.split "@" mail of
        [ name, domain ] ->
            Ok ( name, domain )

        _ ->
            Err "Invalid email"


type alias Model =
    { flag : Bool
    , selectedValue : Int
    , textField : String
    , autocompleteModel : Autocomplete.Model
    , autocompleteModel2 : Autocomplete.Model
    , favorited : Bool
    }


init : () -> ( Model, Cmd Msg )
init () =
    ( { flag = False
      , selectedValue = 0
      , textField = "my-mail@example.com"
      , autocompleteModel = Autocomplete.init
      , autocompleteModel2 = Autocomplete.init
      , favorited = False
      }
    , Cmd.none
    )


type Msg
    = Checked Bool
    | Selected Int
    | Input String
    | AutocompleteMsg Autocomplete.Msg
    | AutocompleteMsg2 Autocomplete.Msg
    | ToggledFavorite


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Selected x ->
            ( { model | selectedValue = x }
            , Cmd.none
            )

        Checked b ->
            ( { model | flag = b }
            , Cmd.none
            )

        Input str ->
            ( { model | textField = str }
            , Cmd.none
            )

        AutocompleteMsg subMsg ->
            let
                ( newModel, cmd ) =
                    Autocomplete.update subMsg model.autocompleteModel
            in
            ( { model | autocompleteModel = newModel }
            , Cmd.map AutocompleteMsg cmd
            )

        AutocompleteMsg2 subMsg ->
            let
                ( newModel, cmd ) =
                    Autocomplete.update subMsg model.autocompleteModel2
            in
            ( { model | autocompleteModel2 = newModel }
            , Cmd.map AutocompleteMsg2 cmd
            )

        ToggledFavorite ->
            ( { model | favorited = not model.favorited }
            , Cmd.none
            )


vSpacer : Html msg
vSpacer =
    div [ class "h-10" ] []


hRow : Html msg
hRow =
    div []
        [ vSpacer
        , hr [] []
        , vSpacer
        ]


options : List Autocomplete.Option
options =
    List.range 0 20
        |> List.map String.fromInt
        |> List.map (\i -> Autocomplete.simpleOption ("item--" ++ i))


sectionTitle : String -> Html msg
sectionTitle label =
    container
        [ h2 [ class "font-bold text-gray-900 mb-4 text-xl" ] [ text label ]
        ]


codeExample : String -> Html msg
codeExample str =
    div
        [ class """
            mt-2 mb-8 w-full
            py-4 overflow-x-auto
            bg-neutral-900 text-neutral-100
            xl:rounded-md
            """
        ]
        [ container
            [ code [ class "overflow-x-auto whitespace-pre" ] [ text str ]
            ]
        ]


container : List (Html msg) -> Html msg
container =
    div [ class "px-5" ]


spacerContainer : List (Html msg) -> Html msg
spacerContainer children =
    container (children |> List.intersperse vSpacer)


viewSection :
    { title : String
    , example : String
    , children : List (Html msg)
    }
    -> Html msg
viewSection { children, title, example } =
    div []
        [ sectionTitle title
        , codeExample example
        , spacerContainer children
        ]


viewSections : List (Html msg) -> Html msg
viewSections sections =
    div [ class "max-w-screen-xl mx-auto py-5 pb-20" ]
        (List.intersperse hRow sections)


src : String
src =
    "https://mui.com/static/images/cards/contemplative-reptile.jpg"


view : Model -> Html Msg
view model =
    viewSections
        [ viewSection
            { title = "Icon button"
            , example = """ActionButton.view
    [ ActionButton.class "transition-color duration-200"
    , ActionButton.class <|
        if model.favorited then
            "fill-red-400 text-red-400"

        else
            ""
    , ActionButton.onClick ToggledFavorite
    ]
    Icon.heart"""
            , children =
                [ ActionButton.view
                    [ ActionButton.class "transition-color duration-200 ease-in-out"
                    , ActionButton.class <|
                        if model.favorited then
                            "fill-red-400 text-red-400"

                        else
                            ""
                    , ActionButton.onClick ToggledFavorite
                    ]
                    FeatherIcons.heart
                ]
            }
        , viewSection
            { title = "Card"
            , example = """Card.raised [ Card.dataTestId "lizard-card" ]
    [ Card.media [] { src = "..." }
    , Card.body
        [ h1 [] [ text "Lizard" ]
        , p [] [ text "Lizards are a ..." ]
        ]
    , Card.actions
        [ Button.ghost
            [ Button.size Button.sm
            , Button.onClick Share
            ]
            "Share"
        , Button.ghost
            [ Button.size Button.sm
            , Button.onClick Fav
            ]
            "Favorite"
        ]
    ]
            """
            , children =
                [ div [ class "max-w-sm" ]
                    [ Card.raised [ Card.dataTestId "lizard-card" ]
                        [ Card.media [] { src = src }
                        , Card.body
                            [ h2 [ class "font-semibold text-xl" ] [ text "Lizard" ]
                            , p [ class "text-gray-600" ]
                                [ text "Lizards are a widespread group of squamate reptiles, with over 6,000 species, ranging across all continents except Antarctica" ]
                            ]
                        , Card.actions
                            [ Button.ghost [ Button.size Button.sm ] "Share"
                            , Button.ghost [ Button.size Button.sm ] "Favorite"
                            ]
                        ]
                    ]
                ]
            }
        , viewSection
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
                , TextField.view
                    [ TextField.value model.textField
                    , TextField.onInput Input
                    , TextField.validation (validateEmail model.textField)
                    , TextField.placeholder "example@gmail.com"
                    ]
                , TextField.view
                    [ TextField.value ""
                    , TextField.placeholder "example@gmail.com"
                    ]
                , TextField.view
                    [ TextField.value ""
                    , TextField.validation (Err "Inserisci una mail valida")
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
                ]
            }
        , viewSection
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
"""
            , children =
                [ pre [ class "overflow-auto" ]
                    [ if model.autocompleteModel.selected then
                        text ("id = " ++ model.autocompleteModel.value)

                      else
                        text "No items selected"
                    ]
                , Autocomplete.view [ Autocomplete.placeholder "enter \"item\"" ]
                    { model = model.autocompleteModel
                    , toMsg = AutocompleteMsg
                    , options = Just options
                    }
                , Autocomplete.view [ Autocomplete.placeholder "search something" ]
                    { model = model.autocompleteModel2
                    , toMsg = AutocompleteMsg2
                    , options = Nothing
                    }
                ]
            }
        , viewSection
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
        , viewSection
            { title = "Checkbox"
            , example = """Toggle.view { checked = model.checked, onCheck = Checked }
    [ Toggle.id "toggle-id" ]

Toggle.view { checked = model.checked, onCheck = Checked }
    [ Toggle.id "toggle-id"
    , Toggle.error True
    ]

Toggle.view { checked = model.checked, onCheck = Checked }
    [ Toggle.id "toggle-id"
    , Toggle.disabled True
    ]
"""
            , children =
                [ let
                    bStr =
                        if model.flag then
                            "True"

                        else
                            "False"
                  in
                  pre [ class "overflow-auto" ]
                    [ text ("model.checked = " ++ bStr)
                    ]
                , div []
                    [ Toggle.view { checked = model.flag, onCheck = Checked }
                        [ Toggle.id "flag" ]
                    , label [ Html.Attributes.for "flag", class "px-4" ] [ text "checkbox label" ]
                    ]
                , div []
                    [ Toggle.view { checked = model.flag, onCheck = Checked }
                        [ Toggle.id "flag2", Toggle.error True ]
                    , label [ Html.Attributes.for "flag2", class "px-4" ] [ text "checkbox label" ]
                    ]
                , div []
                    [ Toggle.view { checked = model.flag, onCheck = Checked }
                        [ Toggle.id "flag3", Toggle.disabled True ]
                    , label [ Html.Attributes.for "flag3", class "px-4" ] [ text "checkbox label" ]
                    ]
                ]
            }
        , viewSection
            { title = "Buttons"
            , example = """Button.primary [ Button.size Button.lg ] "Click me"

Button.outline
    [ Button.size Button.md
    , Button.icon Icons.cross
    ]
    "Click me"
"""
            , children =
                [ Button.primary [ Button.size Button.lg ] "Primary lg"
                , Button.primary [ Button.size Button.md ] "Primary md"
                , Button.primary [ Button.size Button.sm ] "Primary sm"
                , Button.outline [ Button.size Button.lg ] "Outline lg"
                , Button.outline [ Button.size Button.md ] "Outline md"
                , Button.outline [ Button.size Button.sm ] "Outline sm"
                , Button.outline
                    [ Button.size Button.lg
                    , Button.icon FeatherIcons.download
                    ]
                    "Icon"
                ]
            }
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
