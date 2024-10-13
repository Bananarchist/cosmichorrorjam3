module Model.Effect exposing (..)

import Duration exposing (Duration)
import Quantity exposing (Quantity)

type Effect
  = Punch Duration
  | Eclipse Duration
  | Day Duration
  | Complete

update : Effect -> Duration -> Effect
update effect δ =
  case effect of
    Punch remaining ->
      remaining
      |> Quantity.minus δ
      |> (\x -> if Quantity.lessThanOrEqualToZero x then Complete else Punch x)
    Eclipse remaining ->
      remaining
      |> Quantity.minus δ
      |> (\x -> if Quantity.lessThanOrEqualToZero x then Complete else Eclipse x)
    Day remaining ->
      remaining
      |> Quantity.minus δ
      |> (\x -> if Quantity.lessThanOrEqualToZero x then Complete else Day x)
    _ -> effect


inputPermittedGiven : Effect -> Bool
inputPermittedGiven effect =
  case effect of
    Punch duration -> if Quantity.greaterThanOrEqualTo duration punchBlockDuration then False else True
    _ -> True

punchDuration : Duration
punchDuration =
  Duration.milliseconds 600.0

punchBlockDuration : Duration
punchBlockDuration =
  Duration.milliseconds 220.0

completeか : Effect -> Bool
completeか effect =
  case effect of
    Complete -> True
    _ -> False

punchか : Effect -> Bool
punchか effect =
  case effect of
    Punch _ -> True
    _ -> False

filterComplete : List Effect -> List Effect
filterComplete effects =
  List.filter (\effect -> not (completeか effect)) effects
