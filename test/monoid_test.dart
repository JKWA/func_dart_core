import 'package:func_dart_core/bounded.dart' hide reverse;
import 'package:func_dart_core/integer.dart';
import 'package:func_dart_core/monoid.dart';
import 'package:func_dart_core/string.dart';
import 'package:test/test.dart';

void main() {
  group('concatAll', () {
    test('with integer sum', () {
      final concatFunction = concatAll(monoidSum);

      expect(concatFunction([1, 2, 3]), 6);
      expect(concatFunction([]), 0);
      expect(concatFunction([-1, 1, 5, -2, 3]), 6);
    });

    test('with string sum', () {
      final concatFunction = concatAll(monoidConcat);

      expect(concatFunction(['h', 'e', 'l', 'l', 'o']), 'hello');
    });
  });
  group('Min Monoid', () {
    final Bounded<int> boundedTemp = boundedInt(20, 35);

    test('concat should return the minimum of two values', () {
      final monoid = min(boundedTemp);
      expect(monoid.concat(25, 30), 25);
      expect(monoid.concat(30, 25), 25);
      expect(monoid.concat(20, 35), 20);
    });

    test('concat should return the minimum of two values when outside bounds',
        () {
      final monoid = min(boundedTemp);
      expect(monoid.concat(10, 40), 20);
    });
    test('empty should return the top value', () {
      final monoid = min(boundedTemp);
      expect(monoid.empty, 35);
    });

    test('concat with empty should return the other value', () {
      final monoid = min(boundedTemp);
      expect(monoid.concat(monoid.empty, 25), 25);
      expect(monoid.concat(25, monoid.empty), 25);
    });

    test('min with clamped integer values', () {
      final minMonoid = min(boundedTemp);
      final concatFunction = concatAll(minMonoid);

      expect(concatFunction([10, 30, 40]), 20);
    });
  });

  group('Max Monoid', () {
    final Bounded<int> boundedTemp = boundedInt(20, 35);
    final maxMonoid = max(boundedTemp);

    test('concat should respect the bounds', () {
      expect(maxMonoid.concat(10, 40), 35);
    });

    test('empty should return the bottom value', () {
      expect(maxMonoid.empty, 20);
    });

    test('concat with empty should return the other value', () {
      final monoid = max(boundedTemp);
      expect(monoid.concat(monoid.empty, 25), 25);
      expect(monoid.concat(25, monoid.empty), 25);
    });

    test('concatAll with max monoid', () {
      final concatFunction = concatAll(maxMonoid);
      expect(concatFunction([15, 30, 40, 25]), 35);
    });

    test('concatAll with an empty list should return bottom', () {
      final concatFunction = concatAll(maxMonoid);
      expect(concatFunction([]), 20);
    });
  });

  group('Reverse Monoid', () {
    final originalMonoid = monoidConcat;
    final reversedMonoid = reverse(originalMonoid);

    test('empty value should remain the same', () {
      expect(originalMonoid.empty, reversedMonoid.empty);
    });

    test('reverse Monoid should reverse concatenation operation', () {
      expect(reversedMonoid.concat('a', 'b'), 'ba');
    });

    test('reverse reverse should be equal to original', () {
      final originalMonoid = monoidConcat.concat('a', 'b');
      final doubleReversedMonoid =
          reverse(reverse(monoidConcat)).concat('a', 'b');

      expect(doubleReversedMonoid, originalMonoid);
    });
  });
}
