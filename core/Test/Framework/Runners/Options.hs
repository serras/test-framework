module Test.Framework.Runners.Options where

import Test.Framework.Options
import Test.Framework.Utilities
import Test.Framework.Runners.TestPattern

import Data.Monoid


type RunnerOptions = RunnerOptions' Maybe
type CompleteRunnerOptions = RunnerOptions' K
data RunnerOptions' f = RunnerOptions {
        ropt_threads :: f Int,
        ropt_test_options :: f TestOptions,
        ropt_test_patterns :: f [TestPattern],
        ropt_xml_output :: f (Maybe FilePath),
        ropt_xml_nested :: f Bool,
        ropt_plain_output :: f Bool,
        ropt_hide_successes :: f Bool
    }

instance Monoid (RunnerOptions' Maybe) where
    mempty = RunnerOptions {
            ropt_threads = Nothing,
            ropt_test_options = Nothing,
            ropt_test_patterns = Nothing,
            ropt_xml_output = Nothing,
            ropt_xml_nested = Nothing,
            ropt_plain_output = Nothing,
            ropt_hide_successes = Nothing
        }

    mappend ro1 ro2 = RunnerOptions {
            ropt_threads = getLast (mappendBy (Last . ropt_threads) ro1 ro2),
            ropt_test_options = mappendBy ropt_test_options ro1 ro2,
            ropt_test_patterns = mappendBy ropt_test_patterns ro1 ro2,
            ropt_xml_output = mappendBy ropt_xml_output ro1 ro2,
            ropt_xml_nested = getLast (mappendBy (Last . ropt_xml_nested) ro1 ro2),
            ropt_plain_output = getLast (mappendBy (Last . ropt_plain_output) ro1 ro2),
            ropt_hide_successes = getLast (mappendBy (Last . ropt_hide_successes) ro1 ro2)
        }