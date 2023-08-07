import 'bounded.dart';
import 'semigroup.dart';

/// Base Monoid abstract class, extends BaseSemigroup with an `empty` getter
abstract class BaseMonoid<T> extends BaseSemigroup<T> {
  T get empty;
}

/// Returns a function that takes a list of type T and concatenates all elements in the list using the monoid
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create a monoid for integer addition with identity element 0
///   BaseMonoid<int> monoid = SemigroupSum() as BaseMonoid<int>;
///
///   // Concatenate a list of integers using the monoid
///   List<int> numbers = [1, 2, 3, 4, 5];
///   int sum = concatAll(monoid)(numbers); // Output: 15 (1 + 2 + 3 + 4 + 5)
/// }
/// ```
T Function(List<T>) concatAll<T>(BaseMonoid<T> monoid) {
  return (List<T> as) =>
      as.fold(monoid.empty, (acc, a) => monoid.concat(acc, a));
}

/// Creates a monoid that finds the minimum value in a Bounded structure
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create a bounded integer type for values between 1 and 10
///   Bounded<int> bounded = BoundedInt(1, 10);
///
///   // Create a monoid that finds the minimum value in the bounded structure
///   BaseMonoid<int> minMonoid = min(bounded);
///
///   // Find the minimum value in a list of integers using the minMonoid
///   List<int> numbers = [5, 2, 8, 4, 1];
///   int minValue = concatAll(minMonoid)(numbers); // Output: 1 (Minimum value)
/// }
/// ```
BaseMonoid<A> min<A>(Bounded<A> bounded) {
  return _MinMonoid<A>(bounded);
}

/// Implementation of a monoid for the minimum value in a Bounded structure
class _MinMonoid<A> extends BaseMonoid<A> {
  final Bounded<A> bounded;

  _MinMonoid(this.bounded);

  @override
  A concat(A first, A second) {
    A clampedFirst = bounded.compare(first, bounded.bottom) < 0
        ? bounded.bottom
        : (bounded.compare(first, bounded.top) > 0 ? bounded.top : first);
    A clampedSecond = bounded.compare(second, bounded.bottom) < 0
        ? bounded.bottom
        : (bounded.compare(second, bounded.top) > 0 ? bounded.top : second);

    return bounded.compare(clampedFirst, clampedSecond) <= 0
        ? clampedFirst
        : clampedSecond;
  }

  @override
  A get empty => bounded.top;
}

/// Creates a monoid that finds the maximum value in a Bounded structure
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create a bounded integer type for values between 1 and 10
///   Bounded<int> bounded = BoundedInt(1, 10);
///
///   // Create a monoid that finds the maximum value in the bounded structure
///   BaseMonoid<int> maxMonoid = max(bounded);
///
///   // Find the maximum value in a list of integers using the maxMonoid
///   List<int> numbers = [5, 2, 8, 4, 1];
///   int maxValue = concatAll(maxMonoid)(numbers); // Output: 10 (Maximum value)
/// }
/// ```
BaseMonoid<A> max<A>(Bounded<A> bounded) {
  return _MaxMonoid<A>(bounded);
}

/// Implementation of a monoid for the maximum value in a Bounded structure
class _MaxMonoid<A> extends BaseMonoid<A> {
  final Bounded<A> bounded;

  _MaxMonoid(this.bounded);

  @override
  A concat(A first, A second) {
    A clampedFirst = bounded.compare(first, bounded.bottom) < 0
        ? bounded.bottom
        : (bounded.compare(first, bounded.top) > 0 ? bounded.top : first);
    A clampedSecond = bounded.compare(second, bounded.bottom) < 0
        ? bounded.bottom
        : (bounded.compare(second, bounded.top) > 0 ? bounded.top : second);

    return bounded.compare(clampedFirst, clampedSecond) >= 0
        ? clampedFirst
        : clampedSecond;
  }

  @override
  A get empty => bounded.bottom;
}

/// Creates a reversed version of the provided monoid
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create a monoid for integer addition with identity element 0
///   BaseMonoid<int> originalMonoid = SemigroupSum() as BaseMonoid<int>;
///
///   // Create a reversed version of the original monoid
///   BaseMonoid<int> reversedMonoid = reverse(originalMonoid);
///
///   // Concatenate a list of integers using the reversed monoid
///   List<int> numbers = [1, 2, 3, 4, 5];
///   int reversedSum = concatAll(reversedMonoid)(numbers); // Output: 15 (5 + 4 + 3 + 2 + 1)
/// }
/// ```
BaseMonoid<A> reverse<A>(BaseMonoid<A> monoid) {
  return _ReverseMonoid<A>(monoid);
}

/// Implementation of a reversed monoid, it reverses the order of concatenation
class _ReverseMonoid<A> extends BaseMonoid<A> {
  final BaseMonoid<A> monoid;

  _ReverseMonoid(this.monoid);

  @override
  A concat(A first, A second) =>
      monoid.concat(second, first); // Reversing the order

  @override
  A get empty => monoid.empty;
}
