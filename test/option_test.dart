import 'package:functional_dart/option.dart';
import 'package:test/test.dart';

void main() {
  test('Option of constructs Some', () {
    var option = of(5);
    expect(option is Some<int>, true);
    assert((option as Some<int>).value == 5);
  });

  test('map on Some applies function and returns Some', () {
    var option = map(Some(5), (int x) => x * 2);
    assert((option as Some<int>).value == 10);
  });

  test('map on None returns None', () {
    var option = map(None<int>(), (int x) => x * 2);
    expect(option is None<int>, true);
    assert(option is None<int>);
  });

  test('flatMap on Some applies function and returns the result', () {
    var option = flatMap(Some(5), (int x) => Some(x * 2));
    assert((option as Some<int>).value == 10);
  });

  test('flatMap on None returns None', () {
    var option = flatMap(None<int>(), (int x) => Some(x * 2));
    expect(option is None<int>, true);
    assert(option is None<int>);
  });

  test('ap on Some applies function and returns Some', () {
    var result = ap(Some((int x) => x * 2), Some(10));

    var resultNoneF = ap(None<int Function(int)>(), Some(10));

    var resultNoneM = ap(Some((int x) => x * 2), None<int>());

    assert((result as Some<int>).value == 20);
    expect(resultNoneF is None<int>, true);
    expect(resultNoneM is None<int>, true);
  });
}
