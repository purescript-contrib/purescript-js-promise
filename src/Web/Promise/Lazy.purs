module Web.Promise.Lazy where

import Prelude

import Data.Newtype (class Newtype)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Uncurried (mkEffectFn1, runEffectFn1, runEffectFn2)
import Web.Promise (Rejection)
import Web.Promise.Internal as P

-- | A pure `Promise` that has not been executed yet. This type can be used
-- | with `do` syntax.
newtype LazyPromise a = LazyPromise (Effect (P.Promise a))

derive instance newtypeLazyPromise :: Newtype (LazyPromise a) _

instance functorLazyPromise :: Functor LazyPromise where
  map = liftM1

instance applyLazyPromise :: Apply LazyPromise where
  apply = ap

instance applicativeLazyPromise :: Applicative LazyPromise where
  pure = LazyPromise <<< pure <<< P.resolve

instance bindLazyPromise :: Bind LazyPromise where
  bind (LazyPromise p) k = LazyPromise do
    p' <- p
    runEffectFn2 P.then_ (mkEffectFn1 \a -> let (LazyPromise b) = k a in b) p'

instance monadLazyPromise :: Monad LazyPromise

instance monadEffectLazyPromise :: MonadEffect LazyPromise where
  liftEffect = LazyPromise <<< map P.resolve

catch :: forall a b. (Rejection -> LazyPromise b) -> LazyPromise a -> LazyPromise b
catch k (LazyPromise p) = LazyPromise do
  p' <- p
  runEffectFn2 P.catch (mkEffectFn1 \a -> let (LazyPromise b) = k a in b) p'

finally :: forall a. LazyPromise Unit -> LazyPromise a -> LazyPromise a
finally (LazyPromise p1) (LazyPromise p2) = LazyPromise do
  p2' <- p2
  runEffectFn2 P.finally p1 p2'

all :: forall a. Array (LazyPromise a) -> LazyPromise (Array a)
all as = LazyPromise do
  as' <- traverse (\(LazyPromise a) -> a) as
  runEffectFn1 P.all as'

race :: forall a. Array (LazyPromise a) -> LazyPromise a
race as = LazyPromise do
  as' <- traverse (\(LazyPromise a) -> a) as
  runEffectFn1 P.race as'