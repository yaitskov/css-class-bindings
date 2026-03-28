module CssClassBindings.Escape where

import Data.Char
    ( isAlpha, isAlphaNum, isUpper, toLower, toUpper )
import Prelude

escapeIden :: String -> String
escapeIden s =
  case escapeIdenChar <$> hyphensToCamelCase s of
    s'@(fl:ol)
      | not (isAlpha fl) -> '_' : s'
      | isUpper fl -> toLower fl : ol
      | otherwise -> s'
    [] -> []

escapeIdenChar :: Char -> Char
escapeIdenChar c
  | isAlphaNum c || c == '_' = c
  | otherwise = '_'

hyphensToCamelCase :: String -> String
hyphensToCamelCase = concatMap ucFirst . splitOn '-'

ucFirst :: String -> String
ucFirst "" = ""
ucFirst (h:t) = toUpper h : t

splitOn :: Eq a => a -> [a] -> [[a]]
splitOn x xs = go xs []
  where
    go [] acc = [reverse acc]
    go (y : ys) acc =
      if x == y
      then reverse acc : go ys []
      else go ys (y : acc)
