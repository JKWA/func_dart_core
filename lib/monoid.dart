import 'semigroup.dart';
import 'bounded.dart';

// need base because of lack of HKT

abstract class BaseMonoid<T> extends BaseSemigroup<T> {
  T get empty;
}

Function(List<T>) concatAll<T>(BaseMonoid<T> monoid) {
  return (List<T> as) =>
      as.fold(monoid.empty, (acc, a) => monoid.concat(acc, a));
}

BaseMonoid<A> min<A>(Bounded<A> bounded) {
  return _MinMonoid<A>(bounded);
}

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

BaseMonoid<A> max<A>(Bounded<A> bounded) {
  return _MaxMonoid<A>(bounded);
}

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

BaseMonoid<A> reverse<A>(BaseMonoid<A> monoid) {
  return _ReverseMonoid<A>(monoid);
}

class _ReverseMonoid<A> extends BaseMonoid<A> {
  final BaseMonoid<A> monoid;

  _ReverseMonoid(this.monoid);

  @override
  A concat(A first, A second) =>
      monoid.concat(second, first); // Reversing the order

  @override
  A get empty => monoid.empty;
}
