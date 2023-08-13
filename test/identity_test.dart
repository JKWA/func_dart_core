import 'package:func_dart_core/identity.dart';
import 'package:func_dart_core/integer.dart';
import 'package:func_dart_core/string.dart';
import 'package:test/test.dart';

void main() {
  group('Identity Monad', () {
    test('should preserve the identity', () {
      var id = of<int>(5);
      expect(id.value, 5);
    });
  });

  group('of - ', () {
    test('should wrap an int value into an Identity', () {
      final intVal = 5;
      final identityInt = of(intVal);

      expect(identityInt.value, intVal);
    });

    test('should wrap a String value into an Identity', () {
      final strVal = "Hello";
      final identityStr = of(strVal);

      expect(identityStr.value, strVal);
    });
  });

  group('extract = ', () {
    test('should retrieve an int value from an Identity', () {
      final intVal = 5;
      final identityInt = Identity<int>(intVal);

      expect(extract(identityInt), intVal);
    });

    test('should retrieve a String value from an Identity', () {
      final strVal = "Hello";
      final identityStr = Identity<String>(strVal);

      expect(extract(identityStr), strVal);
    });
  });

  group('map - ', () {
    test('should map over the Identity value', () {
      var id = of<int>(3);
      var result = map<int, int>((x) => x * 2)(id);
      expect(result.value, 6);
    });

    test('should handle different types', () {
      var id = of<int>(4);
      var result = map<int, String>((x) => 'Value: $x')(id);
      expect(result.value, 'Value: 4');
    });

    test('should handle nested mapping', () {
      var id = of<int>(3);
      var result = map<int, int>((x) => x * 2)(map<int, int>((x) => x + 1)(id));
      expect(result.value, 8); // (3 + 1) * 2
    });
  });
  group('flatMap - ', () {
    test('should flatten and map over the Identity value', () {
      var id = of<int>(3);
      var result = flatMap<int, int>((x) => of<int>(x * 2))(id);
      expect(result.value, 6);
    });

    test('should handle nested flatMapping', () {
      var id = of<int>(3);
      var result = flatMap<int, int>((x) => Identity<int>(x * 2))(
          flatMap<int, int>((x) => of<int>(x + 1))(id));
      expect(result.value, 8); // (3 + 1) * 2
    });
  });
  group('ap - ', () {
    test(
        'should apply function wrapped in an Identity to a value wrapped in an Identity',
        () {
      var idValue = of<int>(3);
      var idFn = of<int Function(int)>((x) => x * 2);
      var result = ap(idFn)(idValue);
      expect(result.value, 6);
    });

    test('should handle chaining of applicative operations', () {
      var idValue = Identity<int>(3);
      var idFn1 = Identity<int Function(int)>((x) => x + 1);
      var idFn2 = Identity<int Function(int)>((x) => x * 2);
      var result = ap(idFn2)(ap(idFn1)(idValue));
      expect(result.value, 8); // (3 + 1) * 2
    });
  });
  group('foldMap tests with Integer:', () {
    test(
        'should return the wrapped value as is when transformation is identity',
        () {
      Identity<int> id = Identity(5);
      var result = foldMap(monoidSum, (int a) => a)(id);
      expect(result, 5);
    });

    test('should apply transformation and fold using MonoidSum', () {
      Identity<int> id = Identity(5);
      var result = foldMap(monoidSum, (int a) => a * 2)(id);
      expect(result, 10);
    });
  });
  group('foldMap tests with String:', () {
    test(
        'should return the wrapped value as is when transformation is identity',
        () {
      Identity<String> id = Identity('Hello');
      var result = foldMap(monoidConcat, (String s) => s)(id);
      expect(result, 'Hello');
    });

    test('should apply transformation to uppercase and fold using MonoidConcat',
        () {
      Identity<String> id = Identity('Hello');
      var result = foldMap(monoidConcat, toUpperCase)(id);
      expect(result, 'HELLO');
    });

    test(
        'should apply transformation to replace "o" with "a" and fold using MonoidConcat',
        () {
      Identity<String> id = Identity('Hello');
      var result =
          foldMap(monoidConcat, (String s) => replace('o', 'a', s))(id);
      expect(result, 'Hella');
    });
  });
}
