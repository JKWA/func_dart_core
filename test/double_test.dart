import 'package:func_dart_core/double.dart';
import 'package:test/test.dart';

void main() {
  group('DoubleEq tests:', () {
    final eq = DoubleEq();

    test('should return true for equal doubles', () {
      expect(eq.equals(5.0, 5.0), true);
    });

    test('should return false for unequal doubles', () {
      expect(eq.equals(5.0, 5.5), false);
    });
  });

  group('DoubleOrd tests:', () {
    final ord = DoubleOrd();

    test('should compare two doubles correctly', () {
      expect(ord.compare(5.0, 5.5) == -1, true);
      expect(ord.compare(5.5, 5.0) == 1, true);
      expect(ord.compare(5.0, 5.0) == 0, true);
    });
  });

  group('Semigroup tests:', () {
    final sum = SemigroupSumDouble();
    final product = SemigroupProductDouble();

    test('should concatenate using addition', () {
      expect(sum.concat(5.0, 5.5), 10.5);
    });

    test('should concatenate using multiplication', () {
      expect(product.concat(5.0, 5.0), 25.0);
    });
  });

  group('Monoid tests:', () {
    final sum = MonoidSumDouble();
    final product = MonoidProductDouble();

    test('should have correct identity for addition', () {
      expect(sum.empty, 0.0);
    });

    test('should have correct identity for multiplication', () {
      expect(product.empty, 1.0);
    });
  });

  group('BoundedDouble tests:', () {
    final bounded = BoundedDouble(1.0, 10.0);

    test('should compare within bounds', () {
      expect(bounded.compare(5.0, 8.5) < 0, true);
      expect(bounded.compare(9.0, 2.0) > 0, true);
    });

    test('should have correct bounds', () {
      expect(bounded.top, 10.0);
      expect(bounded.bottom, 1.0);
    });
  });
}
