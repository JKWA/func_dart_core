import "package:functional_dart/ord.dart";

abstract class Bounded<A> extends Ord<A> {
  Bounded(int Function(A x, A y) compare) : super(compare);

  A get top;
  A get bottom;
}

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

Bounded<A> reverse<A>(Bounded<A> bounded) {
  return _ReversedBounded<A>(bounded);
}

class _ReversedBounded<A> extends Bounded<A> {
  final Bounded<A> original;

  _ReversedBounded(this.original) : super((A x, A y) => original.compare(y, x));

  @override
  A get top => original.bottom;

  @override
  A get bottom => original.top;
}
