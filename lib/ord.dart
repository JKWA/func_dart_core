import './monoid.dart';
import './semigroup.dart';
import 'eq.dart' as eq;

/// Defines an order relation for type A.
abstract class Ord<A> extends eq.Eq<A> {
  final int Function(A, A) _compare;

  Ord(int Function(A x, A y) compare) : _compare = compare;

  @override

  /// Returns true if the two values are equal according to the compare function.
  bool equals(A x, A y) => _compare(x, y) == 0;

  /// Compares two values and returns an int indicating their order.
  int compare(A x, A y) => _compare(x, y);
}

/// Creates a new Ord instance given a compare function.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create a compare function for integers
///   int compareInt(int x, int y) => x.compareTo(y);
///
///   // Create an Ord instance for integers using the compare function
///   Ord<int> ordInt = fromCompare(compareInt);
///
///   // Compare two integers using the ordInt instance
///   int result = ordInt.compare(5, 10); // Output: -1 (5 is less than 10)
/// }
/// ```
Ord<T> fromCompare<T>(int Function(T first, T second) compare) {
  return _Ord(compare);
}

/// Returns a contramap function that transforms an Ord instance based on function f.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create an Ord instance for integers
///   Ord<int> ordInt = fromCompare((x, y) => x.compareTo(y));
///
///   // Create a contramap function that transforms the ordInt instance for strings
///   Ord<String> ordString = contramap((s) => int.parse(s))(ordInt);
///
///   // Compare two strings using the ordString instance (after transformation)
///   int result = ordString.compare('5', '10'); // Output: -1 ('5' is less than '10')
/// }
/// ```
Ord<A> Function(Ord<B>) contramap<A, B>(B Function(A) f) {
  return (Ord<B> fb) => _Ord((A x, A y) => fb.compare(f(x), f(y)));
}

/// Returns a new Ord instance that reverses the order relation.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create an Ord instance for integers
///   Ord<int> ordInt = fromCompare((x, y) => x.compareTo(y));
///
///   // Create a reversed Ord instance for integers
///   Ord<int> reversedOrdInt = reverse(ordInt);
///
///   // Compare two integers using the reversedOrdInt instance
///   int result = reversedOrdInt.compare(5, 10); // Output: 1 (5 is greater than 10)
/// }
/// ```
Ord<A> reverse<A>(Ord<A> O) {
  return _Ord((A x, A y) => -O.compare(x, y));
}

/// Inner class for Ord
class _Ord<A> extends Ord<A> {
  _Ord(int Function(A x, A y) compare) : super(compare);
}

/// Defines an order relation for numbers.
class NumberOrd extends Ord<num> {
  NumberOrd()
      : super((num x, num y) => x < y
            ? -1
            : x > y
                ? 1
                : 0);
}

/// Semigroup structure for Ord instances.
class Semigroup<A> implements BaseSemigroup<Ord<A>> {
  @override

  /// Combines two Ord instances into a new one.
  Ord<A> concat(Ord<A> first, Ord<A> second) {
    return fromCompare((A a, A b) {
      final ox = first.compare(a, b);
      return ox != 0 ? ox : second.compare(a, b);
    });
  }
}

/// Monoid structure for Ord instances.
class Monoid<A> implements BaseMonoid<Ord<A>> {
  @override

  /// Combines two Ord instances into a new one.
  Ord<A> concat(Ord<A> first, Ord<A> second) =>
      Semigroup<A>().concat(first, second);

  @override

  /// Returns a default Ord instance that considers all values as equal.
  Ord<A> get empty => fromCompare((_, __) => 0);
}

/// Creates a new Semigroup instance for Ord.
BaseSemigroup<Ord<A>> getSemigroup<A>() => Semigroup<A>();

/// Creates a new Monoid instance for Ord.
BaseMonoid<Ord<A>> getMonoid<A>() => Monoid<A>();

/// Returns a function that checks if a value is within a given range.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create an Ord instance for integers
///   Ord<int> ordInt = fromCompare((x, y) => x.compareTo(y));
///
///   // Create a function to check if a value is between 1 and 10 (inclusive)
///   bool Function(int) isBetween = between(ordInt)(1, 10);
///
///   // Check if a value is between 1 and 10
///   bool result = isBetween(5); // Output: true (5 is between 1 and 10)
/// }
/// ```
bool Function(T) Function(T low, T hi) between<T>(Ord<T> O) {
  return (T low, T hi) =>
      (T a) => O.compare(low, a) <= 0 && O.compare(a, hi) <= 0;
}

/// Returns a function that clamps a value within a given range.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create an Ord instance for integers
///   Ord<int> ordInt = fromCompare((x, y) => x.compareTo(y));
///
///   // Create a clamp function to limit values between 1 and 10 (inclusive)
///   int Function(int) clampFn = clamp(ordInt)(1, 10);
///
///   // Clamp a value that is outside the range
///   int clampedValue = clampFn(15); // Output: 10 (Value is clamped to 10)
/// }
/// ```
T Function(T) Function(T low, T hi) clamp<T>(Ord<T> O) {
  return (T low, T high) => (T a) {
        if (O.compare(a, low) < 0) return low;
        if (O.compare(a, high) > 0) return high;
        return a;
      };
}

/// Returns a function that checks if the first argument is greater than the second.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create an Ord instance for integers
///   Ord<int> ordInt = fromCompare((x, y) => x.compareTo(y));
///
///   // Create a 'greater than' function for integers using the ordInt instance
///   bool Function(int, int) isGreaterThan = gt(ordInt);
///
///   // Check if one integer is greater than the other
///   bool result = isGreaterThan(5, 10); // Output: false (5 is not greater than 10)
/// }
/// ```
bool Function(A first, A second) gt<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) > 0;
}

/// Returns a function that checks if the first argument is less than the second.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create an Ord instance for integers
///   Ord<int> ordInt = fromCompare((x, y) => x.compareTo(y));
///
///   // Create a 'less than' function for integers using the ordInt instance
///   bool Function(int, int) isLessThan = lt(ordInt);
///
///   // Check if one integer is less than the other
///   bool result = isLessThan(5, 10); // Output: true (5 is less than 10)
/// }
/// ```
bool Function(A first, A second) lt<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) < 0;
}

/// Returns a function that returns the maximum of two values.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create an Ord instance for integers
///   Ord<int> ordInt = fromCompare((x, y) => x.compareTo(y));
///
///   // Create a function to find the maximum of two integers using the ordInt instance
///   int Function(int, int) findMax = max(ordInt);
///
///   // Find the maximum of two integers
///   int maxValue = findMax(5, 10); // Output: 10 (Maximum value)
/// }
/// ```
A Function(A first, A second) max<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) > 0 ? first : second;
}

/// Returns a function that returns the minimum of two values.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create an Ord instance for integers
///   Ord<int> ordInt = fromCompare((x, y) => x.compareTo(y));
///
///   // Create a function to find the minimum of two integers using the ordInt instance
///   int Function(int, int) findMin = min(ordInt);
///
///   // Find the minimum of two integers
///   int minValue = findMin(5, 10); // Output: 5 (Minimum value)
/// }
/// ```
A Function(A first, A second) min<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) < 0 ? first : second;
}
