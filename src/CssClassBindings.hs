-- | Module provides a quasi quoter translating CSS classes to Haskell functions
module CssClassBindings
  ( CssIdentifier(id_)
  , CssClass
  , class_
  , css
  , cssToDecs
  , includeCss
  ) where

import CssClassBindings.Qq ( CssIdentifier(id_), CssClass, class_, css, cssToDecs )
import CssClassBindings.IncludeCss ( includeCss )
