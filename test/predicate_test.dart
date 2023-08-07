import 'package:func_dart_core/predicate.dart';
import 'package:test/test.dart';

void main() {
  bool isEven(int number) => number.isEven;
  bool isNegative(int number) => number < 0;
  final isEvenOrNegative = or<int>(isEven)(isNegative);

  group('Predicate', () {
    test('or logic', () {
      expect(isEvenOrNegative(2), true);
      expect(isEvenOrNegative(-1), true);
      expect(isEvenOrNegative(3), false);
    });

    bool isPositive(int number) => number > 0;
    final isPositiveAndEven = and<int>(isEven)(isPositive);

    test('and logic', () {
      expect(isPositiveAndEven(2), true);
      expect(isPositiveAndEven(-2), false);
      expect(isPositiveAndEven(3), false);
    });

    final isOdd = not<int>(isEven);

    test('not logic', () {
      expect(isOdd(1), true);
      expect(isOdd(2), false);
    });

    final isStringLengthEven = contramap<String, int>((s) => s.length)(isEven);

    test('contramap logic', () {
      expect(isStringLengthEven('even'), true);
      expect(isStringLengthEven('odd'), false);
    });

    final matcher = match<int, bool>(() => true, () => false)(isEven);

    test('match logic', () {
      expect(matcher(2), true);
      expect(matcher(1), false);
    });
  });
}
