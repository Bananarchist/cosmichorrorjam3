module Input exposing (..)

import Effect exposing (Effect(..))
import Msg exposing (Msg(..))

type Input 
  = Accepting Bool
  | NotAccepting

new : Input
new = Accepting False

update : Input -> Msg -> (Input, List Effect)
update input msg =
  case (input, msg) of 
    (Accepting False, KeyPress) -> (input, [PlayBGM])
    (Accepting True, KeyPress) -> (input, [StopBGM])
    _ -> (input, [])

