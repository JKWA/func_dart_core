import 'package:func_dart_core/integer.dart';
import 'package:func_dart_core/list.dart' as il;
import 'package:func_dart_core/option.dart';
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

  group('match', () {
    test(
        'should return the result of applying the Some function when called with Some',
        () {
      final option = Some<int>(5);
      final result = match<int, String>(
          () => 'Nothing here', (value) => 'The value is $value')(option);
      expect(result, equals('The value is 5'));
    });

    test(
        'should return the result of applying the None function when called with None',
        () {
      final option = None<int>();
      final result = match<int, String>(
          () => 'Nothing here', (value) => 'The value is $value')(option);
      expect(result, equals('Nothing here'));
    });

    test('should handle Some values and different result types correctly', () {
      final option = Some<String>('Hello');
      final result =
          match<String, int>(() => 0, (value) => value.length)(option);
      expect(result, equals(5));
    });

    test('should handle None values and different result types correctly', () {
      final option = None<String>();
      final result =
          match<String, int>(() => 0, (value) => value.length)(option);
      expect(result, equals(0));
    });
  });

  group('getOrElse', () {
    test('should return the value if it is a Some', () {
      final option = Some(5);
      expect(getOrElse(option, () => 10), equals(5));
    });

    test('should return the result of the defaultFunction if it is a None', () {
      final option = None<int>();
      expect(getOrElse(option, () => 10), equals(10));
    });

    test('should lazily invoke defaultFunction', () {
      bool functionWasCalled = false;

      int defaultFunction() {
        functionWasCalled = true;
        return 10;
      }

      final option = Some(5);
      getOrElse(option, defaultFunction);
      expect(functionWasCalled, isFalse);
    });
  });
  group('fromPredicate', () {
    bool isEven(int value) => value % 2 == 0;
    bool containsSubstr(String value) => value.contains('test');

    test('should return Some(value) when predicate is true', () {
      final evenOption = fromPredicate(isEven, 4);

      expect(evenOption, isA<Some<int>>());
      expect((evenOption as Some).value, equals(4));
    });

    test('should return None when predicate is false', () {
      final oddOption = fromPredicate(isEven, 5);

      expect(oddOption, isA<None<int>>());
    });

    test('should return Some(value) when string contains a substring', () {
      final stringOption = fromPredicate(containsSubstr, 'dart test');

      expect(stringOption, isA<Some<String>>());
      expect((stringOption as Some).value, equals('dart test'));
    });

    test('should return None when string does NOT contain a substring', () {
      final stringOption = fromPredicate(containsSubstr, 'dart');

      expect(stringOption, isA<None<String>>());
    });
  });

  group('fromNullable', () {
    test('should return Some(value) when value is not null', () {
      final someOption = fromNullable(42);

      expect(someOption, isA<Some<int>>());
      expect((someOption as Some).value, equals(42));
    });

    test('should return None when value is null', () {
      final noneOption = fromNullable<int>(null);

      expect(noneOption, isA<None<int>>());
    });

    test('should return Some(value) when value is non-null string', () {
      final stringOption = fromNullable('test string');

      expect(stringOption, isA<Some<String>>());
      expect((stringOption as Some).value, equals('test string'));
    });

    test('should return None when value is null string', () {
      final stringOption = fromNullable<String>(null);

      expect(stringOption, isA<None<String>>());
    });
  });
  group('tap', () {
    test('tap with Some', () {
      Option<String> someOption = Some("Hello");

      final printString =
          tap<String>((value) => print("Value inside Some: $value"));

      Option<String> tappedOption = printString(someOption);

      expect(tappedOption, someOption);
    });

    test('tap with None', () {
      Option<String> noneOption = const None();

      final printString =
          tap<String>((value) => print("Value inside None: $value"));

      Option<String> tappedOption = printString(noneOption);

      expect(tappedOption, noneOption);
    });
  });
  group('OptionEq', () {
    test('should return true when both options are None', () {
      final eq = getEq(eqInt);

      expect(eq.equals(None(), None()), isTrue);
    });

    test('should return false when one option is None and the other is Some',
        () {
      final eq = getEq(eqInt);

      expect(eq.equals(None(), Some(1)), isFalse);
      expect(eq.equals(Some(1), None()), isFalse);
    });

    test('should return true when both options are Some and values are equal',
        () {
      final eq = getEq(eqInt);

      expect(eq.equals(Some(1), Some(1)), isTrue);
    });

    test(
        'should return false when both options are Some and values are not equal',
        () {
      final eq = getEq(eqInt);

      expect(eq.equals(Some(1), Some(2)), isFalse);
    });
  });

  group('OptionOrd', () {
    final optionOrdInt = getOrd(ordInt);

    test('compare should return 0 when both options are None', () {
      expect(optionOrdInt.compare(None(), None()), 0);
    });

    test(
        'compare should return -1 when first option is None and second is Some',
        () {
      expect(optionOrdInt.compare(None(), Some(1)), -1);
    });

    test('compare should return 1 when first option is Some and second is None',
        () {
      expect(optionOrdInt.compare(Some(1), None()), 1);
    });

    test(
        'compare should return 0 when both options are Some and values are equal',
        () {
      expect(optionOrdInt.compare(Some(1), Some(1)), 0);
    });

    test(
        'compare should return a negative number when both options are Some and first value is less than second',
        () {
      expect(optionOrdInt.compare(Some(1), Some(2)), lessThan(0));
    });

    test(
        'compare should return a positive number when both options are Some and first value is greater than second',
        () {
      expect(optionOrdInt.compare(Some(2), Some(1)), greaterThan(0));
    });
  });
  group('sequenceList - ', () {
    test('should convert ImmutableList<Option<A>> to Option<ImmutableList<A>>',
        () {
      final list = il.ImmutableList([Some(1), Some(2), Some(3)]);
      final result = sequenceList(list);

      expect(result, Some(il.ImmutableList([1, 2, 3])));
    });

    test('should return None if any element is None', () {
      final list = il.ImmutableList<Option<int>>([Some(1), None(), Some(3)]);
      final result = sequenceList(list);

      expect(result, None<il.ImmutableList<int>>());
    });
  });

  group('traverseList - ', () {
    // The function used for testing. If the number is even, return Some with its double, otherwise None.
    Option<int> doubleIfEven(int num) =>
        num.isEven ? Some(num * 2) : None<int>();

    test('should traverse the list and apply the function to its elements', () {
      final list = il.ImmutableList<int>([2, 4, 6]);
      final result = traverseList(doubleIfEven, list);

      expect(result, Some(il.ImmutableList<int>([4, 8, 12])));
    });

    test(
        'should return None if any element in the list results in None when the function is applied',
        () {
      final list1 = il.ImmutableList<int>([2, 3, 4]);
      final result1 = traverseList(doubleIfEven, list1);
      expect(result1, None<il.ImmutableList<int>>());

      final list2 = il.ImmutableList<int>([1, 2, 3]);
      final result2 = traverseList(doubleIfEven, list2);
      expect(result2, None<il.ImmutableList<int>>());
    });

    test('should return Some with empty list if input list is empty', () {
      final list = il.ImmutableList<int>([]);
      final result = traverseList(doubleIfEven, list);

      expect(result, Some(il.ImmutableList<int>([])));
    });
  });
}
