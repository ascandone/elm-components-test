module Section.ActionBtn exposing
    ( Model
    , Msg
    , get
    , init
    , update
    )

import Components.ActionButton as ActionButton
import FeatherIcons
import Html
import Section


type alias Model =
    { favorited : Bool
    , collapsed : Bool
    }


init : Model
init =
    { favorited = True
    , collapsed = True
    }


type Msg
    = ToggledFavorite
    | ToggleCollapsed


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggledFavorite ->
            { model | favorited = not model.favorited }

        ToggleCollapsed ->
            { model | collapsed = not model.collapsed }


get : Model -> (Msg -> msg) -> Section.Section msg
get model =
    Section.make
        { title = "Icon button"
        , example = """ActionButton.ghost
    [ ActionButton.class "transition-color duration-200"
    , ActionButton.class <|
        if model.favorited then
            "fill-red-400 text-red-400"

        else
            ""
    , ActionButton.onClick ToggledFavorite
    ]
    Icon.heart

ActionButton.ghost
    [ ActionButton.class "transition-all duration-200 ease-in-out"
    , ActionButton.class <|
        if model.collapsed then
            "text-gray-900"

        else
            "rotate-180 text-gray-600"
            
    , ActionButton.onClick ToggleCollapsed
    ]
    Icon.chevronDown

ActionButton.filled [ ActionButton.size ActionButton.sm ] Icon.cross

ActionButton.ghost [ ActionButton.size ActionButton.lg ] Icon.downloadCloud"""
        , children =
            [ ActionButton.view
                [ ActionButton.class "transition-color duration-200 ease-in-out"
                , ActionButton.class <|
                    if model.favorited then
                        "fill-red-400 text-red-400"

                    else
                        ""
                , ActionButton.onClick ToggledFavorite
                , ActionButton.size ActionButton.md
                ]
                FeatherIcons.heart
            , ActionButton.view
                [ ActionButton.class "transition-all duration-200 ease-in-out"
                , ActionButton.class <|
                    if model.collapsed then
                        "text-gray-900"

                    else
                        "rotate-180 text-gray-600"
                , ActionButton.onClick ToggleCollapsed
                ]
                FeatherIcons.chevronDown
            , ActionButton.view
                [ ActionButton.size ActionButton.sm
                ]
                FeatherIcons.x
            , ActionButton.view
                [ ActionButton.size ActionButton.lg
                ]
                FeatherIcons.downloadCloud
            ]
        }
