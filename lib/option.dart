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

/// An alias for `of`, used to wrap the given value.
///
/// This function provides a convenient way to wrap a given value, making it
/// easier to use or represent in certain situations.
///
/// Example usage:
/// ```dart
/// final wrappedValue = some<int>('Hello');  // This will wrap the 'Hello' value
/// ```
final some = of;

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

/// A more generalized match function for `Option` that returns a value of a potentially different type.
///
/// This function facilitates pattern matching on an `Option<A>`, executing one of the provided functions
/// based on whether the `Option` is a `Some` or `None`. It is more flexible than the standard `match` function
/// by allowing the return types of `onSome` and `onNone` to differ.
///
/// Parameters:
/// - `onNone`: A function that gets called if the `Option` is a `None`. It returns a value of type `C`.
/// - `onSome`: A function that gets called if the `Option` is a `Some`. It accepts a value of type `A` and
///             returns a value of type `C`.
///
/// Returns:
/// - A function that accepts an `Option<A>` and returns a value of type `C`.
///
/// Example:
/// ```dart
/// final option = Some(5);
/// final result = matchW<int, String, String>(
///   () => "It's None",
///   (value) => "Value is: $value"
/// )(option);
/// print(result);  // Outputs: Value is: 5
/// ```
C Function(Option<A>) matchW<A, B, C>(
        C Function() onNone, C Function(A) onSome) =>
    (Option<A> option) =>
        switch (option) { None() => onNone(), Some(value: var v) => onSome(v) };

// C Function(Either<A, B>) match<A, B, C>(
//     C Function(A) onLeft, C Function(B) onRight) {
//   return (Either<A, B> either) => switch (either) {
//         Left(value: var leftValue) => onLeft(leftValue),
//         Right(value: var rightValue) => onRight(rightValue)
//       };
// }

/// A pattern matching function for `Option` that provides branching based on the content of the `Option`.
///
/// This function facilitates pattern matching on an `Option<A>`, executing one of the provided functions
/// based on whether the `Option` is a `Some` or `None`. Both `onSome` and `onNone` functions have the same
/// return type in this variation of the match function.
///
/// Parameters:
/// - `onNone`: A function that gets called if the `Option` is a `None`. It returns a value of type `B`.
/// - `onSome`: A function that gets called if the `Option` is a `Some`. It accepts a value of type `A` and
///             returns a value of type `B`.
///
/// Returns:
/// - A function that accepts an `Option<A>` and returns a value of type `B`.
///
/// Example:
/// ```dart
/// final option = Some(5);
/// final result = match<int, String>(
///   () => "It's None",
///   (value) => "Value is: $value"
/// )(option);
/// print(result);  // Outputs: Value is: 5
/// ```
B Function(Option<A>) match<A, B>(B Function() onNone, B Function(A) onSome) {
  return matchW<A, B, B>(onNone, onSome);
}

/// Alias for [match].
///
/// Provides a way to handle an [Option] by executing a function based on its value.
final fold = match;

/// Transforms the value inside an [Option] using a given function.
///
/// The `map` function is used to apply a transformation to the value wrapped inside an [Option].
/// If the input [Option] is [None], the result will also be [None].
/// If the input [Option] contains a value, the transformation function will be applied to that value,
/// and the transformed value will be wrapped in a [Some] instance.
///
/// Example:
/// ```dart
/// Option<int> someValue = Some(5);
///
/// var squared = map<int, int>((x) => x * x)(someValue);  // Should result in Some(25)
///
/// var noneInput = map<int, int>((x) => x + 5)(None());   // Should result in None
/// ```
///
/// @param f A function that takes a value of type `A` and returns a value of type `B`.
/// @return A function that takes an [Option] of type `A` and returns an [Option] of type `B`.
Option<B> Function(Option<A> p1) map<A, B>(B Function(A) f) =>
    match<A, Option<B>>(() => None<B>(), (a) => Some<B>(f(a)));

/// Transforms the value inside an [Option] using a function that returns an [Option].
///
/// `flatMap` is used to apply a function that returns an [Option] to the value wrapped inside another [Option].
/// If the input [Option] is [None], the result will also be [None].
/// If the input [Option] contains a value, the function will be applied to that value, and the resulting [Option] is returned.
///
/// Example:
/// ```dart
/// Option<int> someValue = Some(10);
///
/// var doubled = flatMap<int, int>((x) => Some(x * 2))(someValue);  // Should result in Some(20)
///
/// var noneResult = flatMap<int, int>((x) => None())(someValue);    // Should result in None
///
/// var noneInput = flatMap<int, int>((x) => Some(x + 5))(None());  // Should result in None
/// ```
///
/// @param f A function that takes a value of type `A` and returns an [Option] of type `B`.
/// @return A function that takes an [Option] of type `A` and returns an [Option] of type `B`.
Option<B> Function(Option<A>) flatMap<A, B>(Option<B> Function(A) f) =>
    match<A, Option<B>>(() => None<B>(), (a) => f(a));

/// Alias for [flatMap].
///
/// Provides a way to handle an [Option] by chaining function calls.
final chain = flatMap;

