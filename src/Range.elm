module Range
  ( Range, range, to, thru, reverse
  , foldl, foldr, map, toList
  , length, isEmpty, member
  ) where

{-| A library for creating and operating over ranges of integers.
Notably, the library provides a non-recursive native implementation of 
`foldl`, which is used to implement other iterative functions.  This 
prevents stack overflow when dealing with large ranges.

# Creating
@docs range, to, thru, reverse

# Iterating
@docs foldl, foldr, map, toList

# Querying
@docs length, isEmpty, member

-}

import Native.Range


type alias Range = (Int, Int)


{-| Create a range.  The first Int is the inclusive start of the range, 
and the second Int is the exclusive end of the range.  In other words 
`range a b` includes `a` and all integers between `a` and `b`, but 
not `b` itself.

Ranges can be increasing or decreasing, and can include negatives 
integers.
-}
range : Int -> Int -> Range
range a b = (a, b)


{-| Create a range.  This function is a convenience alias of `range` 
for use as an infix operator.

    1 `to` 4 == range 1 4
-}
to : Int -> Int -> Range
to = range


{- Create a range with an inclusive end.  In other words, the second 
argument is included as the last value of the range.
   
   1 `thru` 3 == 1 `to` 4
-}
thru : Int -> Int -> Range
thru a b =
  let step = 
        if a > b
        then -1
        else 1
  in
    range a (b + step)


{-| Reverse a range, respecting the inclusive and exclusive bounds.

    reverse (range 1 4) == range 3 0
-}
reverse : Range -> Range
reverse (a, b) =
  let step = 
        if | a < b -> 1
           | a > b -> -1
           | otherwise -> 0
  in
      range (b - step) (a + -step)

      
{-| Reduce a range from the left.

    foldl (-) 0 (range 1 4) == -4
-}
foldl : (Int -> b -> b) -> b -> Range -> b
foldl = Native.Range.foldl


{-| Reduce a range from the right.

    foldr (-) 0 (range 1 4) == 0
-}
foldr : (Int -> b -> b) -> b -> Range -> b
foldr f acc r =
  foldl f acc (reverse r)


{-| Apply a function to every element of a range.

    map (\x -> x * 2) (range 1 4) == [2, 4, 6]
-}
map : (Int -> a) -> Range -> List a
map f r =
  let consMap x xs = (f x) :: xs
  in
      foldr consMap [] r  

      
{-| Convert a range to an equivalent `List Int`.

    toList (range 1 4) == [1, 2, 3]
-}
toList : Range -> List Int
toList r = map identity r


{-| Determine the length of a range.

    length (range 1 4) == 3
-}
length : Range -> Int
length (a, b) =
  abs (b - a)
  
  
{-| Determine if a range is empty.

    isEmpty (range 10 10) == True
    isEmpty (range 10 11) == False
-}
isEmpty : Range -> Bool
isEmpty (a, b) =
  a == b

  
{-| Determine if an Int is a member of a range.

    member 3 (range 1 4) == True
    member 4 (range 1 4) == False
-}
-- NOTE switching the order of args would probably be more useful (in 
--  order to use as a curried predicate), but I'm keeping parity with 
--  the List API for now
member : Int -> Range -> Bool
member i (a, b) =
  (a < b && i >= a && i < b) || (i <= a && i > b)
