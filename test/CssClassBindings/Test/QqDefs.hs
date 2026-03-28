{-# LANGUAGE QuasiQuotes #-}
module CssClassBindings.Test.QqDefs where

import CssClassBindings (css)

[css|.foo-bar {
  color: #1212ff;
}|]
