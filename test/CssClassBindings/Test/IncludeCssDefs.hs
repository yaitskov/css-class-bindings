{-# LANGUAGE TemplateHaskell #-}
module CssClassBindings.Test.IncludeCssDefs where

import CssClassBindings ( includeCss, CssIdentifier(id_) )

includeCss "test/style.css"
