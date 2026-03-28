{-# LANGUAGE MultilineStrings #-}
module CssClassBindings.Test.QqAsserts where

import CssClassBindings (class_)
import CssClassBindings.Test.QqDefs (fooBar, cssAsLiteralText)
import Prelude
import Test.Tasty.HUnit ( (@=?) )

unit_camelCaseLiteral :: IO ()
unit_camelCaseLiteral = ("foo-bar" :: String) @=? class_ fooBar

unit_exportCssInputAsIs :: IO ()
unit_exportCssInputAsIs = css @=? cssAsLiteralText
  where
    css :: String
    css = """
      .foo-bar {
        color: #1212ff;
      }
    """
