module Promise
  ( module Promise
  , module Promise.Internal
  , module Promise.Rejection
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (mkEffectFn1, mkEffectFn2, runEffectFn1, runEffectFn2, runEffectFn3)
import Promise.Internal (Promise, reject)
import Promise.Internal as P
import Promise.Rejection (Rejection)

type Executor a = (a -> Effect Unit) -> (Rejection -> Effect Unit) -> Effect Unit

class Flatten :: Type -> Type -> Constraint
class Flatten a b | a -> b

instance flattenPromise :: Flatten a b => Flatten (Promise a) b
else instance flattenDone :: Flatten a a

new :: forall a b. Flatten a b => Executor a -> Effect (Promise b)
new k = runEffectFn1 P.new $ mkEffectFn2 \onResolve onReject ->
  k (runEffectFn1 onResolve) (runEffectFn1 onReject)

then_ :: forall a b c. Flatten b c => (a -> Effect (Promise b)) -> Promise a -> Effect (Promise c)
then_ k p = runEffectFn2 P.then_ (mkEffectFn1 k) p

thenOrCatch
  :: forall a b c
   . Flatten b c
  => (a -> Effect (Promise b))
  -> (Rejection -> Effect (Promise b))
  -> Promise a
  -> Effect (Promise c)
thenOrCatch k c p = runEffectFn3 P.thenOrCatch (mkEffectFn1 k) (mkEffectFn1 c) p

catch :: forall a b. (Rejection -> Effect (Promise b)) -> Promise a -> Effect (Promise b)
catch k p = runEffectFn2 P.catch (mkEffectFn1 k) p

finally :: forall a. (Effect (Promise Unit)) -> Promise a -> Effect (Promise a)
finally = runEffectFn2 P.finally

resolve :: forall a b. Flatten a b => a -> Promise b
resolve = P.resolve

all :: forall a. Array (Promise a) -> Effect (Promise (Array a))
all = runEffectFn1 P.all

race :: forall a. Array (Promise a) -> Effect (Promise a)
race = runEffectFn1 P.race
