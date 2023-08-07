import "package:func_dart_core/ord.dart";

/// Defines a bounded type `A` which extends the `Ord` type.
///
/// A bounded type has an upper and lower limit.
abstract class Bounded<A> extends Ord<A> {
  Bounded(int Function(A x, A y) compare) : super(compare);

  /// The upper bound of type `A`.
  A get top;

  /// The lower bound of type `A`.
  A get bottom;
}

/// Returns a function that clamps a value of type `A` within its bounds.
///
/// The function will return the `bottom` if the value is less than the lower
/// bound and the `top` if it is greater than the upper bound. If the value is
/// within the bounds, it will be returned as is.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create a bounded type for integers in the range of 1 to 10
///   final boundedIntegers = Bounded<int>((x, y) => x.compareTo(y));
///   boundedIntegers.top = 10;
///   boundedIntegers.bottom = 1;
///
///   // Create the clamp function for integers
///   final clampInt = clamp(boundedIntegers);
///
///   // Use the clamp function to restrict a value within the bounds
///   int value1 = clampInt(5); // Output: 5 (Within the bounds)
///   int value2 = clampInt(15); // Output: 10 (Clamped to the upper bound)
///   int value3 = clampInt(-5); // Output: 1 (Clamped to the lower bound)
/// }
/// ```
A Function(A) clamp<A>(Bounded<A> bounded) {
  return (A a) {
    if (bounded.compare(a, bounded.bottom) < 0) {
      return bounded.bottom;
    } else if (bounded.compare(a, bounded.top) > 0) {
      return bounded.top;
    } else {
      return a;
    }
  };
}

/// Returns a `Bounded<A>` with its bounds reversed.
///
/// The `top` of the original bounded object becomes the `bottom` of the
/// reversed one and vice versa.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create a bounded type for integers in the range of 1 to 10
///   final boundedIntegers = Bounded<int>((x, y) => x.compareTo(y));
///   boundedIntegers.top = 10;
///   boundedIntegers.bottom = 1;
///
///   // Reverse the bounds
///   final reversedBoundedIntegers = reverse(boundedIntegers);
///
///   print(reversedBoundedIntegers.top); // Output: 1 (The bottom of the original)
///   print(reversedBoundedIntegers.bottom); // Output: 10 (The top of the original)
/// }
/// ```
Bounded<A> reverse<A>(Bounded<A> bounded) {
  return _ReversedBounded<A>(bounded);
}

class _ReversedBounded<A> extends Bounded<A> {
  /// The original bounded object.
  final Bounded<A> original;

  _ReversedBounded(this.original) : super((A x, A y) => original.compare(y, x));

  @override

  /// The lower bound of the reversed bounded object, which is the `top` of the original one.
  A get top => original.bottom;

  @override

  /// The upper bound of the reversed bounded object, which is the `bottom` of the original one.
  A get bottom => original.top;
}
