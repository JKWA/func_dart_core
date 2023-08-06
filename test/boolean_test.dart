import 'package:functional_dart/boolean.dart';
import 'package:test/test.dart';

void main() {
  group('match', () {
    test('should call the correct function based on the boolean value', () {
      onFalse() => 'False Branch';
      onTrue() => 'True Branch';

      expect(match(onFalse, onTrue)(false), 'False Branch');
      expect(match(onFalse, onTrue)(true), 'True Branch');
    });
  });
  group('matchW', () {
    test(
        ' should call the correct function based on the boolean value with widened types',
        () {
      onFalse() => 'False Branch';
      onTrue() => 42;

      expect(matchW(onFalse, onTrue)(false), 'False Branch');
      expect(matchW(onFalse, onTrue)(true), 42);
    });
  });
  group('Eq', () {
    test('should check equality between two boolean values', () {
      expect(eqBool.equals(true, true), true);
      expect(eqBool.equals(false, false), true);
      expect(eqBool.equals(true, false), false);
    });
  });

  group('SemigroupAll', () {
    test('should return true if both values are true', () {
      expect(semigroupAll.concat(true, true), true);
    });

    test('should return false if either value is false', () {
      expect(semigroupAll.concat(true, false), false);
      expect(semigroupAll.concat(false, true), false);
      expect(semigroupAll.concat(false, false), false);
    });
  });
  group('MonoidAll', () {
    final monoidAll = MonoidAll();
    test('concat should return true if both values are true', () {
      expect(monoidAll.concat(true, true), true);
    });

    test('concat should return false if either value is false', () {
      expect(monoidAll.concat(true, false), false);
      expect(monoidAll.concat(false, true), false);
      expect(monoidAll.concat(false, false), false);
    });

    test('empty should return true', () {
      expect(monoidAll.empty, true);
    });
  });

  group('MonoidAny', () {
    final monoidAny = MonoidAny();
    test('concat should return true if either value is true', () {
      expect(monoidAny.concat(true, true), true);
      expect(monoidAny.concat(true, false), true);
      expect(monoidAny.concat(false, true), true);
    });

    test('concat should return false if both values are false', () {
      expect(monoidAny.concat(false, false), false);
    });

    test('empty should return false', () {
      expect(monoidAny.empty, false);
    });
  });
  group('BooleanOrd', () {
    final booleanOrd = BooleanOrd();

    test('equals should return true for equal values', () {
      expect(booleanOrd.equals(true, true), true);
      expect(booleanOrd.equals(false, false), true);
    });

    test('equals should return false for unequal values', () {
      expect(booleanOrd.equals(true, false), false);
      expect(booleanOrd.equals(false, true), false);
    });

    test('compare should return 0 for equal values', () {
      expect(booleanOrd.compare(true, true), 0);
      expect(booleanOrd.compare(false, false), 0);
    });

    test(
        'compare should return a -1 if the first value is less than the second',
        () {
      expect(booleanOrd.compare(false, true), equals(-1));
    });

    test(
        'compare should return a +1 if the first value is greater than the second',
        () {
      expect(booleanOrd.compare(true, false), equals(1));
    });
  });
}
