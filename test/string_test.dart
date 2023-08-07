import 'package:func_dart_core/string.dart';
import 'package:test/test.dart' hide isEmpty, startsWith, endsWith;

void main() {
  group('String', () {
    test('StringEq should equate identical strings', () {
      expect(eqString.equals('foo', 'foo'), true);
      expect(eqString.equals('foo', 'bar'), false);
    });

    test('StringOrd should correctly order strings', () {
      expect(ordString.compare('apple', 'apple'), 0);
      expect(ordString.compare('apple', 'banana'), -1);
      expect(ordString.compare('banana', 'apple'), 1);
    });

    test('SemigroupConcat should concatenate strings', () {
      expect(semigroupConcat.concat('foo', 'bar'), 'foobar');
    });

    test(
        'MonoidConcat should concatenate strings and have an empty string as the identity',
        () {
      expect(monoidConcat.concat('foo', 'bar'), 'foobar');
      expect(monoidConcat.concat(monoidConcat.empty, 'bar'), 'bar');
    });
  });
  group('String utility functions', () {
    test('toUpperCase', () {
      expect(toUpperCase('hello'), 'HELLO');
    });

    test('toLowerCase', () {
      expect(toLowerCase('HELLO'), 'hello');
    });

    test('replace', () {
      expect(replace('b', 'd', 'abc'), 'adc');
    });

    test('trim', () {
      expect(trim(' a '), 'a');
    });

    test('trimLeft', () {
      expect(trimLeft(' a '), 'a ');
    });

    test('trimRight', () {
      expect(trimRight(' a '), ' a');
    });

    test('slice', () {
      expect(slice(1, 3, 'abcd'), 'bc');
    });

    test('isEmpty', () {
      expect(isEmpty(''), true);
      expect(isEmpty('a'), false);
    });

    test('size', () {
      expect(size('abc'), 3);
    });

    test('split', () {
      expect(split('', 'abc'), ['a', 'b', 'c']);
      expect(split('', ''), ['']);
    });

    test('includes', () {
      expect(includes('b', 'abc'), true);
      expect(includes('d', 'abc'), false);
    });

    test('startsWith', () {
      expect(startsWith('a', 'abc'), true);
      expect(startsWith('b', 'abc'), false);
    });

    test('endsWith', () {
      expect(endsWith('c', 'abc'), true);
      expect(endsWith('b', 'abc'), false);
    });
  });
}
