import 'bounded.dart';
import "eq.dart";
import 'monoid.dart';
import 'ord.dart';
import 'semigroup.dart';

/// An equality instance for double type.
class DoubleEq extends Eq<double> {
  @override
  bool equals(double x, double y) => x == y;
}

/// An ordering instance for double type.
class DoubleOrd extends Ord<double> {
  DoubleOrd() : super((double x, double y) => x.compareTo(y));
}

/// A semigroup instance for double addition.
class SemigroupSumDouble extends BaseSemigroup<double> {
  @override
  double concat(double first, double second) => first + second;
}

/// A semigroup instance for double multiplication.
class SemigroupProductDouble extends BaseSemigroup<double> {
  @override
  double concat(double first, double second) => first * second;
}

/// A monoid instance for double addition with identity element being 0.0.
class MonoidSumDouble extends BaseMonoid<double> {
  @override
  double get empty => 0.0;

  @override
  double concat(double first, double second) => first + second;
}

/// A monoid instance for double multiplication with identity element being 1.0.
class MonoidProductDouble extends BaseMonoid<double> {
  @override
  double get empty => 1.0;

  @override
  double concat(double first, double second) => first * second;
}

/// A bounded order instance for double type with specified lower and upper bounds.
class BoundedDouble extends DoubleOrd implements Bounded<double> {
  @override
  final double top;
  @override
  final double bottom;

  BoundedDouble(this.bottom, this.top) : super();

  @override
  bool equals(double x, double y) => compare(x, y) == 0;
}

/// Constructs a BoundedDouble object with specified lower and upper bounds.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create a bounded double type for values between 1.0 and 10.0
///   BoundedDouble bounded = boundedDouble(1.0, 10.0);
///
///   // Compare two doubles using the bounded ordering
///   bool result1 = bounded.compare(5.5, 8.3) < 0; // Output: true (5.5 is less than 8.3)
///   bool result2 = bounded.compare(15.2, 10.1) > 0; // Output: false (15.2 is not within the bounds)
/// }
/// ```
BoundedDouble boundedDouble(double bottom, double top) =>
    BoundedDouble(bottom, top);

/// Predefined instances.
final Eq<double> eqDouble = DoubleEq();
final Ord<double> ordDouble = DoubleOrd();
final BaseSemigroup<double> semigroupSumDouble = SemigroupSumDouble();
final BaseSemigroup<double> semigroupProductDouble = SemigroupProductDouble();
final BaseMonoid<double> monoidSumDouble = MonoidSumDouble();
final BaseMonoid<double> monoidProductDouble = MonoidProductDouble();
