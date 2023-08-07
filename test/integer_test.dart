import 'package:func_dart_core/bounded.dart';
import 'package:func_dart_core/integer.dart';
import 'package:test/test.dart';

void main() {
  test('IntegerEq should equate identical integers', () {
    expect(eqInt.equals(5, 5), true);
    expect(eqInt.equals(3, 4), false);
  });

  test('IntegerOrd should correctly order integers', () {
    expect(ordInt.compare(5, 5), 0);
    expect(ordInt.compare(3, 4), -1);
    expect(ordInt.compare(4, 3), 1);
  });

  test('SemigroupSum should concatenate integers by addition', () {
    expect(semigroupSum.concat(3, 4), 7);
  });

  test('SemigroupProduct should concatenate integers by multiplication', () {
    expect(semigroupProduct.concat(3, 4), 12);
  });

  test(
      'MonoidSum should concatenate integers by addition and have 0 as the identity',
      () {
    expect(monoidSum.concat(3, 4), 7);
    expect(monoidSum.concat(monoidSum.empty, 4), 4);
  });

  test(
      'MonoidProduct should concatenate integers by multiplication and have 1 as the identity',
      () {
    expect(monoidProduct.concat(3, 4), 12);
    expect(monoidProduct.concat(monoidProduct.empty, 4), 4);
  });
  group('BoundedInt', () {
    test('compare should work as expected', () {
      final bounded = boundedInt(20, 35);
      expect(bounded.compare(25, 30), lessThan(0)); // 25 < 30
      expect(bounded.compare(30, 25), greaterThan(0)); // 30 > 25
      expect(bounded.compare(25, 25), 0); // 25 == 25
    });

    test('equals should work as expected', () {
      final bounded = boundedInt(20, 35);
      expect(bounded.equals(25, 25), isTrue); // 25 == 25
      expect(bounded.equals(25, 30), isFalse); // 25 != 30
    });

    test('top and bottom should be set correctly', () {
      final bounded = boundedInt(20, 35);
      expect(bounded.top, 35);
      expect(bounded.bottom, 20);
    });

    test('clamp should work as expected', () {
      final bounded = boundedInt(20, 35);
      final clampFn = clamp(bounded);

      expect(clampFn(15), 20); // less than bottom
      expect(clampFn(40), 35); // greater than top
      expect(clampFn(25), 25); // within bounds
    });
  });
}
