import 'package:functional_dart/identity.dart';
import 'package:test/test.dart';

void main() {
  group('Identity', () {
    test('of should wrap value in Identity', () {
      final identity = of<int>(1);
      expect(identity.value, equals(1));
    });

    test('map should correctly transform value', () {
      final identity = of<int>(1);
      final mapped = map<int, int>(identity, (int a) => a * 2);
      expect(mapped.value, equals(2));
    });

    test('flatMap should correctly unwrap and transform value', () {
      final identity = of<int>(1);
      final flatMapped = flatMap<int, int>(identity, (int a) => of<int>(a * 2));
      expect(flatMapped.value, equals(2));
    });

    test('ap should correctly apply function to value', () {
      final identity = of<int>(1);
      final fnIdentity = of<int Function(int)>((int a) => a * 2);
      final applied = ap<int, int>(identity, fnIdentity);
      expect(applied.value, equals(2));
    });
  });
}
