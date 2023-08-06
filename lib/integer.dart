import 'bounded.dart';
import "eq.dart";
import 'monoid.dart';
import 'ord.dart';
import 'semigroup.dart';

/// An equality instance for integer type.
class IntegerEq extends Eq<int> {
  @override
  bool equals(int x, int y) => x == y;
}

/// An ordering instance for integer type.
class IntegerOrd extends Ord<int> {
  IntegerOrd() : super((int x, int y) => x.compareTo(y));
}

/// A semigroup instance for integer addition.
class SemigroupSum extends BaseSemigroup<int> {
  @override
  int concat(int first, int second) => first + second;
}

/// A semigroup instance for integer multiplication.
class SemigroupProduct extends BaseSemigroup<int> {
  @override
  int concat(int first, int second) => first * second;
}

/// A monoid instance for integer addition with identity element being 0.
class MonoidSum extends BaseMonoid<int> {
  @override
  int get empty => 0;

  @override
  int concat(int first, int second) => first + second;
}

/// A monoid instance for integer multiplication with identity element being 1.
class MonoidProduct extends BaseMonoid<int> {
  @override
  int get empty => 1;

  @override
  int concat(int first, int second) => first * second;
}

/// A bounded order instance for integer type with specified lower and upper bounds.
class BoundedInt extends IntegerOrd implements Bounded<int> {
  @override
  final int top;
  @override
  final int bottom;

  BoundedInt(
    this.bottom,
    this.top,
  ) : super();

  @override
  bool equals(int x, int y) => compare(x, y) == 0;
}

/// Constructs a BoundedInt object with specified lower and upper bounds.
BoundedInt boundedInt(int bottom, int top) => BoundedInt(bottom, top);

/// Predefined instances.
final Eq<int> eqInt = IntegerEq();
final Ord<int> ordInt = IntegerOrd();
final BaseSemigroup<int> semigroupSum = SemigroupSum();
final BaseSemigroup<int> semigroupProduct = SemigroupProduct();
final BaseMonoid<int> monoidSum = MonoidSum();
final BaseMonoid<int> monoidProduct = MonoidProduct();
