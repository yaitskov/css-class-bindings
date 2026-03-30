module CssClassBindings.IncludeCss (includeCss) where

import CssClassBindings.Escape ( escapeValIden )
import CssClassBindings.Qq (cssToDecs)
import Data.Text.IO.Utf8 qualified as U
import Language.Haskell.TH.Syntax
    ( mkName, Q, Dec, runIO, getPackageRoot )
import Prelude
import System.Directory (makeAbsolute)
import System.FilePath (takeBaseName, (</>))

liftIO1 :: (a -> IO b) -> a -> Q b
liftIO1 f x = runIO (f x)

-- | like css quasi quoter but
-- css input is exported via constant equal to base file name
-- instead of cssAsLiteralText.
includeCss :: FilePath -> Q [Dec]
includeCss p = do
  ap <- getPackageRoot >>= liftIO1 makeAbsolute . (</> p)
  cssToDecs (mkName (escapeValIden $ takeBaseName p)) <$> runIO (U.readFile ap)
