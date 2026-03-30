{-# LANGUAGE QuasiQuotes #-}
module CssClassBindings.Test.QqDefs where

import CssClassBindings ( css, CssIdentifier(id_) )

[css|.foo-bar {
  color: #1212ff;
}

#foo-bar {
  color: #f212ff;
}|]

data F212ff
