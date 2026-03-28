-- | Module provides a quasi quoter translating CSS classes to Haskell functions
module CssClassBindings (class_, css, CssClass, cssToDecs, includeCss) where

import CssClassBindings.Qq ( class_, css, cssToDecs, CssClass )
import CssClassBindings.IncludeCss ( includeCss )
