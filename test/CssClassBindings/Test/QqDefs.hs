{-# LANGUAGE QuasiQuotes #-}
module CssClassBindings.Test.QqDefs where

import CssClassBindings ( css, CssIdentifier(id_) )

[css|.foo-bar {
  color: #1212ff;
}

*:not(#funargid) {
  color: #aaa;
}

*:not(#funargidclass.yyy) {
  color: #aaa;
}

#idseq, .xxx {
  color: #bbb;
}

#idseqspace , .xxx {
  color: #ccc;
}

#foo-bar {
  color: #f212ff;
}|]

data F212ff
