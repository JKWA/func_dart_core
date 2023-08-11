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

Thank you for the clarification. With that in mind, let's revise the README to reflect the functional programming constructs and the deliberate naming choices:

---

### Modules vs. Classes: Advantages of Using Modules

- **Grouping**: Modules provide a clear structure, naturally grouping related functions and types.
- **Readability**: Without class constraints, modules offer a direct and simplified reading experience with top-level entities.

- **Functionality Consistency**: For FP constructs like Monads, using consistent names (e.g., `map`, `flatMap`, `ap`) across modules fosters familiarity.

- **No Forced Containment**: Avoid wrapping related methods within classes. Modules sidestep this limitation.

- **Alias-Driven Imports**: Import entire modules in Dart with one statement and use aliases to manage function name collisions.

- **State Management**: Modules excel with stateless, pure functions, promoting transparency and fewer side effects.

- **Extendability**: Expand on modules without unintended overrides or shadows.

#### Using Classes for Types

Our library leverages classes for intricate data constructs, such as the `Option` type:

- **Explicit Variants**: Classes distinctly differentiate between variants like `Some` and `None`.

- **Type Safety**: They introduce strong type-checking capabilities.

- **Behavioral Encapsulation**: Each variant can have individualized methods or properties.

#### Consistent Naming and Handling Collisions with Module Imports

In the world of Functional Programming (FP), certain constructs like Monads often share common functionality. To simplify the experience and provide a consistent interface, our library uses standardized function names across different modules, such as `map`, `ap`, and `flatMap`.

While this naming convention aids in a more intuitive experience for those well-acquainted with FP, it also means that when you work with multiple constructs, function names will overlap. To address this, leverage Dart's aliasing capability.

Consider you're using both the `Option` and `Either` constructs:

```dart
import 'package:func_dart_core/option.dart' as option;
import 'package:func_dart_core/either.dart' as either;

// Use functions from Option module with the alias
option.map(someValue, someFunction);

// Use functions from Either module with its respective alias
either.map(anotherValue, anotherFunction);
```

By prefixing functions with their respective module aliases, you ensure clarity and prevent naming conflicts. This approach not only maintains the benefits of consistent naming but also grants the flexibility to operate in multi-monad scenarios without confusion.

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

## Sum Types in Dart: Emulating Algebraic Data Types

Algebraic Data Types (ADTs) are a key feature in many functional programming languages, allowing for the definition of composite types in terms of other types. Sum types, a subset of ADTs, let developers express that a value can be one of several possible variants. This feature is invaluable for ensuring type safety, modeling domain-specific problems, and reducing runtime errors.

However, Dart, unlike some of its counterparts, doesn't natively support ADTs. This necessitates workarounds when developers want to leverage the power of sum types.

### Representation in Other Languages:

##### Haskell (`Maybe` type):

```haskell
data Maybe a = Just a | Nothing
```

##### TypeScript:

```typescript
type Option<A> = None | Some<A>;
```

##### Rust (`Option` type):

```rust
enum Option<T> {
    Some(T),
    None,
}
```

### Option Type in Dart:

```dart
sealed class Option<A> {
  const Option();
}

class Some<A> extends Option<A> {
  final A value;
  Some(this.value);
}

class None<A> extends Option<A> {
  const None();
}
```

##### Why does `None` have a Generic Type?

1. **Ensures Uniformity**: Allows interchangeability between `Some<T>` and `None<T>`.
2. **Maintains Type Safety**: Avoids pitfalls of `dynamic`.
3. **Utilizes Type Inference**: Dart's type inference works efficiently.
4. **Keeps Functional Method Consistency**: Ensures methods on `Option` have consistent behavior.

### Either Type in Dart and Other Languages

Either type represents values that can be of two different types:

```pseudo
type Either<E, A> = Left<E> | Right<A>
```

In Dart, due to lack of union types:

```dart
abstract class Either<E, A> { ... }

class Left<E, A> extends Either<E, A> {
  final E value;
  ...
}

class Right<E, A> extends Either<E, A> {
  final A value;
  ...
}
```

## Conclusion

The `func_dart_core` library offers an intuitive and safe emulation of the common sum types in functional programming.

---

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

## The Absence of function refinements such as `isRight`, `isLeft`, `isNone`, and `isSome`

Many functional programming libraries provide, refinement functions such as `isRight`, `isLeft`, `isNone`, and `isSome`. However, in this library these refinement functions are conspicuously absent. Here's why.

### Dart's Type System Limitations

Dart, unlike some languages that have more advanced type refinement capabilities (e.g., TypeScript or Haskell), doesn't refine types within conditional blocks based on predicates.

For example, consider this pattern:

```dart
if (isLeft(myEither)) {

    return Left(myEither.value);  // type error

}
```

Even if `isLeft` returns true, Dart's type system won't refine the type of `myEither` within the block. This means you can't access `.value`.

### Safety Concerns with isLeft via `extension`

An extension would provide a convenient way to work with `Either` types. However, this is not type safe. Here's why:

```dart
extension EitherExtensions<A, B> on Either<A, B> {
  bool get isLeft => this is Left<A, B>;

  A get left {
    if (this is Left<A, B>) {
      return (this as Left<A, B>).value;
    }
    throw Exception("Trying to access leftValue of a Right Either variant.");
  }
}
```

While the `isLeft` getter informs you if the `Either` is of the `Left` variant, the `left` getter will to return the value of the `Left` without any inherent safety checks. If you, mistakenly or unknowingly, call `left` on an `Either` instance that's a `Right`, it will result in a runtime exception.

This design has the potential to introduce bugs and unexpected crashes, especially if proper precautions are not taken before accessing `leftValue`. While the exception message is clear, relying on runtime exceptions for flow control is generally discouraged as it goes against the principle of writing predictable and fail-safe code.

### The Recommended Alternatives

In lieu of these helper functions, it's more idiomatic and safer in Dart to use direct type checks or mapping functions.

#### Direct Type Checks

For `Either`:

```dart
if (myEither is Left<ErrorType, SuccessType>) {
  // Handle Left variant
  var left = myEither.value;
} else if (myEither is Right<ErrorType, SuccessType>) {
  // Handle Right variant
  var right = myEither.value;
}
```

And for `Option`:

```dart
if (myOption is Some<ValueType>) {
  var value = myOption.value;
} else if (myOption is None<ValueType>) {
  // Handle None case
}
```

#### Using Map Functions

For types like `Either` and `Option`, the use of `match` or `fold` can be a powerful alternative:

For `Either`:

```dart
match(
  (left) => /* Handle Left */,
  (right) => /* Handle Right*/
);
```

And for `Option`:

```dart
match(
  (val) => /* Handle Some */,
  () => /* Handle None */
);
```

These `match` functions allow you to provide handlers for each variant in a clean and functional manner. This approach reduces the need for explicit type checks and ensures that you handle all possible variants.

### Conclusion

While it may initially seem like a missing feature, the decision to exclude `isRight`, `isLeft`, `isNone`, and `isSome` was deliberate to encourage safer and more idiomatic Dart code. By utilizing direct type checks or the power of `map` functions, developers can write clearer and more predictable code.

---

## Usage

See [`/example`](https://github.com/JKWA/func_dart_core/tree/main/example) folder.

---
