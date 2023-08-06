import 'package:functional_dart/function.dart';
import 'package:functional_dart/string.dart' as s;
import 'package:test/test.dart';

void main() {
  group('Semigroup', () {
    test(' combines two functions', () {
      final functionSemigroup = getSemigroup<String, String>(s.semigroupConcat);

      String appendF(String s) => '${s}f';
      String appendG(String s) => '${s}g';

      final wrappedF = FunctionWrapper(appendF);
      final wrappedG = FunctionWrapper(appendG);
      final combined = functionSemigroup.concat(wrappedF, wrappedG);

      expect(combined('x'), 'xfxg');
      expect(combined('y'), 'yfyg');
    });
  });

  group('Identity', () {
    test('should return the same value that is passed to it', () {
      expect(identity(42), 42);
      expect(identity('hello'), 'hello');
      final list = [1, 2, 3];
      expect(identity(list), list); // Same reference
    });
  });

  group('pipes', () {
    int addOne(int n) {
      return n + 1;
    }

    test('pipe returns its input unchanged', () {
      expect(pipe(1), equals(1));
    });

    test('pipe2 should equal 2', () {
      expect(pipe2(1, addOne), equals(2));
    });

    test('pipe3 should equal 3', () {
      expect(pipe3(1, addOne, addOne), equals(3));
    });

    test('pipe4 should equal 4', () {
      expect(pipe4(1, addOne, addOne, addOne), equals(4));
    });

    test('pipe5 should equal 5', () {
      expect(pipe5(1, addOne, addOne, addOne, addOne), equals(5));
    });

    test('pipe6 should equal 6', () {
      expect(pipe6(1, addOne, addOne, addOne, addOne, addOne), equals(6));
    });

    test('pipe7 should equal 7', () {
      expect(
          pipe7(1, addOne, addOne, addOne, addOne, addOne, addOne), equals(7));
    });

    test('pipe8 should equal 8', () {
      expect(pipe8(1, addOne, addOne, addOne, addOne, addOne, addOne, addOne),
          equals(8));
    });

    test('pipe9 should equal 9', () {
      expect(
          pipe9(1, addOne, addOne, addOne, addOne, addOne, addOne, addOne,
              addOne),
          equals(9));
    });

    test('pipe10 should equal 10', () {
      expect(
          pipe10(1, addOne, addOne, addOne, addOne, addOne, addOne, addOne,
              addOne, addOne),
          equals(10));
    });
  });

  group('flows', () {
    int addOne(int n) {
      return n + 1;
    }

    test('should return 2', () {
      expect(flow(addOne)(1), equals(2));
    });

    test('should return 3', () {
      expect(flow2(addOne, addOne)(1), equals(3));
    });
    test('should return 4', () {
      expect(flow3(addOne, addOne, addOne)(1), equals(4));
    });

    test('should return 5', () {
      expect(flow4(addOne, addOne, addOne, addOne)(1), equals(5));
    });

    test('should return 6', () {
      expect(flow5(addOne, addOne, addOne, addOne, addOne)(1), equals(6));
    });

    test('should return 7', () {
      expect(
          flow6(addOne, addOne, addOne, addOne, addOne, addOne)(1), equals(7));
    });

    test('should return 8', () {
      expect(flow7(addOne, addOne, addOne, addOne, addOne, addOne, addOne)(1),
          equals(8));
    });

    test('should return 9', () {
      expect(
          flow8(addOne, addOne, addOne, addOne, addOne, addOne, addOne, addOne)(
              1),
          equals(9));
    });

    test('should return 10', () {
      expect(
          flow9(addOne, addOne, addOne, addOne, addOne, addOne, addOne, addOne,
              addOne)(1),
          equals(10));
    });
  });
}
