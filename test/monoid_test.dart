import 'package:test/test.dart';
import 'package:functional_dart/monoid.dart';
import 'package:functional_dart/integer.dart';
import 'package:functional_dart/string.dart';

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
}
