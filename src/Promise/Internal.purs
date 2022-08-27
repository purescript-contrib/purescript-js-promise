module Promise.Internal where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3)
import Promise.Rejection (Rejection)

foreign import data Promise :: Type -> Type

type role Promise representational

foreign import new :: forall a b. EffectFn1 (EffectFn2 (EffectFn1 a Unit) (EffectFn1 Rejection Unit) Unit) (Promise b)

foreign import then_ :: forall a b c. EffectFn2 (EffectFn1 a (Promise b)) (Promise a) (Promise c)

foreign import thenOrCatch :: forall a b c. EffectFn3 (EffectFn1 a (Promise b)) (EffectFn1 Rejection (Promise b)) (Promise a) (Promise c)

foreign import catch :: forall a b. EffectFn2 (EffectFn1 Rejection (Promise b)) (Promise a) (Promise b)

foreign import finally :: forall a. EffectFn2 (Effect (Promise Unit)) (Promise a) (Promise a)

foreign import resolve :: forall a b. a -> Promise b

foreign import reject :: forall a. Rejection -> Promise a

foreign import all :: forall a. EffectFn1 (Array (Promise a)) (Promise (Array a))

foreign import race :: forall a. EffectFn1 (Array (Promise a)) (Promise a)
