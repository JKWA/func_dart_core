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

## The Avoidance of `dynamic`

One distinctive feature of Functional Dart is its intentional avoidance of Dart's `dynamic` type. Here's why that's significant:

1. **Type Safety**: Using static typing offers compile-time checks, catching potential mistakes early in the development lifecycle. It reduces the risk of runtime errors, making your codebase more robust and reliable.
2. **Readability and Clarity**: Explicit type declarations act as implicit documentation. This makes the code more readable as developers can quickly grasp the structure and nature of data without having to delve deep into the implementation details.
3. **Performance Benefits**: By sidestepping `dynamic`, the Dart compiler can make better runtime optimizations. This results in code that's not just safer but also faster.
4. **Smoother Refactoring**: Strong typing ensures that refactoring is a less error-prone process. Changing a type would result in compile-time errors if that type is misused elsewhere in the code, making it easier to spot and fix issues.
5. **Enhanced Development Experience**: Modern IDEs and editors use type information to offer more precise autocompletion suggestions, making the development process smoother and more intuitive.

By promoting strong typing, Functional Dart ensures that developers are less likely to run into unforeseen runtime issues, making applications more maintainable and robust. This approach, combined with the principles of functional programming, provides a structured and reliable framework for developing complex applications in Dart.

## Match Order in Functional Constructs

Navigating this codebase reveals specific conventions in pattern matching, chosen for clarity and predictability:

- **Either**:

  1. Within this library, the `Either` construct represents a computation that might fail. Consistently, the "left" side symbolizes an error or failure scenario, while the "right" side indicates success.
  2. When pattern matching with `Either`, the "left" (error) case is checked first. This approach ensures that error handling is explicitly addressed at the outset, enhancing the flow's readability.

- **Option**:

  1. The `Option` implementation can be visualized as a container that either holds a value (`Some`) or doesn't (`None`).
  2. In pattern matching routines, the `None` case is evaluated first, emphasizing the importance of addressing scenarios where values might be absent.

- **Predicate**:
  1. While `Either` and `Option` adhere to strict conventions, the approach with predicates offers more flexibility.
  2. Nevertheless, a consistent evaluation order is maintained throughout the library for clarity.

By following these conventions, this library offers a coherent and intuitive experience, allowing developers to focus on their logic and functionality rather than on the intricacies of structure.

## Usage

See `/example` folder.
