import 'monoid.dart';
import 'semigroup.dart';

/// Defines an equality relation on a type `A`.
abstract class Eq<A> {
  /// Checks if `x` and `y` are equal.
  bool equals(A x, A y);
}

class _Eq<A> implements Eq<A> {
  /// The function that determines equality of two elements of type `A`.
  final bool Function(A, A) equalsFunction;

  _Eq(this.equalsFunction);

  @override
  bool equals(A x, A y) => equalsFunction(x, y);
}

/// Creates an `Eq` from a given equality checking function.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Define an Eq for comparing integers based on divisibility by 5
///   final eqDivisibleBy5 = fromEquals<int>((x, y) => x % 5 == y % 5);
///
///   print(eqDivisibleBy5.equals(15, 5)); // Output: true (Both are divisible by 5)
///   print(eqDivisibleBy5.equals(10, 6)); // Output: false (10 % 5 is 0, while 6 % 5 is 1)
/// }
/// ```
Eq<A> fromEquals<A>(bool Function(A x, A y) equals) {
  return _Eq(equals);
}

/// Defines a semigroup for the `Eq` type.
class Semigroup<A> implements BaseSemigroup<Eq<A>> {
  @override

  /// Concatenates two `Eq` instances by checking equality on both.
  Eq<A> concat(Eq<A> x, Eq<A> y) {
    return _Eq((A a, A b) => x.equals(a, b) && y.equals(a, b));
  }
}

/// Defines a monoid for the `Eq` type.
class Monoid<A> implements BaseMonoid<Eq<A>> {
  @override

  /// Provides an "empty" `Eq` instance which considers all elements equal.
  Eq<A> get empty => _Eq((A _, A __) => true);

  @override

  /// Concatenates two `Eq` instances by delegating to the semigroup's `concat` method.
  Eq<A> concat(Eq<A> x, Eq<A> y) => Semigroup<A>().concat(x, y);
}

/// Returns a semigroup for the `Eq` type.
BaseSemigroup<Eq<A>> getSemigroup<A>() => Semigroup<A>();

/// Returns a monoid for the `Eq` type.
BaseMonoid<Eq<A>> getMonoid<A>() => Monoid<A>();

/// Transforms an `Eq<B>` into an `Eq<A>` using the given function.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Define an Eq for comparing strings case-insensitively
///   final eqIgnoreCase = fromEquals<String>((x, y) => x.toLowerCase() == y.toLowerCase());
///
///   // Define a function to extract the first character of a string
///   String firstChar(String s) => s.substring(0, 1);
///
///   // Create a contramapped Eq that compares strings by their first character
///   final eqByFirstChar = contramap<String, String>(firstChar)(eqIgnoreCase);
///
///   print(eqByFirstChar.equals("hello", "Hi")); // Output: true (Both start with 'h')
///   print(eqByFirstChar.equals("world", "war")); // Output: false ('w' is not equal to 'W')
/// }
/// ```
Eq<A> Function(Eq<B>) contramap<A, B>(B Function(A a) f) {
  return (Eq<B> eqB) => _Eq<A>((A x, A y) => eqB.equals(f(x), f(y)));
}
