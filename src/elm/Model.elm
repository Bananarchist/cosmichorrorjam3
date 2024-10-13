module Model exposing (Model, init, video)

import Msg exposing (Msg)
import System exposing (System)

type alias Model =
  Model.Model Audio.Audio Video.Video Input.Input Int Int

init : System -> Model
