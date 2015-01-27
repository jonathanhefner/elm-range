module RangeTests where

import ElmTest.Test (test, Test, suite)
import ElmTest.Assertion (assert, assertEqual)
import ElmTest.Runner.Element (runDisplay)

import Range (..)
import List


main = runDisplay <| suite "Range tests"
  [ testRange "increasing positive range" 1 4 [1, 2, 3]
  , testRange "decreasing positive range" 4 1 [4, 3, 2]
  , testRange "increasing negative range" -4 -1 [-4, -3, -2]
  , testRange "decreasing negative range" -1 -4 [-1, -2, -3]
  , testRange "increasing split range" -1 2 [-1, 0, 1]
  , testRange "decreasing split range" 1 -2 [1, 0, -1]
  , testRange "empty range" 1 1 []
  , test "stress test" <| assertEqual (0) (range -50000 50001 |> foldl (+) 0)
  , test "stress test" <| assertEqual (0) (range -50000 50001 |> foldr (+) 0)
  ]

testRange : String -> Int -> Int -> List Int -> Test
testRange description a b equivalent =
  let step = case equivalent of
               e1::e2::_ -> e2 - e1
               _ -> 1
      r = range a b
  in
      suite description 
        [ test "to" <| assertEqual (r) (to a b)
        , test "thru" <| assertEqual (range a (b + step)) (thru a b)
        , test "reverse" <| assertEqual (List.reverse equivalent) (reverse r |> toList)
        , test "foldl" <| assertEqual (List.foldl (-) 0 equivalent) (foldl (-) 0 r)
        , test "foldr" <| assertEqual (List.foldr (-) 0 equivalent) (foldr (-) 0 r)
        , test "map" <| assertEqual (List.map (\x -> x * 2) equivalent) (map (\x -> x * 2) r)
        , test "toList" <| assertEqual (equivalent) (toList r)
        , test "length" <| assertEqual (List.length equivalent) (length r)
        , test "isEmpty" <| assertEqual (List.isEmpty equivalent) (isEmpty r)
        , test "member" <| assert (List.all (\x -> member x r) equivalent)
        , test "member" <| assertEqual (False) (member (fst r - step) r)
        , test "member" <| assertEqual (False) (member (snd r) r)
        ]
  