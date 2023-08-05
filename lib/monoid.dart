import 'semigroup.dart';
import 'bounded.dart';

/// Base Monoid abstract class, extends BaseSemigroup with an `empty` getter
abstract class BaseMonoid<T> extends BaseSemigroup<T> {
  T get empty;
}

/// Returns a function that takes a list of type T and concatenates all elements in the list using the monoid
Function(List<T>) concatAll<T>(BaseMonoid<T> monoid) {
  return (List<T> as) =>
      as.fold(monoid.empty, (acc, a) => monoid.concat(acc, a));
}

/// Creates a monoid that finds the minimum value in a Bounded structure
BaseMonoid<A> min<A>(Bounded<A> bounded) {
  return _MinMonoid<A>(bounded);
}

/// Implementation of a monoid for minimum value in a Bounded structure
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
BaseMonoid<A> max<A>(Bounded<A> bounded) {
  return _MaxMonoid<A>(bounded);
}

/// Implementation of a monoid for maximum value in a Bounded structure
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
