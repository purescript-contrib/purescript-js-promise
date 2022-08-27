module Promise.Rejection
  ( Rejection
  , fromError
  , toError
  ) where

import Data.Function.Uncurried (Fn3, runFn3)
import Data.Maybe (Maybe(..))
import Effect.Exception (Error)

foreign import data Rejection :: Type

foreign import fromError :: Error -> Rejection

foreign import _toError :: Fn3 (forall a. a -> Maybe a) (forall a. Maybe a) Rejection (Maybe Error)

toError :: Rejection -> Maybe Error
toError = runFn3 _toError Just Nothing
