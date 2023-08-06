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
}