/// Applies a function wrapped in an [Option] to a value also wrapped in an [Option].
///
/// Given an [Option] of a function, and an [Option] of a value, it will return an
/// [Option] of the result. If either the function or the value is [None], the result will also be [None].
///
/// Example:
/// ```dart
/// Option<int Function(int)> someFunction = Some((int x) => x * 2);
/// Option<int> someValue = Some(10);
///
/// var result = ap(someFunction)(someValue);  // Should result in Some(20)
///
/// Option<int Function(int)> noFunction = None();
///
/// var resultWithNoneFunction = ap(noFunction)(someValue);  // Should result in None
/// ```
///
/// @param fOpt An [Option] containing a function of type `B Function(A)`.
/// @return A function that takes an [Option] of type `A` and returns an [Option] of type `B`.
Option<B> Function(Option<A>) ap<A, B>(Option<B Function(A)> fOpt) =>
    (Option<A> m) => flatMap<B Function(A), B>((f) => map<A, B>(f)(m))(fOpt);

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

/// Returns a function that, when provided with an `Option<A>`,
/// will yield the value inside if it's a `Some`,
/// or the result of the `defaultFunction` if it's a `None`.
///
/// The returned function acts as a safe way to extract a value from
/// an `Option`, providing a fallback mechanism when dealing with `None` values.
///
/// Usage:
/// ```dart
/// final option1 = Some(10);
/// final option2 = None<int>();
/// final fallback = () => 5;
///
/// final value1 = getOrElse(fallback)(option1); // returns 10
/// final value2 = getOrElse(fallback)(option2); // returns 5
/// ```
///
/// Parameters:
/// - `defaultFunction`: A function that returns a value of type `A`.
///   This value will be returned if the provided `Option` is a `None`.
///
/// Returns:
/// A function expecting an `Option<A>` and returning a value of type `A`.
A Function(Option<A>) getOrElse<A>(A Function() defaultFunction) {
  return match<A, A>(() => defaultFunction(), (someValue) => someValue);
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

/// Provides an ordering for `Option<A>` based on an existing ordering for `A`.
///
/// This is particularly useful when `Option<A>` values need to be sorted
/// or otherwise ordered based on the encapsulated value.
///
/// Given an ordering for type `A` (provided by `Ord<A>`), the ordering for
/// `Option<A>` is defined as follows:
/// - `None` is considered less than any `Some<A>` value.
/// - Two `None` values are considered equal.
/// - Two `Some<A>` values are compared based on their encapsulated `A` values.
///
/// Example usage:
/// ```dart
/// final ordInt = IntOrd();
/// final ordOptionInt = OptionOrd(ordInt);
/// final result = ordOptionInt.compare(Some(3), Some(5)); // This will return a negative number
/// final isEqual = ordOptionInt.equals(None(), None());  // This will return true
/// ```
class OptionOrd<A> extends Ord<Option<A>> {
  final Ord<A> ord;

  OptionOrd(this.ord)
      : super((Option<A> x, Option<A> y) {
          if (identical(x, y)) return 0;

          switch (x) {
            case None():
              return (y is Some<A>) ? -1 : 0;

            case Some(value: var someValueX):
              return match<A, int>(() => 1,
                  (someValueY) => ord.compare(someValueX, someValueY))(y);
          }
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
  final results = <A>[];

  for (var opt in list) {
    switch (opt) {
      case Some(value: var someValue):
        results.add(someValue);
        break;
      case None():
        return None();
    }
  }

  return Some(il.of(results));
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
///
/// ### Returns:
/// A curried function that takes an `ImmutableList` of values of type `A` and returns
/// an `Option` containing an `ImmutableList` of the mapped values of type `B`.
/// Returns `None` if the result of mapping any input value is `None`.
///
/// ### Examples:
///
/// ```dart
/// var listOfInts = il.ImmutableList<int>([1, 2, 3]);
/// Option<int> addOne(int x) => Some(x + 1);
/// var traverseFn = traverseList(addOne);
/// var result = traverseFn(listOfInts);
/// print(result); // Outputs: Some(ImmutableList([2, 3, 4]))
/// ```
///
/// ```dart
/// Option<int> returnNoneForThree(int x) => x == 3 ? None() : Some(x);
/// var traverseFnWithNone = traverseList(returnNoneForThree);
/// var resultWithNone = traverseFnWithNone(listOfInts);
/// print(resultWithNone); // Outputs: None
/// ````
Option<il.ImmutableList<B>> Function(il.ImmutableList<A>) traverseList<A, B>(
    Option<B> Function(A) fn) {
  Option<il.ImmutableList<B>> foldFn(Option<il.ImmutableList<B>> acc, A item) {
    return match<il.ImmutableList<B>, Option<il.ImmutableList<B>>>(
        () => None<il.ImmutableList<B>>(), (il.ImmutableList<B> accList) {
      Option<B> resultOption = fn(item);
      return match<B, Option<il.ImmutableList<B>>>(
          () => None<il.ImmutableList<B>>(),
          (B value) => Some(il.append(value)(accList)))(resultOption);
    })(acc);
  }

  return il.foldLeft<A, Option<il.ImmutableList<B>>>(
      Some(il.ImmutableList<B>([])))(foldFn);
}
