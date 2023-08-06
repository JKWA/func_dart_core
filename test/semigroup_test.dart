import 'package:functional_dart/integer.dart';
import 'package:functional_dart/semigroup.dart';
import 'package:functional_dart/string.dart';
import 'package:test/test.dart';

void main() {
  group('concatAll', () {
    test('concatAll with integers', () {
      var semigroup = SemigroupSum();
      var concatAllWithSemigroup = concatAll(semigroup);
      var concatAllWithStart = concatAllWithSemigroup(0);

      expect(concatAllWithStart([1, 2, 3]), 6);
      expect(concatAllWithStart([]), 0);
    });

    test('concatAll with strings', () {
      var semigroup = SemigroupConcat();
      var concatAllWithSemigroup = concatAll(semigroup);
      var concatAllWithStart = concatAllWithSemigroup('');

      expect(concatAllWithStart(['a', 'b', 'c']), 'abc');
      expect(concatAllWithStart([]), '');
    });
  });
  test('max returns the maximum value according to the provided order', () {
    final semigroup = max(ordInt);

    expect(semigroup.concat(5, 3), 5);
    expect(semigroup.concat(3, 3), 3);
    expect(semigroup.concat(-5, 3), 3);
    expect(semigroup.concat(0, 0), 0);
  });

  test('first Semigroup should always return the first element', () {
    final semigroup = first<int>();

    expect(semigroup.concat(5, 10), equals(5));
    expect(semigroup.concat(0, 100), equals(0));
    expect(semigroup.concat(-10, -5), equals(-10));
  });

  test('last Semigroup should always return the last element', () {
    final semigroup = last<int>();

    expect(semigroup.concat(5, 10), equals(10));
    expect(semigroup.concat(0, 100), equals(100));
    expect(semigroup.concat(-10, -5), equals(-5));
  });

  group('reverse', () {
    test('reverse Semigroup should reverse concatenation operation', () {
      var semigroup = reverse(SemigroupConcat());

      expect(semigroup.concat('a', 'b'), 'ba');
    });
    test('reverse Semigroup should reverse all concatenation operations', () {
      var semigroup = SemigroupConcat();
      var concatAllWithSemigroup = concatAll(reverse(semigroup));
      var concatAllWithStart = concatAllWithSemigroup('');

      expect(concatAllWithStart(['a', 'b', 'c']), 'cba');
      expect(concatAllWithStart([]), '');
    });
  });

  test('constant Semigroup should always return the constant value', () {
    final constantValue = 42;
    final semigroup = constant<int>(constantValue);

    expect(semigroup.concat(5, 3), constantValue);
    expect(semigroup.concat(0, 0), constantValue);
    expect(semigroup.concat(-1, 100), constantValue);
  });

  test('intercalate Semigroup should intercalate values with the middle value',
      () {
    final semigroup = SemigroupSum();
    final middle = 2;
    final intercalateSemigroup = intercalate<int>(middle)(semigroup);

    expect(intercalateSemigroup.concat(5, 3), 10); // (5 + 2) + 3 = 10
  });
}
