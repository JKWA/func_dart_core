import 'eq.dart' as eq;
import './semigroup.dart';
import './monoid.dart';

abstract class Ord<A> extends eq.Eq<A> {
  final int Function(A, A) _compare;

  Ord(int Function(A x, A y) compare) : _compare = compare;

  @override
  bool equals(A x, A y) => _compare(x, y) == 0;

  int compare(A x, A y) => _compare(x, y);
}

Ord<T> fromCompare<T>(int Function(T first, T second) compare) {
  return _Ord(compare);
}

Ord<A> Function(Ord<B>) contramap<A, B>(B Function(A) f) {
  return (Ord<B> fb) => _Ord((A x, A y) => fb.compare(f(x), f(y)));
}

Ord<A> reverse<A>(Ord<A> O) {
  return _Ord((A x, A y) => -O.compare(x, y));
}

class _Ord<A> extends Ord<A> {
  _Ord(int Function(A x, A y) compare) : super(compare);
}

class NumberOrd extends Ord<num> {
  NumberOrd()
      : super((num x, num y) => x < y
            ? -1
            : x > y
                ? 1
                : 0);
}

class Semigroup<A> implements BaseSemigroup<Ord<A>> {
  @override
  Ord<A> concat(Ord<A> first, Ord<A> second) {
    return fromCompare((A a, A b) {
      final ox = first.compare(a, b);
      return ox != 0 ? ox : second.compare(a, b);
    });
  }
}

class Monoid<A> implements BaseMonoid<Ord<A>> {
  @override
  Ord<A> concat(Ord<A> first, Ord<A> second) =>
      Semigroup<A>().concat(first, second);

  @override
  Ord<A> get empty => fromCompare((_, __) => 0);
}

BaseSemigroup<Ord<A>> getSemigroup<A>() => Semigroup<A>();
BaseMonoid<Ord<A>> getMonoid<A>() => Monoid<A>();

bool Function(T) Function(T low, T hi) between<T>(Ord<T> O) {
  return (T low, T hi) =>
      (T a) => O.compare(low, a) <= 0 && O.compare(a, hi) <= 0;
}

T Function(T) Function(T low, T hi) clamp<T>(Ord<T> O) {
  return (T low, T high) => (T a) {
        if (O.compare(a, low) < 0) return low;
        if (O.compare(a, high) > 0) return high;
        return a;
      };
}

bool Function(A first, A second) gt<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) > 0;
}

bool Function(A first, A second) lt<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) < 0;
}

A Function(A first, A second) max<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) > 0 ? first : second;
}

A Function(A first, A second) min<A>(Ord<A> O) {
  return (A first, A second) => O.compare(first, second) < 0 ? first : second;
}
