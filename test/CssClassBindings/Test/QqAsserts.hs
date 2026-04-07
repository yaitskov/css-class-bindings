{-# LANGUAGE MultilineStrings #-}
module CssClassBindings.Test.QqAsserts where

import CssClassBindings (class_, CssIdentifier(id_))
import CssClassBindings.Test.QqDefs
import Prelude
import Test.Tasty.HUnit ( (@=?) )

unit_camelCaseLiteral :: IO ()
unit_camelCaseLiteral = ("foo-bar" :: String) @=? class_ fooBar

unit_camelCaseLiteral_Id :: IO ()
unit_camelCaseLiteral_Id = ("foo-bar" :: String) @=? id_ FooBar

unit_fun_arg_id :: IO ()
unit_fun_arg_id = ("funargid" :: String) @=? id_ Funargid

unit_fun_arg_id_class :: IO ()
unit_fun_arg_id_class = ("funargidclass" :: String) @=? id_ Funargidclass

unit_id_seq :: IO ()
unit_id_seq = ("idseq" :: String) @=? id_ Idseq

unit_id_seq_space :: IO ()
unit_id_seq_space = ("idseqspace" :: String) @=? id_ Idseqspace

unit_exportCssInputAsIs :: IO ()
unit_exportCssInputAsIs = css @=? cssAsLiteralText
  where
    css :: String
    css = """
      .foo-bar {
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
      }
    """
