# elm-range

An Elm library for creating and operating over ranges of integers.
Notably, the library provides a non-recursive native implementation of 
`foldl`, which is used to implement other iterative functions.  This 
prevents stack overflow when dealing with large ranges.

Ranges are inclusive-exclusive, meaning `range a b` includes `a` and 
all integers between `a` and `b`, but not `b` itself.


## Examples

```elm
import Range (range, toList, to, thru, map, foldl)

(range 1 4 |> toList) == [1, 2, 3]
(range 1 4) == (1 `to` 4)
(range 1 4) == (1 `thru` 3)
(range 1 4 |> map (\x -> x * 2)) == [2, 4, 6]
(range 1 4 |> foldl (+) 0) == 6
```
