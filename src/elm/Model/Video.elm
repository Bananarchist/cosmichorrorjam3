module Model.Video exposing (Video, new, resize, punch, update, PlayerState(..))


type alias Video  =
    { player : PlayerState
    , width : Int
    , height : Int
    }

new : Int -> Int -> Video
new width height =
    { player = Running
    , width = width
    , height = height
    }

resize : Int -> Int -> Video -> Video
resize width height video =
  { video | width = width, height = height }

type PlayerState
  = Running
  | PunchWindup Float
  | PunchThrow Float
  | PunchHold Float
  | PunchWithdraw Float


punch : Video -> Video
punch video =
  { video | player = PunchWindup 60.0 }

type alias InputPermitted = Bool
type alias StartSFX = Bool

update : Float -> Video -> (Video, InputPermitted, StartSFX)
update dt video =
  case video.player of
    PunchWindup time ->
      if time <= 0 then
        ({ video | player = PunchThrow 60.0 }, False, True)
      else
        ({ video | player = PunchWindup (time - dt) }, False, False)

    PunchThrow time ->
      if time <= 0 then
        ({ video | player = PunchHold 300.0 }, False, False)
      else
        ({ video | player = PunchThrow (time - dt) }, False, False)

    PunchHold time ->
      if time <= 0 then
        ({ video | player = PunchWithdraw 60.0 }, True, False)
      else
        ({ video | player = PunchHold (time - dt)}, False, if time < 200 then True else False)

    PunchWithdraw time ->
      if time <= 0 then
        ({ video | player = Running }, True, False)
      else
        ({ video | player = PunchWithdraw (time - dt)}, False, False)
    _ ->
      (video, True, False)

