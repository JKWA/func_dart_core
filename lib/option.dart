import 'package:func_dart_core/eq.dart';
import 'package:func_dart_core/list.dart' as il;
import 'package:func_dart_core/ord.dart';
import 'package:func_dart_core/predicate.dart';

/// Represents an optional value: every instance is either [Some], containing a value, or [None],
/// indicating the absence of a value. This pattern is an alternative to using nullable types
/// (`null`) for representing the absence of a value.
///
/// Typical usages include representing results which might fail, or optional function arguments.
///
/// Example:
///
/// ```dart
/// final someValue = Some(42);
/// final noValue = None<int>();
/// ```
sealed class Option<A> {
  const Option();
}

/// Represents an existing value of type [A]. It's a concrete implementation of [Option].
///
/// Use [Some] to encapsulate an actual value, as opposed to [None] which represents the absence
/// of a value.
///
/// Example:
///
/// ```dart
/// final optionValue = Some(42);
/// print(optionValue.value);  // Outputs: 42
/// ```
class Some<A> extends Option<A> {
  /// The encapsulated value of this [Some] instance.
  final A value;

  /// Constructs a [Some] instance encapsulating the provided [value].
  Some(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Some<A> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// Represents the absence of a value. It's a concrete implementation of [Option].
///
/// Use [None] to indicate that no value exists, typically in scenarios where
/// in other languages one might use `null` or `undefined`.
///
/// Example:
///
/// ```dart
/// final optionValue = None<int>();
/// ```
class None<A> extends Option<A> {
  const None();

  @override
  bool operator ==(Object other) => other is None<A>;

  @override
  int get hashCode => 0; // A chosen constant representing None's hash code
}

/// Wraps the given [value] in a `Some`, indicating the presence of a value.
///
/// Example usage:
/// ```dart
/// final someOption = of(42);  // This will be Some(42)
/// ```
Option<B> of<B>(B value) {
  return Some<B>(value);
}

/// A type refinement function to check if an [option] is of type `None`.
///
/// Example:
/// ```dart
/// Option<String> someOption = Some("Hello");
/// Option<int> noneOption = const None();
///
/// if (isNone(someOption)) {
///   print("This will not be executed because 'someOption' is not None.");
/// } else {
///   print("This will be executed because 'someOption' is not None.");
/// }
///
/// if (isNone(noneOption)) {
///   print("This will be executed because 'noneOption' is None.");
/// } else {
///   print("This will not be executed because 'noneOption' is None.");
/// }
/// ```
bool isNone<A>(Option<A> option) {
  return option is None<A>;
}

/// A refinement function to check if an [option] is of type `Some`.
///
/// Example:
/// ```dart
/// Option<String> someOption = Some("Hello");
/// Option<int> noneOption = const None();
///
/// if (isSome(someOption)) {
///   print("This will be executed because 'someOption' is Some.");
/// } else {
///   print("This will not be executed because 'someOption' is Some.");
/// }
///
/// if (isSome(noneOption)) {
///   print("This will not be executed because 'noneOption' is not Some.");
/// } else {
///   print("This will be executed because 'noneOption' is not Some.");
/// }
/// ```
bool isSome<A>(Option<A> option) {
  return option is Some<A>;
}

/// Returns an [Option] based on the evaluation of a [Predicate] on a value.
///
/// This function takes in a predicate (a function that returns a boolean) and
/// a value of type `A`. It applies the predicate to the value.
///
/// If the predicate is true for the given value, this function will return
/// [Some] containing the value. If the predicate is false, it will return [None].
///
/// Example usage:
/// ```dart
/// final isEven = (int value) => value % 2 == 0;
/// final evenOption = fromPredicate(isEven, 4);  // This will be Some(4)
/// final oddOption = fromPredicate(isEven, 5);  // This will be None
/// ```
///
/// [fromPredicate] can be useful for performing validation checks and error handling.
/// If the predicate function represents a validation check, [fromPredicate] can be used
/// to create an [Option] that is [Some] if the validation check passes and [None] if it fails.
Option<A> fromPredicate<A>(Predicate<A> predicate, A value) {
  return predicate(value) ? Some(value) : None();
}

/// Returns an [Option] from a nullable value.
///
/// This function takes in a nullable value of type `A?`.
///
/// If the given value is non-null, this function will return
/// [Some] containing the value. If the value is null, it will return [None].
///
/// Example usage:
/// ```dart
/// final someOption = fromNullable(42);  // This will be Some(42)
/// final noneOption = fromNullable<int>(null);  // This will be None
/// ```
///
/// [fromNullable] can be useful for dealing with nullable values in a type-safe way.
/// Rather than dealing with nullability throughout your code, you can encapsulate
/// nullability in an [Option] and work with that instead.
Option<A> fromNullable<A>(A? value) {
  return value != null ? Some(value) : None();
}

/// Applies the function [f] to the value in the `Option` [option],
/// if it is a `Some`. If [option] is `None`, returns `None`.
/// This operation is known as 'map' in functional programming.
///
/// Example usage:
/// ```dart
/// final option1 = Some(5);
/// final option2 = map(option1, (value) => value * 2);  // This will be Some(10)
/// final option3 = map(None(), (value) => value * 2);  // This will be None
/// ```
Option<B> map<A, B>(Option<A> option, B Function(A) f) {
  if (option is Some<A>) {
    return Some<B>(f(option.value));
  } else {
    return None<B>();
  }
}

/// Applies the function [f] to the value in the `Option` [option],
/// if it is a `Some`, and assumes [f] returns an `Option`.
/// If [option] is `None`, returns `None`.
/// This operation is known as 'flatMap', 'chain', or 'bind' in functional programming.
///
/// Example usage:
/// ```dart
/// final option1 = Some(5);
/// final option2 = flatMap(option1, (value) => Some(value * 2));  // This will be Some(10)
/// final option3 = flatMap(None(), (value) => Some(value * 2));  // This will be None
/// ```
Option<B> flatMap<A, B>(Option<A> option, Option<B> Function(A) f) {
  if (option is Some<A>) {
    return f(option.value);
  } else {
    return None<B>();
  }
}

/// Alias for [flatMap].
///
/// Provides a way to handle an [Option] by chaining function calls.
final chain = flatMap;

/// Applies the function wrapped in an `Option` [fOpt] to the value in the `Option` [m],
/// if both [fOpt] and [m] are `Some`, and wraps the result in an `Option`.
/// If either [fOpt] or [m] is `None`, returns `None`.
/// This operation is known as 'ap' or 'apply' in functional programming.
///
/// Example usage:
/// ```dart
/// final option1 = Some((value) => value * 2);
/// final option2 = Some(5);
/// final option3 = ap(option1, option2);  // This will be Some(10)
/// ```
Option<B> ap<A, B>(Option<B Function(A)> fOpt, Option<A> m) {
  return flatMap(fOpt, (B Function(A) f) {
    return map(m, f);
  });
}

/// The [tap] function takes a side effect function [Function] that is applied to the value
/// inside the [Some] instance of [Option]. It returns the original [Option] after
/// performing the side effect on the value. If the input [Option] is [None], the
/// function simply returns the same [None].
///
/// This function allows you to perform side effects like printing or logging the
/// value inside [Some] without changing the value itself.
///
/// The [tap] function is commonly used in functional programming to observe values
/// in a container without modifying them.
///
/// Example:
///
/// ```dart
/// void main() {
///   Option<String> someOption = Some("Hello");
///   Option<String> noneOption = const None();
///
///   // Printing the value inside Some without modifying the value
///   tap<String>((value) => print("Value inside Some: $value"))(someOption); // Output: Value inside Some: Hello
///
///   // Since it's None, nothing will be printed
///   tap<String>((value) => print("Value inside None: $value"))(noneOption); // No output
/// }
/// ```
typedef TapFunction<A> = Option<A> Function(Option<A> option);

/// Curries the [tap] function by taking a side effect function [f]. It returns a
/// specialized version of the [tap] function that can be used to apply the side
/// effect on an [Option<A>] instance directly without specifying the side effect
/// function again.
///
/// Example:
///
/// ```dart
/// void main() {
///   Option<String> someOption = Some("Hello");
///   Option<String> noneOption = const None();
///
///   // Create a specialized version of tap for printing strings
///   final printString = tap<String>((value) => print("Value inside Some: $value"));
///
///   // Use the specialized version of tap to print the value inside the Some
///   printString(someOption); // Output: Value inside Some: Hello
///
///   // Use the same specialized version of tap to print the value inside the None
///   printString(noneOption); // No output
/// }
/// ```
TapFunction<A> tap<A>(void Function(A) f) {
  return (Option<A> option) {
    if (option is Some<A>) {
      final Some<A> some = option;
      f(some.value);
    }
    return option;
  };
}

/// Alias for [tap].
///
/// Provides a side effect function [Function] that is applied to the value
final chainFirst = tap;

/// A function to process an `Option` value. If [Option] is an instance of `Some`,
/// the function [onSome] will be invoked with the encapsulated value.
/// If [Option] is `None`, then [onNone] will be called.
///
/// In Dart, you can't use a switch statement to check if a value is an instance
/// of a generic class.
///
/// Generic classes in Dart are a compile-time concept that get "erased" at runtime,
/// they aren't preserved in a way that would allow them to be checked using a
/// switch statement or similar construct. This is known as type erasure.
///
/// This is a form of pattern matching adapted for Dart.
/// The returned function takes an `Option<A>` and returns a value of type `B`.
///
/// Example usage:
/// ```dart
/// final option1 = Some(5);
/// final option2 = None();
/// final matchFn = match(() => "It's None", (value) => "It's Some with value: $value");
/// print(matchFn(option1));  // Prints: It's Some with value: 5
/// print(matchFn(option2));  // Prints: It's None
/// ```
B Function(Option<A>) match<A, B>(B Function() onNone, B Function(A) onSome) {
  return (Option<A> option) {
    if (option is Some<A>) {
      return onSome(option.value);
    }
    return onNone();
  };
}

/// Alias for [match].
///
/// Provides a way to handle an [Option] by executing a function based on its value.
final fold = match;

/// Returns the value from [option] if it is a `Some`.
/// Otherwise, it returns the result of invoking [defaultFunction].
///
/// The [defaultFunction] is a callback that is lazily invoked, which means it is not run
/// until needed, specifically when [option] is a `None`.
///
/// Example:
/// ```dart
/// final option1 = Some(5);
/// print(getOrElse(option1, () => 10));  // Prints: 5
///
/// final option2 = None();
/// print(getOrElse(option2, () => 10));  // Prints: 10
/// ```
A getOrElse<A>(Option<A> option, A Function() defaultFunction) {
  if (option is Some<A>) {
    return option.value;
  }
  return defaultFunction();
}

/// Defines equality for instances of `Option`.
///
/// The equality of two `Option` instances depends on the equality of the values
/// they contain (if any). For this purpose, this class requires an instance of
/// `Eq<A>` for the type of the values the `Option` might hold.
///
/// ```dart
/// final intEq = Eq.fromEquals((int x, int y) => x == y);
/// final optionEq = getEq(intEq);
///
/// expect(optionEq.equals(Some(1), Some(1)), true);
/// expect(optionEq.equals(Some(1), Some(2)), false);
/// expect(optionEq.equals(Some(1), None()), false);
/// expect(optionEq.equals(None(), None()), true);
/// ```
class OptionEq<A> implements Eq<Option<A>> {
  /// The `Eq` instance for the type of the values the `Option` might hold.
  final Eq<A> eq;

  /// Constructs an instance of `OptionEq`.
  ///
  /// Requires an instance of `Eq<A>`.
  OptionEq(this.eq);

  @override
  bool equals(Option<A> x, Option<A> y) {
    // Short-circuit if they are identical (or both null).
    if (identical(x, y)) return true;

    // If both are None, they are equal.
    if (x is None<A> && y is None<A>) return true;

    // If both are Some, delegate to the contained Eq<A>.
    if (x is Some<A> && y is Some<A>) return eq.equals(x.value, y.value);

    // In all other cases they are not equal.
    return false;
  }
}

/// Returns an `Eq` for `Option<A>`, given an `Eq<A>`.
///
/// ```dart
/// final intEq = Eq.fromEquals((int x, int y) => x == y);
/// final optionEq = getEq(intEq);
///
/// expect(optionEq.equals(Some(1), Some(1)), true);
/// expect(optionEq.equals(Some(1), Some(2)), false);
/// expect(optionEq.equals(Some(1), None()), false);
/// expect(optionEq.equals(None(), None()), true);
/// ```
Eq<Option<A>> getEq<A>(Eq<A> eq) {
  return OptionEq<A>(eq);
}

/// `OptionOrd` extends `Ord<Option<A>>`, which is a type that provides
/// comparison and ordering functionalities for `Option` instances.
///
/// It is parameterized by `A`, the type of element contained in the `Option`.
///
/// Equality is determined by the `eq` instance passed into `OptionOrd`'s constructor,
/// and comparison is determined by the order of the options: `None` is considered
/// less than `Some`, and for two `Some` instances, comparison is done based on the
/// values they contain.
class OptionOrd<A> extends Ord<Option<A>> {
  final Ord<A> ord;

  OptionOrd(this.ord)
      : super((Option<A> x, Option<A> y) {
          if (identical(x, y)) return 0;

          if (x is None<A> && y is None<A>) return 0;

          if (x is None<A> && y is Some<A>) return -1;

          if (x is Some<A> && y is None<A>) return 1;

          if (x is Some<A> && y is Some<A>) {
            return ord.compare(x.value, y.value);
          }

          throw StateError('Unreachable state');
        });

  @override
  bool equals(Option<A> x, Option<A> y) => compare(x, y) == 0;
}

/// Returns an `Ord<Option<A>>` based on the provided `Ord<A>`.
///
/// Example usage:
/// ```dart
/// final ordInt = Ord.fromCompare((int x, int y) => x.compareTo(y));
/// final optionOrdInt = getOrd(ordInt);
///
/// assert(optionOrdInt.compare(Some(2), Some(3)) < 0);
/// assert(optionOrdInt.compare(Some(3), Some(2)) > 0);
/// assert(optionOrdInt.compare(Some(2), Some(2)) == 0);
/// assert(optionOrdInt.compare(None(), Some(2)) < 0);
/// assert(optionOrdInt.compare(Some(2), None()) > 0);
/// assert(optionOrdInt.compare(None(), None()) == 0);
/// ```
Ord<Option<A>> getOrd<A>(Ord<A> ord) {
  return OptionOrd<A>(ord);
}

// Option<il.ImmutableList<B>> sequenceList<B>(il.ImmutableList<Option<B>> list) {
//   return list.fold<Option<il.ImmutableList<B>>>(of(il.ImmutableList([])),
//       (acc, opt) => ap(map(acc, (curr) => (B b) => il.append(b)(curr)), opt));
// }

/// Takes an `ImmutableList` of `Option` values and returns an `Option` containing
/// an `ImmutableList` of values.
///
/// If any of the `Option` values in the input list is `None`, this function
/// returns `None`. Otherwise, it collects all the values inside the `Some` variants
/// into an `ImmutableList` and wraps it in a `Some`.
///
/// ### Parameters:
/// - `list`: An `ImmutableList` of `Option` values.
///
/// ### Returns:
/// An `Option` containing an `ImmutableList` of the values from the input list.
/// Returns `None` if any of the input values is `None`.
///
/// ### Examples:
///
/// ```dart
/// var listOfOptions = il.ImmutableList<Option<int>>([
///   Some(1),
///   Some(2),
///   Some(3)
/// ]);
/// var result = sequenceList(listOfOptions);
/// print(result); // Outputs: Some(ImmutableList([1, 2, 3]))
/// ```
///
/// ```dart
/// var listOfOptionsWithNone = il.ImmutableList<Option<int>>([
///   Some(1),
///   None(),
///   Some(3)
/// ]);
/// var resultWithNone = sequenceList(listOfOptionsWithNone);
/// print(resultWithNone); // Outputs: None
/// ```
Option<il.ImmutableList<A>> sequenceList<A>(il.ImmutableList<Option<A>> list) {
  final result = <A>[];

  for (var opt in list) {
    if (opt is None<A>) return None();
    result.add((opt as Some<A>).value);
  }

  return Some(il.of(result));
}

/// Takes an `ImmutableList` and a function, then applies the function to each item in the list.
///
/// This function maps each element of the input list to an `Option` using the provided function `fn`.
/// If the result of applying `fn` to any element is `None`, this function returns `None`.
/// Otherwise, it collects all the values inside the `Some` variants into an `ImmutableList`
/// and wraps it in a `Some`.
///
/// ### Parameters:
/// - `fn`: A function that takes a value of type `A` and returns an `Option` of type `B`.
/// - `list`: An `ImmutableList` of values to be mapped using the function `fn`.
///
/// ### Returns:
/// An `Option` containing an `ImmutableList` of the mapped values.
/// Returns `None` if the result of mapping any input value is `None`.
///
/// ### Examples:
///
/// ```dart
/// var listOfInts = il.ImmutableList<int>([1, 2, 3]);
/// Option<int> addOne(int x) => Some(x + 1);
/// var result = traverseList(addOne, listOfInts);
/// print(result); // Outputs: Some(ImmutableList([2, 3, 4]))
/// ```
///
/// ```dart
/// Option<int> returnNoneForThree(int x) => x == 3 ? None() : Some(x);
/// var resultWithNone = traverseList(returnNoneForThree, listOfInts);
/// print(resultWithNone); // Outputs: None
/// ```
Option<il.ImmutableList<B>> traverseList<A, B>(
    Option<B> Function(A) fn, il.ImmutableList<A> list) {
  return list.fold(Some(il.ImmutableList<B>([])),
      (Option<il.ImmutableList<B>> acc, A item) {
    Option<B> mappedItem = fn(item);
    if (acc is Some<il.ImmutableList<B>> && mappedItem is Some<B>) {
      return Some(il.append(mappedItem.value)(acc.value));
    } else {
      return None<il.ImmutableList<B>>();
    }
  });
}
