module CssClassBindings.IncludeCss (includeCss) where

import AddDependentFile ( addDependentFile, getPackageRoot, (</>) )
import CssClassBindings.Escape ( escapeIden )
import CssClassBindings.Qq (cssToDecs)
import Data.Text.IO.Utf8 ( readFile )
import Language.Haskell.TH.Syntax (Q, Dec, runIO, mkName)
import Prelude (FilePath, (<$>), ($))
import System.FilePath (takeBaseName)

-- | like css quasi quoter but
-- css input is exported via constant equal to base file name
-- instead of cssAsLiteralText.
includeCss :: FilePath -> Q [Dec]
includeCss p = do
  ap <- (</> p) <$> getPackageRoot
  addDependentFile ap
  cssToDecs (mkName (escapeIden $ takeBaseName p)) <$> runIO (readFile ap)
