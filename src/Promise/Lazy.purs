module Promise.Lazy where

import Prelude

import Data.Newtype (class Newtype)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Uncurried (mkEffectFn1, mkEffectFn2, runEffectFn1, runEffectFn2)
import Promise (class Flatten, Executor, Rejection)
import Promise.Internal as P

-- | A trivial box that adds a layer between promises to prevent automatic flattening.
data Box a = Box a

-- | A pure `Promise` that has not been executed yet. This type can be used
-- | with `do` syntax.
newtype LazyPromise a = LazyPromise (Effect (P.Promise (Box a)))

derive instance newtypeLazyPromise :: Newtype (LazyPromise a) _

instance functorLazyPromise :: Functor LazyPromise where
  map = liftM1

instance applyLazyPromise :: Apply LazyPromise where
  apply = ap

instance applicativeLazyPromise :: Applicative LazyPromise where
  pure = LazyPromise <<< pure <<< P.resolve <<< Box

instance bindLazyPromise :: Bind LazyPromise where
  bind (LazyPromise p) k = LazyPromise do
    p' <- p
    runEffectFn2 P.then_ (mkEffectFn1 \(Box a) -> let (LazyPromise b) = k a in b) p'

instance monadLazyPromise :: Monad LazyPromise

instance monadEffectLazyPromise :: MonadEffect LazyPromise where
  liftEffect = LazyPromise <<< map (P.resolve <<< Box)

new :: forall a. Executor a -> LazyPromise a
new k = LazyPromise $ runEffectFn1 P.new $ mkEffectFn2 \onResolve onReject ->
  k (runEffectFn1 onResolve <<< Box) (runEffectFn1 onReject)

catch :: forall a b. (Rejection -> LazyPromise b) -> LazyPromise a -> LazyPromise b
catch k (LazyPromise p) = LazyPromise do
  p' <- p
  runEffectFn2 P.catch (mkEffectFn1 \a -> let (LazyPromise b) = k a in b) p'

finally :: forall a. LazyPromise Unit -> LazyPromise a -> LazyPromise a
finally (LazyPromise p1) (LazyPromise p2) = LazyPromise do
  p2' <- p2
  runEffectFn2 P.finally finalize p2'
  where
  finalize = do
    p1' <- p1
    runEffectFn2 P.then_ (mkEffectFn1 \(Box a) -> pure (P.resolve a)) p1'

all :: forall a. Array (LazyPromise a) -> LazyPromise (Array a)
all as = LazyPromise do
  as' <- traverse (\(LazyPromise a) -> a) as
  as'' <- runEffectFn1 P.all as'
  runEffectFn2 P.then_ rebox as''
  where
  rebox = mkEffectFn1 \bs -> pure (P.resolve (Box (map (\(Box b) -> b) bs)))

race :: forall a. Array (LazyPromise a) -> LazyPromise a
race as = LazyPromise do
  as' <- traverse (\(LazyPromise a) -> a) as
  runEffectFn1 P.race as'

fromPromise :: forall a. Effect (P.Promise a) -> LazyPromise a
fromPromise p = LazyPromise $ runEffectFn2 P.then_ (mkEffectFn1 (pure <<< P.resolve <<< Box)) =<< p

toPromise :: forall a b. Flatten a b => LazyPromise a -> Effect (P.Promise b)
toPromise (LazyPromise p) = runEffectFn2 P.then_ (mkEffectFn1 \(Box b) -> pure (P.resolve b)) =<< p
