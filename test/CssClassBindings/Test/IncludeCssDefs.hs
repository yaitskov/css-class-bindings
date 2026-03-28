{-# LANGUAGE TemplateHaskell #-}
module CssClassBindings.Test.IncludeCssDefs where

import CssClassBindings (includeCss)

includeCss "test/style.css"
