-- | Module provides a quasi quoter translating CSS classes to Haskell functions
module CssClassBindings.Qq
  ( CssIdentifier (id_)
  , CssClass
  , cssToDecs
  , css
  , class_
  ) where

import CssClassBindings.Escape ( escapeValIden, escapeTypeIden )
import Data.CSS.Syntax.Tokens
    ( Token(Comma, Ident, LeftCurlyBracket, Colon, Function,
            RightParen, Delim, Hash, Whitespace),
      HashFlag(HId),
      tokenize )

import Data.Set ( insert, Set, toList )
import Data.String ( IsString )
import Data.Text ( Text, pack, unpack )
import Language.Haskell.TH.Quote ( QuasiQuoter(..) )
import Language.Haskell.TH.Syntax
    ( mkName,
      Exp(LitE, AppE, ConE),
      Clause(Clause),
      Pat(WildP),
      Con(NormalC),
      Type(VarT, ForallT, AppT, ConT),
      Dec(PragmaD, DataD, InstanceD, SigD, FunD),
      Name,
      DerivClause(DerivClause),
      TyVarBndr(PlainTV),
      Body(NormalB),
      Lit(StringL),
      Pragma(InlineP),
      Inline(Inline),
      RuleMatch(FunLike),
      Phases(AllPhases),
      Specificity(InferredSpec) )

import Prelude

data CssName = CssClassName Text | CssId Text deriving (Show, Eq, Ord)

newtype CssClass s = CssClass { unCssClass :: s } deriving (Show, Eq, Ord)

instance (Semigroup s, IsString s) => Semigroup (CssClass s) where
  CssClass l <> CssClass r = CssClass $ l <> " " <> r

class_ :: IsString s => CssClass s -> s
class_ = unCssClass

class CssIdentifier a where
  id_ :: IsString s => a -> s


{- | quasi quoter accepts CSS and generates definition for classes

> .foo-bar {
>   padding: 0px;
> }
> #foo-bar {
>   padding: 0px;
> }


is expanded as:

@
data FooBar = FooBar
instance CssIdentifier FooBar where
  id_ _ = "foo-bar"
{-# INLINE id_ #-}

{-# INLINE fooBar #-}
fooBar :: IsString s => CssClass s
fooBar = "foo-bar"
{-# INLINE cssAsLiteralText #-}
cssAsLiteralText :: IsString s => s
cssAsLiteralText = ".foo-bar { padding: 0px; }"
@

-}
css :: QuasiQuoter
css = QuasiQuoter
  { quoteExp  = \_ -> fail "quoteExp: not implemented"
  , quotePat  = \_ -> fail "quotePat: not implemented"
  , quoteType = \_ -> fail "quoteType: not implemented"
  , quoteDec  = pure . cssToDecs n . pack
  }
  where
    n = mkName "cssAsLiteralText"

{- Sample of token stream
Delim '.',Ident "skeleton-block",Colon,Function "not",Colon,Ident "last-child",RightParen
-}
collectReferedClasses :: Set CssName -> [Token] -> Set CssName
collectReferedClasses s = \case
  -- class
  Delim '.' : Ident cn : t ->
    collectReferedClasses (insert (CssClassName cn) s) t
  -- hash
  Hash HId i : LeftCurlyBracket : t -> iden i t
  Hash HId i : Whitespace : LeftCurlyBracket : t -> iden i t

  Colon : Function _ : Hash HId i : RightParen : t -> iden i t
  Colon : Function _ : Hash HId i : Whitespace : RightParen : t -> iden i t

  Hash HId i : Delim '.' : t -> iden i t
  Hash HId i : Whitespace : Delim '.' : t -> iden i t

  Hash HId i : Comma : t -> iden i t
  Hash HId i : Whitespace : Comma : t -> iden i t

  _ : t -> collectReferedClasses s t
  [] -> s
  where
    iden i = collectReferedClasses (insert (CssId i) s)
{- | generate definition like:

@@
  {-# INLINE foo #-}
  foo :: IsString s => CssClass s
  foo = "foo"
@@

-}
cssClassConstDec :: CssName -> [Dec]
cssClassConstDec = \case
  CssClassName cn -> className cn
  CssId i -> cssId i
  where
    st = mkName "s"
    cssId i =
      [ DataD [] n [] Nothing
        [NormalC n []]
        [DerivClause Nothing [ConT ''Show, ConT ''Eq]]
      , InstanceD Nothing [] (AppT (ConT ''CssIdentifier) (ConT n))
        [ FunD (mkName "id_")
          [ Clause [WildP] (NormalB . LitE $ StringL ns) [] ]
        ]
      ]
      where
        ns = unpack i
        n = mkName $ escapeTypeIden ns

    className cn =
      [ PragmaD (InlineP n Inline FunLike AllPhases)
      , SigD n
        (ForallT
          [PlainTV st InferredSpec]
          [AppT (ConT ''IsString) (VarT st)]
          (AppT (ConT ''CssClass) (VarT st)))
      , FunD n [ Clause [] body [] ]
      ]
      where
        ns = unpack cn
        n = mkName $ escapeValIden ns
        body = NormalB (AppE (ConE 'CssClass) (LitE (StringL ns)))


cssToDecs :: Name -> Text -> [Dec]
cssToDecs inputExportName s = go s
  where
    go = (cssAsLiteralTextD inputExportName s <>) . concatMap cssClassConstDec .
      toList . collectReferedClasses mempty . tokenize

{- | generate definition like:
@@
  {-# INLINE cssAsLiteralText #-}
  cssAsLiteralText :: IsString s => s
  cssAsLiteralText = s
@@
-}
cssAsLiteralTextD :: Name -> Text -> [Dec]
cssAsLiteralTextD n s =
  [ SigD n
    (ForallT
      [PlainTV st InferredSpec]
      [AppT (ConT ''IsString) (VarT st)]
      (VarT st))
  , FunD n [ Clause [] body [] ]
  , PragmaD (InlineP n Inline FunLike AllPhases)
  ]
  where
    st = mkName "s"
    body = NormalB (LitE (StringL $ unpack s))
