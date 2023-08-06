import 'package:functional_dart/predicate.dart';

/// `Option` is a type representing the presence or absence of a value `A`.
/// This class is part of the Option type system used in functional programming
/// that is an alternative to using null. It can be one of two subclasses: `Some` and `None`.
sealed class Option<A> {
  const Option();
}

/// `Some` is a subclass of `Option` indicating that there is a value present.
/// It encapsulates or "wraps" that value.
class Some<A> extends Option<A> {
  /// The value that this `Some` instance holds.
  final A value;

  /// Constructs a `Some` instance that holds the provided [value].
  Some(this.value);
}

/// `None` is a subclass of `Option` indicating the absence of a value.
/// It is used where in other languages you might find null or undefined.
class None<A> extends Option<A> {
  const None();
}

/// Wraps the given [value] in a `Some`, indicating the presence of a value.
Option<B> of<B>(B value) {
  return Some<B>(value);
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
Option<B> flatMap<A, B>(Option<A> option, Option<B> Function(A) f) {
  if (option is Some<A>) {
    return f(option.value);
  } else {
    return None<B>();
  }
}

/// Alias for [flatMap].
final chain = flatMap;

/// Applies the function wrapped in an `Option` [fOpt] to the value in the `Option` [m],
/// if both [fOpt] and [m] are `Some`, and wraps the result in an `Option`.
/// If either [fOpt] or [m] is `None`, returns `None`.
/// This operation is known as 'ap' or 'apply' in functional programming.
Option<B> ap<A, B>(Option<B Function(A)> fOpt, Option<A> m) {
  return flatMap(fOpt, (B Function(A) f) {
    return map(m, f);
  });
}

/// A function to process an `Option` value. If [Option] is an instance of `Some`,
/// the function [onSome] will be invoked with the encapsulated value.
/// If [Option] is `None`, then [onNone] will be called.
///
/// This is a form of pattern matching adapted for Dart.
/// The returned function takes an `Option<A>` and returns a value of type `B`.
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
