module Section.FormField exposing (get)

import Components.FormField as FormField
import Components.TextField as TextField
import Html exposing (Html)
import Section


view : List (Html msg)
view =
    [ FormField.view [ FormField.id "user-email" ]
        [ FormField.label "Email"
        , FormField.textField [ TextField.placeholder "user@mail.com" ]
        ]
    ]


get : Section.Section msg
get =
    Section.static
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
        , children = view
        }
