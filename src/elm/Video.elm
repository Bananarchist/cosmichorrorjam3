module Video exposing (..)

import Html exposing (Html)

type Video = Video

new : Video
new =
  Video

compose : List (a -> List b) -> a -> List b
compose fs x =
  List.foldl ((|>) x >> (++)) [] fs

view : Video -> Html msg
view =
  compose
    [ viewPlayer
    , viewEnemies
    , viewComets
    , viewBackground
    ]
    >> Html.div []

viewPlayer : Video -> List (Html msg)
viewPlayer m =
  [ Html.div [] [] ]

viewEnemies : Video -> List (Html msg)
viewEnemies m =
  [ Html.div [] [] ]

viewComets : Video -> List (Html msg)
viewComets m =
  [ Html.div [] [] ]

viewBackground : Video -> List (Html msg)
viewBackground m =
  [ Html.div [] []]
