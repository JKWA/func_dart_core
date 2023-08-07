import 'package:func_dart_core/bounded.dart';
import 'package:func_dart_core/integer.dart';
import 'package:test/test.dart';

void main() {
  final boundedValue = boundedInt(5, 15);

  group('clamp', () {
    test('should not alter values within bounds', () {
      final clampInt = clamp(boundedValue);

      expect(clampInt(5), 5);
      expect(clampInt(10), 10);
      expect(clampInt(15), 15);
    });

    test('should adjust values outside of bounds', () {
      final clampInt = clamp(boundedValue);

      expect(clampInt(4), 5); // below bottom
      expect(clampInt(16), 15); // above top
    });
  });

  group('reverse', () {
    test('should handle top and bottom values', () {
      final clampInt = clamp(boundedValue);

      expect(clampInt(5), boundedValue.bottom); // bottom value
      expect(clampInt(15), boundedValue.top); // top value
    });

    final reversedBoundedInt = reverse(boundedValue);

    test('reverse should reverse the comparison order', () {
      expect(reversedBoundedInt.compare(3, 5), greaterThan(0));
      expect(reversedBoundedInt.compare(5, 3), lessThan(0));
      expect(reversedBoundedInt.compare(4, 4), equals(0));
    });

    test('reverse should swap top and bottom values', () {
      expect(reversedBoundedInt.top, equals(boundedValue.bottom));
      expect(reversedBoundedInt.bottom, equals(boundedValue.top));
    });

    test('reverse should not change equality relation', () {
      expect(reversedBoundedInt.equals(4, 4), isTrue);
      expect(reversedBoundedInt.equals(3, 5), isFalse);
    });
  });
}
