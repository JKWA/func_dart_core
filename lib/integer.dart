import "eq.dart";
import 'monoid.dart';
import 'ord.dart';
import 'semigroup.dart';

class IntegerEq extends Eq<int> {
  @override
  bool equals(int x, int y) => x == y;
}

class IntegerOrd extends Ord<int> {
  IntegerOrd() : super((int x, int y) => x.compareTo(y));
}

class SemigroupSum extends BaseSemigroup<int> {
  @override
  int concat(int first, int second) => first + second;
}

class SemigroupProduct extends BaseSemigroup<int> {
  @override
  int concat(int first, int second) => first * second;
}

class MonoidSum extends BaseMonoid<int> {
  @override
  int get empty => 0;

  @override
  int concat(int first, int second) => first + second;
}

class MonoidProduct extends BaseMonoid<int> {
  @override
  int get empty => 1;

  @override
  int concat(int first, int second) => first * second;
}

final Eq<int> eqInt = IntegerEq();
final Ord<int> ordInt = IntegerOrd();
final BaseSemigroup<int> semigroupSum = SemigroupSum();
final BaseSemigroup<int> semigroupProduct = SemigroupProduct();
final BaseMonoid<int> monoidSum = MonoidSum();
final BaseMonoid<int> monoidProduct = MonoidProduct();
