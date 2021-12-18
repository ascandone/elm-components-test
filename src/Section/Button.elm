module Section.Button exposing (get)

import Components.Button as Button
import FeatherIcons
import Section exposing (Section)


get : Section msg
get =
    Section.static
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
            , Button.ghost [ Button.size Button.sm ] "Link"
            ]
        }
