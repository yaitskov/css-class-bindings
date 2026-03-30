# css-class-bindings

## Motivation

Recently I migrated the
[vpn-router](https://github.com/yaitskov/vpn-router) frontend to
[Miso](https://github.com/dmjio/miso), I noticed that DOM functions
(e.g. `div_`) accept CSS class names as plain strings. This prevents GHC
from catching typos in referenced names, even if stylesheets are
correct and defined with
[clay](https://hackage.haskell.org/package/clay).


## Usage

The library leverages the power of TH to parse CSS snippets from quasi
quotes or style files and to define Haskell constants for every class
mentioned in the input.

### Quasi-quote input


``` haskell
{-# LANGUAGE QuasiQuotes #-}
module Css where
import CssClassBindings ( css )

[css|
.foo-bar {
  color: #fc2c2c;
}
#foo-bar {
  color: #fc2c2c;
}
|]
```

``` haskell
module Main where

import Css (fooBar, FooBar(..), cssAsLiteralText)
import CssClassBindings qualified as C
import Miso
import Miso.Html.Element (div_, button_)
import Miso.Html.Property qualified as P

class_ :: C.CssClass MisoString -> Attribute action
class_ = P.class_ . C.class_

key_ :: C.CssIdentifier i => i -> Attribute action
key_ = P.key_ . C.id_

app :: App Model Action
app = (component emptyModel updateModel viewModel)
  { styles = [ Style cssAsLiteralText ]
  }

viewModel :: Model -> View Model Action
viewModel m =
  div_ []
    [ button_
      [ key_ FooBar
      , class_ fooBar
      ]
      [ "Submit" ]
    ]
```

The library has been created to improve a miso-based app, but it does
not depend on miso and it can be used in other setups.

``` haskell
fooBar :: IsString s => CssClass s
cssAsLiteralText :: IsString s => s
```

### File input
``` haskell
{-# LANGUAGE TemplateHaskell #-}
module Css where
import CssClassBindings ( includeCss )

includeCss "assets/style.css"
```

``` haskell
module Main where

import Css (fooBar, FooBar(..), style)
-- ...
```

## Development environment

HLS should be available inside the default dev shell.

```shell
$ nix develop
$ emacs src/*/*/Qq.hs &
$ cabal build
```
