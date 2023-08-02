import 'package:functional_dart/ord.dart';

// need base because of lack of HKT

abstract class BaseSemigroup<T> {
  T concat(T first, T second);
}

T Function(List<T>) Function(T) concatAll<T>(BaseSemigroup<T> semigroup) {
  return (T startWith) {
    return (List<T> as) {
      return as.fold(startWith, (acc, a) => semigroup.concat(acc, a));
    };
  };
}

BaseSemigroup<A> min<A>(Ord<A> order) => _MinSemigroup<A>(order);

class _MinSemigroup<A> extends BaseSemigroup<A> {
  final Ord<A> order;

  _MinSemigroup(this.order);

  @override
  A concat(A first, A second) =>
      order.compare(first, second) <= 0 ? first : second;
}

BaseSemigroup<A> max<A>(Ord<A> order) => _MaxSemigroup<A>(order);

class _MaxSemigroup<A> extends BaseSemigroup<A> {
  final Ord<A> order;

  _MaxSemigroup(this.order);

  @override
  A concat(A first, A second) =>
      order.compare(first, second) >= 0 ? first : second;
}

BaseSemigroup<A> first<A>() => _FirstSemigroup<A>();

class _FirstSemigroup<A> extends BaseSemigroup<A> {
  @override
  A concat(A first, A second) => first;
}

BaseSemigroup<A> last<A>() => _LastSemigroup<A>();

class _LastSemigroup<A> extends BaseSemigroup<A> {
  @override
  A concat(A first, A second) => second;
}

BaseSemigroup<A> reverse<A>(BaseSemigroup<A> semigroup) {
  return _ReverseSemigroup<A>(semigroup);
}

class _ReverseSemigroup<A> extends BaseSemigroup<A> {
  final BaseSemigroup<A> semigroup;

  _ReverseSemigroup(this.semigroup);

  @override
  A concat(A first, A second) => semigroup.concat(second, first);
}

BaseSemigroup<A> constant<A>(A a) => _ConstantSemigroup(a);

class _ConstantSemigroup<A> extends BaseSemigroup<A> {
  final A value;

  _ConstantSemigroup(this.value);

  @override
  A concat(A first, A second) => value;
}

Function(BaseSemigroup<A>) intercalate<A>(A middle) {
  return (BaseSemigroup<A> semigroup) {
    return _IntercalateSemigroup(middle, semigroup);
  };
}

class _IntercalateSemigroup<A> extends BaseSemigroup<A> {
  final A middle;
  final BaseSemigroup<A> semigroup;

  _IntercalateSemigroup(this.middle, this.semigroup);

  @override
  A concat(A first, A second) =>
      semigroup.concat(first, semigroup.concat(middle, second));
}
