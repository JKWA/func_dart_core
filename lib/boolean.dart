import "package:functional_dart/eq.dart";
import "package:functional_dart/function.dart";
import "package:functional_dart/monoid.dart";
import "package:functional_dart/ord.dart";
import "package:functional_dart/semigroup.dart";

/// Returns a function that depending on the provided [bool] value,
/// invokes and returns the result of either [onFalse] or [onTrue] function.
/// The return type is `Object?` because [onFalse] and [onTrue] can potentially
/// return different types.
Object? Function(bool) matchW<A, B>(LazyArg<A> onFalse, LazyArg<B> onTrue) {
  return (bool value) => value ? onTrue() : onFalse();
}

/// Alias for matchW
final foldW = matchW;

/// Returns a function that depending on the provided [bool] value,
/// invokes and returns the result of either [onFalse] or [onTrue] function.
/// Both [onFalse] and [onTrue] must return the same type [A].
A Function(bool) match<A>(LazyArg<A> onFalse, LazyArg<A> onTrue) {
  return (bool value) => value ? onTrue() : onFalse();
}

/// Alias for match
final fold = match;

/// Implements the equality comparison for boolean values.
class BoolEq extends Eq<bool> {
  @override
  bool equals(bool x, bool y) => x == y;
}

/// Instance of boolean equality comparison.
final BoolEq eqBool = BoolEq();

/// Implements the `Semigroup` typeclass for boolean values with logical AND.
class SemigroupAll extends BaseSemigroup<bool> {
  @override
  bool concat(bool first, bool second) => first && second;
}

/// Instance of the `Semigroup` with logical AND.
final SemigroupAll semigroupAll = SemigroupAll();

/// Implements the `Semigroup` typeclass for boolean values with logical OR.
class SemigroupAny extends BaseSemigroup<bool> {
  @override
  bool concat(bool first, bool second) => first || second;
}

/// Instance of the `Semigroup` with logical OR.
final SemigroupAny semigroupAny = SemigroupAny();

/// Implements the `Monoid` typeclass for boolean values with logical AND.
class MonoidAll implements BaseMonoid<bool> {
  @override
  bool concat(bool first, bool second) => first && second;

  @override
  bool get empty => true;
}

/// Implements the `Monoid` typeclass for boolean values with logical OR.
class MonoidAny implements BaseMonoid<bool> {
  @override
  bool concat(bool x, bool y) => x || y;

  @override
  bool get empty => false;
}

/// Implements the `Ord` typeclass for boolean values.
class BooleanOrd extends Eq<bool> implements Ord<bool> {
  @override
  bool equals(bool x, bool y) => x == y;

  @override
  int compare(bool x, bool y) => (x ? 1 : 0) - (y ? 1 : 0);
}
