import 'package:func_dart_core/eq.dart';
import 'package:func_dart_core/list.dart' as il;
import 'package:func_dart_core/option.dart';
import 'package:func_dart_core/ord.dart';
import 'package:func_dart_core/predicate.dart';

/// `Either` is a type representing one of two possible values, `A` or `B`.
/// This class is part of the Either type system used in functional programming.
sealed class Either<A, B> {
  const Either();
}

/// `Left` is a subclass of `Either` indicating that the value is of type `A`.
/// It encapsulates or "wraps" that value.
class Left<A, B> extends Either<A, B> {
  /// The value that this `Left` instance holds.
  final A value;

  /// Constructs a `Left` instance that holds the provided [value].
  Left(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Left && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// `Right` is a subclass of `Either` indicating that the value is of type `B`.
/// It encapsulates or "wraps" that value.
class Right<A, B> extends Either<A, B> {
  /// The value that this `Right` instance holds.
  final B value;

  /// Constructs a `Right` instance that holds the provided [value].
  Right(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Right && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// Wraps the given [value] in a `Left`, indicating the presence of a value of type `A`.
///
/// Example usage:
/// ```dart
/// final either = left<int, String>(42);  // This will be Left(42)
/// ```
Either<A, B> left<A, B>(A value) {
  return Left<A, B>(value);
}

/// An alias for `of`, used to wrap the given value in a `Right`.
///
/// Because `Either` has a bias towards `Right` as its successful representation,
/// the `right` function serves as an idiomatic alias for `of`.
///
/// Example usage:
/// ```dart
/// final either = right<int, String>('Hello');  // This will produce a Right('Hello')
/// ```
final right = of;

/// Wraps the given [value] in a `Right`, indicating the presence of a value of type `B`.
///
/// Example usage:
/// ```dart
/// final either = of<int, String>('Hello');  // This will be Right('Hello')
/// ```
/// @category lift
Either<A, B> of<A, B>(B value) {
  return Right<A, B>(value);
}

// C Function(Either<A, B>) match<A, B, C>(
//     C Function(A) onLeft, C Function(B) onRight) {
//   return (Either<A, B> either) => switch (either) {
//         Left(value: var leftValue) => onLeft(leftValue),
//         Right(value: var rightValue) => onRight(rightValue)
//       };
// }

/// Swaps the inner types of an `Either` value.
///
/// If the provided `Either` is a `Left`, the resulting value will be a `Right`
/// with the same inner value, and vice versa.
///
/// Example:
/// ```dart
/// final leftValue = Left<String, int>('error');
/// final swappedToLeft = swap(leftValue);
/// print(swappedToLeft);  // Outputs: Right('error')
///
/// final rightValue = Right<String, int>(42);
/// final swappedToRight = swap(rightValue);
/// print(swappedToRight);  // Outputs: Left(42)
/// ```
///
/// [either]: The `Either` value to be swapped.
/// Returns: A new `Either` value with swapped inner types.
Either<B, A> swap<A, B>(Either<A, B> either) {
  switch (either) {
    case Left(value: var leftValue):
      return Right<B, A>(leftValue);
    case Right(value: var rightValue):
      return Left<B, A>(rightValue);
  }
}

/// A function that takes a predicate and a function that produces a leftValue.
/// It returns a function that takes a value and returns an `Either` that is `Right` with the provided
/// value if the predicate returns true for this value, and `Left` with the provided value if the predicate
/// returns false.
///
/// Example usage:
/// ```dart
/// var eitherFromPredicate = fromPredicate<String, int>((value) => value > 0, () => 'Negative value');
/// // returns a function
///
/// Either<String, int> either1 = eitherFromPredicate(42);  // This will be Right(42)
/// Either<String, int> either2 = eitherFromPredicate(-1);  // This will be Left('Negative value')
/// ```
/// @category lift
Either<A, B> Function(B value) fromPredicate<A, B>(
        Predicate<B> predicate, A Function() leftValue) =>
    (B value) =>
        predicate(value) ? right<A, B>(value) : left<A, B>(leftValue());

// Either<A, B> fromPredicate<A, B>(Predicate<A> predicate, A value) {
//   return predicate(value) ? Right<A>(value) : Left<B>();
// }

/// A function that takes a function that produces a leftValue and returns a function that
/// converts an [Option] into an `Either` that is `Left` with the provided value if the option is `None`,
/// and `Right` with the value from `Some` if the option is `Some`.
///
/// Example usage:
/// ```dart
/// Option<int> someOption = Some(42);
/// Option<int> noneOption = const None();
///
/// var eitherFromOption = fromOption<String, int>(() => 'No value'); // returns a function
/// Either<String, int> either1 = eitherFromOption(someOption);  // This will be Right(42)
/// Either<String, int> either2 = eitherFromOption(noneOption);  // This will be Left('No value')
/// ```
/// @category lift
Either<A, B> Function(Option<B> option) fromOption<A, B>(
        A Function() leftValue) =>
    (Option<B> option) =>
        option is Some<B> ? right<A, B>(option.value) : left<A, B>(leftValue());

/// Maps the [either] `Either<A, B>` to `Either<A, C>` by applying the function [f] if [either] is `Right`.
///
/// Example usage:
/// ```dart
/// final either = right<int, String>('Hello');
/// final result = map(either, (value) => value.length);
/// print(result);  // This will print Right(5)
/// ```
Either<A, C> map<A, B, C>(Either<A, B> either, C Function(B) f) {
  switch (either) {
    case Right(value: var rightValue):
      return Right<A, C>(f(rightValue));
    case Left(value: var leftValue):
      return Left<A, C>(leftValue);
  }
}

/// Applies the function [f] to the value in the `Either` [either],
/// if it is a `Right`, and assumes [f] returns an `Either`.
/// If [either] is `Left`, returns `Left`.
///
/// Example usage:
/// ```dart
/// final either = right<int, String>('Hello');
/// final result = flatMap(either, (value) => right<int, int>(value.length));
/// print(result);  // This will print Right(5)
/// ```
Either<A, C> flatMap<A, B, C>(Either<A, B> either, Either<A, C> Function(B) f) {
  switch (either) {
    case Right(value: var rightValue):
      return f(rightValue);
    case Left(value: var leftValue):
      return Left<A, C>(leftValue);
  }
}

/// Alias for [flatMap].
final chain = flatMap;

/// Applies the function wrapped in an `Either` [fEither] to the value in the `Either` [m],
/// if both [fEither] and [m] are `Right`, and wraps the result in an `Either`.
/// If either [fEither] or [m] is `Left`, returns `Left`.
///
/// Example usage:
/// ```dart
/// final fEither = right<int, String Function(int)>((value) => 'Hello $value');
/// final m = right<int, int>(42);
/// final result = ap(fEither, m);
/// print(result);  // This will print Right('Hello 42')
/// ```
Either<A, B> ap<A, B, C>(Either<A, B Function(C)> fEither, Either<A, C> m) {
  switch (fEither) {
    case Left(value: var leftFuncValue):
      return Left<A, B>(leftFuncValue);
    case Right(value: var func):
      switch (m) {
        case Left(value: var leftValue):
          return Left<A, B>(leftValue);
        case Right(value: var rightValue):
          return Right<A, B>(func(rightValue));
      }
  }
}

typedef TapFunction<A, B> = Either<A, B> Function(Either<A, B> either);

/// Takes an [Either<A, B>] and applies a function to the Right value if it exists.
/// The [tap] function is often used for debugging or performing side effects.
///
/// Example:
///
/// ```dart
/// void main() {
///   final right = Right(5);
///   final tapFn = tap((value) => print("Right value: $value"));
///   tapFn(right);  // Prints: Right value: 5
/// }
/// ```
TapFunction<A, B> tap<A, B>(void Function(B) f) {
  return (Either<A, B> either) {
    if (either is Right<A, B>) {
      final Right<A, B> right = either;
      f(right.value);
    }
    return either;
  };
}

/// Alias for [tap].
///
/// Provides a side effect function [Function] that is applied to the value
final chainFirst = tap;

/// Matches an [Either<A, B>] to execute a function based on its Left or Right value.
/// Using Dart's pattern matching, the [match] function provides an expressive
/// and concise way to handle `Either` values without manual type checks.
///
/// The returned function uses pattern matching on [Either<A, B>] and invokes
/// the relevant function (`onLeft` for `Left` or `onRight` for `Right`) based on the match.
///
/// Example:
///
/// ```dart
/// void main() {
///   final right = Right(5);
///   final left = Left("Error");
///   final matchFn = match(
///     (error) => "It's Left with value: $error",
///     (value) => "It's Right with value: $value"
///   );
///   print(matchFn(right));  // Prints: It's Right with value: 5
///   print(matchFn(left));  // Prints: It's Left with value: Error
/// }
/// ```
C Function(Either<A, B>) match<A, B, C>(
    C Function(A) onLeft, C Function(B) onRight) {
  return (Either<A, B> either) => switch (either) {
        Left(value: var leftValue) => onLeft(leftValue),
        Right(value: var rightValue) => onRight(rightValue)
      };
}

/// Alias for [match].
///
/// Provides a way to handle an [Either] by executing a function based on its value.
final fold = match;

/// Gets the value of the Right if it exists, otherwise returns a default value.
///
/// Example:
///
/// ```dart
/// void main() {
///   final right = Right(5);
///   final left = Left("Error");
///   print(getOrElse(right, () => 0));  // Prints: 5
///   print(getOrElse(left, () => 0));  // Prints: 0
/// }
/// ```
B getOrElse<A, B>(Either<A, B> either, B Function() defaultFunction) {
  if (either is Right<A, B>) {
    return either.value;
  }
  return defaultFunction();
}

/// Defines equality for instances of `Either`.
///
/// The equality of two `Either` instances depends on the equality of the values
/// they contain (if any). For this purpose, this class requires two instances of
/// `Eq<A>` and `Eq<B>` for the types of the values the `Either` might hold.
///
/// ```dart
/// final intEq = Eq.fromEquals((int x, int y) => x == y);
/// final strEq = Eq.fromEquals((String x, String y) => x == y);
/// final eitherEq = getEq(intEq, strEq);
///
/// expect(eitherEq.equals(Right(1), Right(1)), true);
/// expect(eitherEq.equals(Right(1), Right(2)), false);
/// expect(eitherEq.equals(Right(1), Left("Error")), false);
/// expect(eitherEq.equals(Left("Error"), Left("Error")), true);
/// ```
class EitherEq<A, B> implements Eq<Either<A, B>> {
  /// The `Eq` instance for the type of the values the `Either` might hold.
  final Eq<A> leftEq;
  final Eq<B> rightEq;

  /// Constructs an instance of `EitherEq`.
  ///
  /// Requires an instance of `Eq<A>` and `Eq<B>`.
  EitherEq(this.leftEq, this.rightEq);

  @override
  bool equals(Either<A, B> x, Either<A, B> y) {
    // Short-circuit if they are identical (or both null).
    if (identical(x, y)) return true;

    // If both are Left, delegate to the contained Eq<A>.
    if (x is Left<A, B> && y is Left<A, B>) {
      return leftEq.equals(x.value, y.value);
    }

    // If both are Right, delegate to the contained Eq<B>.
    if (x is Right<A, B> && y is Right<A, B>) {
      return rightEq.equals(x.value, y.value);
    }

    // In all other cases they are not equal.
    return false;
  }
}

/// Returns an `Eq` for `Either<A, B>`, given an `Eq<A>` and `Eq<B>`.
///
/// ```dart
/// final intEq = Eq.fromEquals((int x, int y) => x == y);
/// final strEq = Eq.fromEquals((String x, String y) => x == y);
/// final eitherEq = getEq(intEq, strEq);
///
/// expect(eitherEq.equals(Right(1), Right(1)), true);
/// expect(eitherEq.equals(Right(1), Right(2)), false);
/// expect(eitherEq.equals(Right(1), Left("Error")), false);
/// expect(eitherEq.equals(Left("Error"), Left("Error")), true);
/// ```
Eq<Either<A, B>> getEq<A, B>(Eq<A> leftEq, Eq<B> rightEq) {
  return EitherEq<A, B>(leftEq, rightEq);
}

/// A class that extends `Ord` to provide a custom ordering for `Either` values.
///
/// This class provides a way to compare two `Either` values based on the
/// provided orderings for the `Left` and `Right` types.
///
/// If both `Either` values are `Left`, they are compared using the provided
/// `leftOrd`. If both are `Right`, they are compared using the provided `rightOrd`.
///
/// If one is `Left` and the other is `Right`, `Left` is considered to come before `Right`.
///
/// Example usage:
/// ```dart
/// final intOrder = Ord<int>((a, b) => a.compareTo(b));
/// final strOrder = Ord<String>((a, b) => a.compareTo(b));
///
/// final eitherOrder = EitherOrd(intOrder, strOrder);
///
/// final e1 = Left<int, String>(3);
/// final e2 = Left<int, String>(5);
/// final e3 = Right<int, String>("apple");
/// final e4 = Right<int, String>("banana");
///
/// print(eitherOrder.compare(e1, e2)); // -1 because 3 < 5
/// print(eitherOrder.compare(e3, e4)); // -1 because "apple" < "banana"
/// print(eitherOrder.compare(e1, e3)); // -1 because Left always comes before Right
/// ```
class EitherOrd<A, B> extends Ord<Either<A, B>> {
  final Ord<A> leftOrd;
  final Ord<B> rightOrd;

  EitherOrd(this.leftOrd, this.rightOrd)
      : super((Either<A, B> x, Either<A, B> y) {
          if (identical(x, y)) return 0;

          switch (x) {
            case Left(value: var leftXValue):
              if (y is Left<A, B>) {
                return leftOrd.compare(leftXValue, y.value);
              }
              return -1;

            case Right(value: var rightXValue):
              if (y is Right<A, B>) {
                return rightOrd.compare(rightXValue, y.value);
              }
              return 1;
          }
        });

  @override
  bool equals(Either<A, B> x, Either<A, B> y) => compare(x, y) == 0;
}

/// Returns an [Ord] instance for comparing `Either` values based on the provided
/// orderings for the `Left` and `Right` types.
///
/// This function wraps around [EitherOrd] to provide a convenient way to get an
/// ordering for `Either` values. The behavior of comparison follows the same rules
/// as described in [EitherOrd].
///
/// Example usage:
/// ```dart
/// final intOrder = Ord<int>((a, b) => a.compareTo(b));
/// final strOrder = Ord<String>((a, b) => a.compareTo(b));
///
/// final eitherOrder = getOrd(intOrder, strOrder);
///
/// final e1 = Left<int, String>(3);
/// final e2 = Left<int, String>(5);
/// final e3 = Right<int, String>("apple");
/// final e4 = Right<int, String>("banana");
///
/// print(eitherOrder.compare(e1, e2)); // -1 because 3 < 5
/// print(eitherOrder.compare(e3, e4)); // -1 because "apple" < "banana"
/// print(eitherOrder.compare(e1, e3)); // -1 because Left always comes before Right
/// ```
///
/// - [leftOrd]: The ordering to be used for comparing `Left` values.
/// - [rightOrd]: The ordering to be used for comparing `Right` values.
///
/// Returns: An instance of [EitherOrd] with the provided orderings.
Ord<Either<A, B>> getOrd<A, B>(Ord<A> leftOrd, Ord<B> rightOrd) {
  return EitherOrd<A, B>(leftOrd, rightOrd);
}

/// Takes an `ImmutableList` of `Either` values and attempts to extract their right-hand values.
///
/// This function iterates through each `Either` value in the input list.
/// If any of them is a `Left`, the function immediately returns that `Left` value.
/// If all are `Right` values, it collects them into an `ImmutableList` and wraps it in a `Right`.
///
/// ### Parameters:
/// - `list`: An `ImmutableList` of `Either` values to be processed.
///
/// ### Returns:
/// An `Either` containing an `ImmutableList` of the right-hand values.
/// Returns the first `Left` encountered while processing the input list.
///
/// ### Examples:
///
/// ```dart
/// var listOfEithers = il.ImmutableList<Either<String, int>>([
///   Right(1),
///   Right(2),
///   Right(3)
/// ]);
/// var result = sequenceList(listOfEithers);
/// print(result); // Outputs: Right(ImmutableList([1, 2, 3]))
/// ```
///
/// ```dart
/// var listOfEithersWithLeft = il.ImmutableList<Either<String, int>>([
///   Right(1),
///   Left("Error"),
///   Right(3)
/// ]);
/// var resultWithError = sequenceList(listOfEithersWithLeft);
/// print(resultWithError); // Outputs: Left("Error")
/// ```
Either<E, il.ImmutableList<A>> sequenceList<E, A>(
    il.ImmutableList<Either<E, A>> list) {
  final result = <A>[];

  for (var e in list) {
    switch (e) {
      case Left(value: var leftValue):
        return Left<E, il.ImmutableList<A>>(leftValue);
      case Right(value: var rightValue):
        result.add(rightValue);
    }
  }

  return Right(il.of(result));
}

/// Processes each item of an `ImmutableList` through a function `f` that returns an `Either`,
/// and collects the results into a new `ImmutableList`.
///
/// This function goes through each item of the provided list and applies the function `f` to it.
/// If at any point the function `f` returns a `Left`, the traversal is stopped,
/// and that `Left` value is returned immediately. If all items are successfully processed,
/// their results are collected into an `ImmutableList` wrapped in a `Right`.
///
/// ### Parameters:
/// - `f`: A function that takes an item of type `A` and returns an `Either` of type `E` or `B`.
/// - `list`: An `ImmutableList` of items of type `A` to be processed.
///
/// ### Returns:
/// An `Either` containing an `ImmutableList` of the processed items.
/// Returns the first `Left` encountered while processing the input list.
///
/// ### Examples:
///
/// ```dart
/// var myList = il.ImmutableList<int>([1, 2, 3]);
/// var result = traverseList((int item) => item > 1 ? Right(item) : Left("Error"), myList);
/// print(result); // Outputs: Left("Error")
/// ```
///
/// ```dart
/// var myListWithoutError = il.ImmutableList<int>([2, 3, 4]);
/// var successfulResult = traverseList((int item) => Right(item * 2), myListWithoutError);
/// print(successfulResult); // Outputs: Right(ImmutableList([4, 6, 8]))
/// ```
Either<E, il.ImmutableList<B>> traverseList<E, A, B>(
    Either<E, B> Function(A) f, il.ImmutableList<A> list) {
  final results = <B>[];

  for (final item in list) {
    final result = f(item);
    switch (result) {
      case Left(value: var leftValue):
        return Left<E, il.ImmutableList<B>>(leftValue);
      case Right(value: var rightValue):
        results.add(rightValue);
    }
  }

  return Right(il.of(results));
}
