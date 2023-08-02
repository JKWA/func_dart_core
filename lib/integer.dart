import "eq.dart";
import 'monoid.dart';
import 'ord.dart';
import 'semigroup.dart';
import 'bounded.dart';

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

// class BoundedInt extends Ord<int> implements Bounded<int> {
//   @override
//   final int top;
//   @override
//   final int bottom;

//   BoundedInt(this.top, this.bottom) : super((int x, int y) => x.compareTo(y));
// }

// class BoundedInt extends Bounded<int> {
//   BoundedInt() : super((int x, int y) => x.compareTo(y));

//   @override
//   int get top => double.infinity.toInt();

//   @override
//   int get bottom => double.negativeInfinity.toInt();
// }

// final Bounded<int> boundedInt = BoundedInt();

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

BoundedInt boundedInt(int bottom, int top) => BoundedInt(bottom, top);
final Eq<int> eqInt = IntegerEq();
final Ord<int> ordInt = IntegerOrd();
final BaseSemigroup<int> semigroupSum = SemigroupSum();
final BaseSemigroup<int> semigroupProduct = SemigroupProduct();
final BaseMonoid<int> monoidSum = MonoidSum();
final BaseMonoid<int> monoidProduct = MonoidProduct();
