import 'package:test/test.dart';
import 'package:functional_dart/integer.dart';

void main() {
  test('IntegerEq should equate identical integers', () {
    expect(eqInt.equals(5, 5), true);
    expect(eqInt.equals(3, 4), false);
  });

  test('IntegerOrd should correctly order integers', () {
    expect(ordInt.compare(5, 5), 0);
    expect(ordInt.compare(3, 4), -1);
    expect(ordInt.compare(4, 3), 1);
  });

  test('SemigroupSum should concatenate integers by addition', () {
    expect(semigroupSum.concat(3, 4), 7);
  });

  test('SemigroupProduct should concatenate integers by multiplication', () {
    expect(semigroupProduct.concat(3, 4), 12);
  });

  test(
      'MonoidSum should concatenate integers by addition and have 0 as the identity',
      () {
    expect(monoidSum.concat(3, 4), 7);
    expect(monoidSum.concat(monoidSum.empty, 4), 4);
  });

  test(
      'MonoidProduct should concatenate integers by multiplication and have 1 as the identity',
      () {
    expect(monoidProduct.concat(3, 4), 12);
    expect(monoidProduct.concat(monoidProduct.empty, 4), 4);
  });
}
