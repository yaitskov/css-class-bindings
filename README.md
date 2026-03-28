# css-class-bindings

## Motivation

Recently I migrated
[vpn-router](https://github.com/yaitskov/vpn-router) frontend to
[miso](https://github.com/dmjio/miso) and noticed that DOM functions
(e.g. `div_`) accept CSS class names as plain strings - so even if CSS
style sheets are defined with
[clay](https://hackage.haskell.org/package/clay), GHC is not able
to catch a typo in a refered CSS class.

## Usage

The library leverages the power of TH to parse CSS snippets from quasi
quotes or style files and to define Haskell constants for every class
mentioned in the input.

### Input


``` haskell
{-# LANGUAGE QuasiQuotes #-}
module Css where
import CssClassBindings.Qq ( css )

[css|
.foo-bar {
  color: #fc2c2c;
}
|]
```

``` haskell
module Main where
import Miso
import Miso.Html.Element (div_, button_)
import Miso.Html.Property qualified as P
import Css qualified as C

class_ :: C.CssClass MisoString -> Attribute action
class_ = P.class_ . C.class_

app :: App Model Action
app = (component emptyModel updateModel viewModel)
  { styles = [ Style C.cssAsLiteralText ]
  }

viewModel :: Model -> View Model Action
viewModel m = div_ [] [ button_ [ class_ fooBar ] [ "Submit" ] ]
```

The library has been created to improve a miso-based app, but it does
not depend on miso and it can be used in other setups.

``` haskell
fooBar :: IsString s => CssClass s
cssAsLiteralText :: IsString s => s
```

## Development environment

HLS should be available inside the default dev shell.

```shell
$ nix develop
$ emacs src/*/*/Qq.hs &
$ cabal build
```
