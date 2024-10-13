module Asset exposing (..)

import Dict exposing (Dict)
import Dict.Extra
import Basics.Extra
import Set

type alias Assets =
  Dict String Asset

type Asset
  = Ready
  | Initialized
  | Loading
  | Failed String
  | Active

from : List String -> Assets
from =
  List.foldl (\key assets -> Dict.insert key new assets) Dict.empty

new : Asset
new =
  Initialized

activate : Asset -> Asset
activate =
  always Active

load : Asset -> Asset
load asset =
  Loading

fail : String -> Asset -> Asset
fail message asset =
  Failed message

ready : Asset -> Asset
ready asset =
  Ready

readyか : Asset -> Bool
readyか asset =
  case asset of
    Ready -> True
    _ -> False

activeか : Asset -> Bool
activeか asset =
  case asset of
    Active -> True
    _ -> False

update : String -> (Asset -> Asset) -> Assets -> Assets
update key f =
  Dict.update key (Maybe.map f)

check : String -> (Asset -> Bool) -> Assets -> Bool
check key f =
  Dict.get key 
  >> Maybe.map f
  >> Maybe.withDefault False

allOf : List String -> (Asset -> Bool) -> Assets -> Bool
allOf keys f =
  Dict.Extra.keepOnly (Set.fromList keys)
  >> Dict.Extra.all (always f)
