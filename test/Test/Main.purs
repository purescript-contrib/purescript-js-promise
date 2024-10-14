module Test.Main where

import Prelude

import Control.Monad.Error.Class (throwError)
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Aff (delay, launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Effect.Exception (error)
import Effect.Ref as Ref
import Promise (Promise, new, resolve, then_)

main :: Effect Unit
main = do
  testPromiseResolve

-- Test if Promise resolves with correct value and uses Ref to store the result
testPromiseResolve :: Effect Unit
testPromiseResolve = do
  resultRef <- Ref.new 0
  (promise :: Promise Int) <- new \resolve _ -> resolve 42
  _ <- flip then_ promise \val -> do
    Ref.write val resultRef
    pure $ resolve val

  launchAff_ do
    delay (Milliseconds 0.0)
    resultValue <- liftEffect $ Ref.read resultRef
    case resultValue of
      42 -> log "Test passed: Ref contains the correct value."
      v -> throwError $ error $ "Test failed: Ref contains unexpected value: " <> show v
