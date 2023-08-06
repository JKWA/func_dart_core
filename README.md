# Functional Dart

Functional Dart is a Dart library that encourages functional programming principles. Inspired by [fp-ts](https://gcanti.github.io/fp-ts/) library in TypeScript, Functional Dart aims to bring a comprehensive set of functional programming (FP) tools to Dart developers.

## What is Functional Programming?

Functional programming is a programming paradigm that treats computation as the evaluation of mathematical functions and avoids changing state and mutable data. It emphasizes the application of functions, in contrast to the procedural programming style, which emphasizes changes in state.

Functional programming provides several benefits, such as increased modularity and predictability. It's excellent at managing complex applications that require concurrent processing, data manipulation, and testing.

## Why Functional Dart?

Functional Dart is designed to provide a set of tools for writing functional code in Dart. It aims to create a safer and more predictable coding environment by promoting immutability, function composition, and type safety.

Functional Dart currently includes a number of powerful, flexible structures and functions commonly found in functional programming, including:

- `Eq` and `Ord` interfaces, to represent equality and ordering respectively.
- `Semigroup` and `Monoid` interfaces for abstracting over "concatenation" operations.
- Number, String, and Boolean instances for the above interfaces.
- Predicates and functions for manipulating and combining them.
- Additional utility functions and classes to aid functional programming.

## Higher Kinded Types (HKT)

In Dart, the lack of native support for higher-kinded types makes the creation of type-safe functional programming constructs like Functors, Applicatives, or Monads challenging. For instance, without performing a downcast, it's not possible to ensure that the ap function returns an Applicative<B Function(A)>.

This library prioritizes type safety over perfectly adhering to abstract concepts like Functors, Applicatives, or Monads from functional programming.

Given the current state of Dart language features, specifically its lack of support for higher kinded types, we have to make some trade-offs when trying to implement functional programming constructs like Functors, Applicatives, or Monads. In practical terms, this translates to implementing methods like map, flatMap, and ap as standalone functions that operate on specific types (like Identity, Option, List, etc.), rather than as methods within those classes or as part of shared abstract interfaces. Although this approach diverges from traditional object-oriented programming style, it provides a functional programming style experience and strengthens type safety within the Dart type system.

## Installation

TODO: Publish

## Usage

See to `/example` folder.
