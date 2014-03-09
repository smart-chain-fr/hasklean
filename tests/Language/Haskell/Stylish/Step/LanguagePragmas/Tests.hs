--------------------------------------------------------------------------------
module Language.Haskell.Stylish.Step.LanguagePragmas.Tests
    ( tests
    ) where


--------------------------------------------------------------------------------
import Test.Framework                 (Test, testGroup)
import Test.Framework.Providers.HUnit (testCase)
import Test.HUnit                     (Assertion, (@=?))


--------------------------------------------------------------------------------
import Language.Haskell.Stylish.Step.LanguagePragmas
import Language.Haskell.Stylish.Tests.Util


--------------------------------------------------------------------------------
tests :: Test
tests = testGroup "Language.Haskell.Stylish.Step.LanguagePragmas.Tests"
    [ testCase "case 01" case01
    , testCase "case 02" case02
    , testCase "case 03" case03
    , testCase "case 04" case04
    , testCase "case 05" case05
    , testCase "case 06" case06
    ]


--------------------------------------------------------------------------------
case01 :: Assertion
case01 = expected @=? testStep (step 80 Vertical False) input
  where
    input = unlines
        [ "{-# LANGUAGE ViewPatterns #-}"
        , "{-# LANGUAGE TemplateHaskell, ViewPatterns #-}"
        , "{-# LANGUAGE ScopedTypeVariables #-}"
        , "module Main where"
        ]

    expected = unlines
        [ "{-# LANGUAGE ScopedTypeVariables #-}"
        , "{-# LANGUAGE TemplateHaskell     #-}"
        , "{-# LANGUAGE ViewPatterns        #-}"
        , "module Main where"
        ]


--------------------------------------------------------------------------------
case02 :: Assertion
case02 = expected @=? testStep (step 80 Vertical True) input
  where
    input = unlines
        [ "{-# LANGUAGE BangPatterns #-}"
        , "{-# LANGUAGE ViewPatterns #-}"
        , "increment ((+ 1) -> x) = x"
        ]

    expected = unlines
        [ "{-# LANGUAGE ViewPatterns #-}"
        , "increment ((+ 1) -> x) = x"
        ]


--------------------------------------------------------------------------------
case03 :: Assertion
case03 = expected @=? testStep (step 80 Vertical True) input
  where
    input = unlines
        [ "{-# LANGUAGE BangPatterns #-}"
        , "{-# LANGUAGE ViewPatterns #-}"
        , "increment x = case x of !_ -> x + 1"
        ]

    expected = unlines
        [ "{-# LANGUAGE BangPatterns #-}"
        , "increment x = case x of !_ -> x + 1"
        ]


--------------------------------------------------------------------------------
case04 :: Assertion
case04 = expected @=? testStep (step 80 Compact False) input
  where
    input = unlines
        [ "{-# LANGUAGE TypeOperators, StandaloneDeriving, DeriveDataTypeable,"
        , "    TemplateHaskell #-}"
        , "{-# LANGUAGE TemplateHaskell, ViewPatterns #-}"
        ]

    expected = unlines
        [ "{-# LANGUAGE DeriveDataTypeable, StandaloneDeriving, " ++
            "TemplateHaskell,"
        , "             TypeOperators, ViewPatterns #-}"
        ]


--------------------------------------------------------------------------------
case05 :: Assertion
case05 = expected @=? testStep (step 80 Vertical False) input
  where
    input = unlines
        [ "{-# LANGUAGE CPP #-}"
        , ""
        , "#if __GLASGOW_HASKELL__ >= 702"
        , "{-# LANGUAGE Trustworthy #-}"
        , "#endif"
        ]

    expected = unlines
        [ "{-# LANGUAGE CPP         #-}"
        , ""
        , "#if __GLASGOW_HASKELL__ >= 702"
        , "{-# LANGUAGE Trustworthy #-}"
        , "#endif"
        ]

case06 :: Assertion
case06 = expected @=? testStep (step 80 CompactLine True) input
  where
    input = unlines
        [ "{-# LANGUAGE TypeOperators, StandaloneDeriving, DeriveDataTypeable,"
        , "    TemplateHaskell #-}"
        , "{-# LANGUAGE TemplateHaskell, ViewPatterns #-}"
        ]
    expected = unlines
        [ "{-# LANGUAGE DeriveDataTypeable, StandaloneDeriving, " ++
          "TemplateHaskell #-}"
        , "{-# LANGUAGE TypeOperators, ViewPatterns                             #-}"
        ]
