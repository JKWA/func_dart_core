import 'semigroup.dart';
import 'monoid.dart';

abstract class Eq<A> {
  bool equals(A x, A y);
}

class _Eq<A> implements Eq<A> {
  final bool Function(A, A) equalsFunction;

  _Eq(this.equalsFunction);

  @override
  bool equals(A x, A y) => equalsFunction(x, y);
}

Eq<A> fromEquals<A>(bool Function(A x, A y) equals) {
  return _Eq(equals);
}

class Semigroup<A> implements BaseSemigroup<Eq<A>> {
  @override
  Eq<A> concat(Eq<A> x, Eq<A> y) {
    return _Eq((A a, A b) => x.equals(a, b) && y.equals(a, b));
  }
}

class Monoid<A> implements BaseMonoid<Eq<A>> {
  @override
  Eq<A> get empty => _Eq((A _, A __) => true);

  @override
  Eq<A> concat(Eq<A> x, Eq<A> y) => Semigroup<A>().concat(x, y);
}

BaseSemigroup<Eq<A>> getSemigroup<A>() => Semigroup<A>();
BaseMonoid<Eq<A>> getMonoid<A>() => Monoid<A>();

Function(Eq<B>) contramap<A, B>(B Function(A a) f) {
  return (Eq<B> eqB) => _Eq<A>((A x, A y) => eqB.equals(f(x), f(y)));
}
