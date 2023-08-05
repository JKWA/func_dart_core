import 'package:functional_dart/ord.dart';

/// BaseSemigroup is an abstract class that defines a generic type for Semigroups
abstract class BaseSemigroup<T> {
  /// Method that must be implemented to combine two elements of the Semigroup
  T concat(T first, T second);
}

/// Creates a function that concatenates a list of elements
/// starting from a given element.
T Function(List<T>) Function(T) concatAll<T>(BaseSemigroup<T> semigroup) {
  return (T startWith) {
    return (List<T> as) {
      return as.fold(startWith, (acc, a) => semigroup.concat(acc, a));
    };
  };
}

/// Creates a semigroup that uses an Ord instance to pick the minimum of two elements.
BaseSemigroup<A> min<A>(Ord<A> order) => _MinSemigroup<A>(order);

class _MinSemigroup<A> extends BaseSemigroup<A> {
  final Ord<A> order;

  _MinSemigroup(this.order);

  /// Returns the minimum of two elements according to the provided Ord instance
  @override
  A concat(A first, A second) =>
      order.compare(first, second) <= 0 ? first : second;
}

/// Creates a semigroup that uses an Ord instance to pick the maximum of two elements.
BaseSemigroup<A> max<A>(Ord<A> order) => _MaxSemigroup<A>(order);

class _MaxSemigroup<A> extends BaseSemigroup<A> {
  final Ord<A> order;

  _MaxSemigroup(this.order);

  /// Returns the maximum of two elements according to the provided Ord instance
  @override
  A concat(A first, A second) =>
      order.compare(first, second) >= 0 ? first : second;
}

/// Creates a semigroup that always selects the first of two elements.
BaseSemigroup<A> first<A>() => _FirstSemigroup<A>();

class _FirstSemigroup<A> extends BaseSemigroup<A> {
  /// Returns the first of two elements
  @override
  A concat(A first, A second) => first;
}

/// Creates a semigroup that always selects the second of two elements.
BaseSemigroup<A> last<A>() => _LastSemigroup<A>();

class _LastSemigroup<A> extends BaseSemigroup<A> {
  /// Returns the second of two elements
  @override
  A concat(A first, A second) => second;
}

/// Creates a semigroup that reverses the order of its arguments before concatenating.
BaseSemigroup<A> reverse<A>(BaseSemigroup<A> semigroup) {
  return _ReverseSemigroup<A>(semigroup);
}

class _ReverseSemigroup<A> extends BaseSemigroup<A> {
  final BaseSemigroup<A> semigroup;

  _ReverseSemigroup(this.semigroup);

  /// Returns the concatenation of the second and first elements
  @override
  A concat(A first, A second) => semigroup.concat(second, first);
}

/// Creates a semigroup that always returns a specific constant value,
/// ignoring its arguments.
BaseSemigroup<A> constant<A>(A a) => _ConstantSemigroup(a);

class _ConstantSemigroup<A> extends BaseSemigroup<A> {
  final A value;

  _ConstantSemigroup(this.value);

  /// Returns a constant value, ignoring its arguments
  @override
  A concat(A first, A second) => value;
}

/// Creates a semigroup that concatenates elements with a specific "middle" element.
Function(BaseSemigroup<A>) intercalate<A>(A middle) {
  return (BaseSemigroup<A> semigroup) {
    return _IntercalateSemigroup(middle, semigroup);
  };
}

class _IntercalateSemigroup<A> extends BaseSemigroup<A> {
  final A middle;
  final BaseSemigroup<A> semigroup;

  _IntercalateSemigroup(this.middle, this.semigroup);

  /// Returns the concatenation of the first element, middle element, and second element
  @override
  A concat(A first, A second) =>
      semigroup.concat(first, semigroup.concat(middle, second));
}
