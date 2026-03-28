{-# LANGUAGE MultilineStrings #-}
module CssClassBindings.Test.IncludeCssAsserts where

import CssClassBindings (class_)
import CssClassBindings.Test.IncludeCssDefs (fooBar, style)
import Prelude
import Test.Tasty.HUnit ( (@=?) )

unit_camelCaseLiteral :: IO ()
unit_camelCaseLiteral = ("foo-bar" :: String) @=? class_ fooBar

unit_exportCssInputAsIs :: IO ()
unit_exportCssInputAsIs = css @=? style
  where
    css :: String
    css = """
      .foo-bar {
        color: #1212ff;
      }
    """ <> "\n"
