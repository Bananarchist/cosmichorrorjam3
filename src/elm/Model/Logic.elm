module Model.Logic exposing (..)

import Length exposing (Length)

type alias Logic =
  { xpos : Int
  , player : Entity
  , phase : SkyPhase
  , targets : List Target
  }

type Entity
  = Innocent
  | Demon

type alias Target =
  { xpos : Int
  , entity : Entity
  }

type SkyPhase
  = Day
  | Eclipse


new : Logic
new =
  { xpos = 0
  , player = Innocent
  , phase = Day
  , targets = [{ xpos = 810, entity = Innocent }, { xpos = 620, entity = Demon }]
  }

update : Float -> Logic -> Logic
update δ logic =
  { logic 
  | xpos = logic.xpos + 1 
  , targets = List.map (updateTarget δ) logic.targets
  }

updateTarget : Float -> Target -> Target
updateTarget δ target =
  { target | xpos = target.xpos - 1 }

targetX : Target -> Int
targetX =
  .xpos

targetName : Target -> String
targetName target =
  case target.entity of
    Innocent -> "innocent"
    Demon -> "demon"

punch : Logic -> Logic
punch logic =
  logic
