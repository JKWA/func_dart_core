import 'package:test/test.dart';
import 'package:functional_dart/function.dart';
import 'package:functional_dart/semigroup.dart';

void main() {
  test('getFunctionSemigroup combines two functions', () {
    final semigroup = _StringSemigroup();
    final functionSemigroup = getSemigroup<String, String>(semigroup);

    String appendF(String s) => '${s}f';
    String appendG(String s) => '${s}g';

    final wrappedF = FunctionWrapper(appendF);
    final wrappedG = FunctionWrapper(appendG);
    final combined = functionSemigroup.concat(wrappedF, wrappedG);

    expect(combined('x'), 'xfxg');
    expect(combined('y'), 'yfyg');
  });
}

class _StringSemigroup extends BaseSemigroup<String> {
  @override
  String concat(String first, String second) => first + second;
}
