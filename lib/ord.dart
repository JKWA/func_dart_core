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
Ord<T> fromCompare<T>(int Function(T first, T second) compare) {
  return _Ord(compare);
}

/// Returns a contramap function that transforms an Ord instance based on function f.
Ord<A> Function(Ord<B>) contramap<A, B>(B Function(A) f) {
  return (Ord<B> fb) => _Ord((A x, A y) => fb.compare(f(x), f(y)));
}

/// Returns a new Ord instance that reverses the order relation.
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
bool Function(T) Function(T low, T hi) between<T>(Ord<T> O) {
  return (T low, T hi) =>
      (T a) => O.compare(low, a) <= 0 && O.compare(a, hi) <= 0;
}

/// Returns a function that clamps a value within a given range.
T Function(T) Function(T low, T hi) clamp<T>(Ord<T> O) {
  return (T low, T high) => (T a) {
        if (O.compare(a, low) < 0) return low;
        if (O.compare(a, high) > 0) return high;
        return a;
      };
}

/// Returns a function that checks if the first argument is greater than the second.
bool Function(A first, A second) gt<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) > 0;
}

/// Returns a function that checks if the first argument is less than the second.
bool Function(A first, A second) lt<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) < 0;
}

/// Returns a function that returns the maximum of two values.
A Function(A first, A second) max<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) > 0 ? first : second;
}

/// Returns a function that returns the minimum of two values.
A Function(A first, A second) min<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) < 0 ? first : second;
}
