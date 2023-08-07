import 'package:functional_dart/either.dart';
import 'package:functional_dart/integer.dart';
import 'package:functional_dart/option.dart' as o;
import 'package:functional_dart/string.dart';
import 'package:test/test.dart';

void main() {
  group('Either lift - ', () {
    test('of should create a Right', () {
      Either<int, String> either = of<int, String>('Hello');
      expect(isRight(either), true);
      if (either is Right<int, String>) {
        expect(either.value, 'Hello');
      } else {
        fail("The instance is not a Right");
      }
    });
    test('Right should hold the value', () {
      var rightEither = right<int, String>('Hello');
      if (rightEither is Right<int, String>) {
        expect(rightEither.value, 'Hello');
      } else {
        fail("The instance is not a Right");
      }
    });
    test('Left should hold the value', () {
      var leftEither = left<int, String>(42);
      if (leftEither is Left<int, String>) {
        expect(leftEither.value, 42);
      } else {
        fail("The instance is not a Left");
      }
    });
  });
  group('Either refinement -', () {
    test('isLeft should return true for Left', () {
      var leftEither = left<int, String>(42);
      expect(isLeft(leftEither), true);
    });

    test('isLeft should return false for Right', () {
      var rightEither = right<int, String>('Hello');
      expect(isLeft(rightEither), false);
    });

    test('isRight should return true for Right', () {
      var rightEither = right<int, String>('Hello');
      expect(isRight(rightEither), true);
    });

    test('isRight should return false for Left', () {
      var leftEither = left<int, String>(42);
      expect(isRight(leftEither), false);
    });
  });
  group('fromPredicate', () {
    test('returns Right with the value when the predicate is true', () {
      var eitherFromPredicate = fromPredicate<String, int>(
          (value) => value > 0, () => 'Negative value');
      var result = eitherFromPredicate(42);

      expect(result, isA<Right<String, int>>());
      expect((result as Right<String, int>).value, equals(42));
    });

    test('returns Left with the provided value when the predicate is false',
        () {
      var eitherFromPredicate = fromPredicate<String, int>(
          (value) => value > 0, () => 'Negative value');
      var result = eitherFromPredicate(-1);

      expect(result, isA<Left<String, int>>());
      expect((result as Left<String, int>).value, equals('Negative value'));
    });

    test('only calls the provided function when the predicate is false', () {
      var functionCalled = false;
      var eitherFromPredicate =
          fromPredicate<String, int>((value) => value > 0, () {
        functionCalled = true;
        return 'Negative value';
      });

      // Should not call the provided function when the predicate is true
      eitherFromPredicate(42);
      expect(functionCalled, isFalse);

      // Should call the provided function when the predicate is false
      eitherFromPredicate(-1);
      expect(functionCalled, isTrue);
    });
  });
  group('fromOption', () {
    test('returns Right with the value when Option is Some', () {
      var eitherFromOption = fromOption<String, int>(() => 'No value');
      var result = eitherFromOption(o.Some(42));

      expect(result, isA<Right<String, int>>());
      expect((result as Right<String, int>).value, equals(42));
    });

    test('returns Left with the provided value when Option is None', () {
      var eitherFromOption = fromOption<String, int>(() => 'No value');
      var result = eitherFromOption(o.None());

      expect(result, isA<Left<String, int>>());
      expect((result as Left<String, int>).value, equals('No value'));
    });

    test('only calls the provided function when Option is None', () {
      var functionCalled = false;
      var eitherFromOption = fromOption<String, int>(() {
        functionCalled = true;
        return 'No value';
      });

      // Should not call the provided function when Option is Some
      eitherFromOption(o.Some(42));
      expect(functionCalled, isFalse);

      // Should call the provided function when Option is None
      eitherFromOption(o.None());
      expect(functionCalled, isTrue);
    });
  });

  test('map function', () {
    final either1 = right<int, String>('Hello');
    final either2 = map(either1, (value) => value.length);
    expect(either2, isA<Right<int, int>>());
    expect((either2 as Right<int, int>).value, equals(5));
  });

  test('flatMap function', () {
    final either1 = right<int, String>('Hello');
    final either2 = flatMap(either1, (value) => right<int, int>(value.length));
    expect(either2, isA<Right<int, int>>());
    expect((either2 as Right<int, int>).value, equals(5));

    final either3 = left<int, String>(42);
    final either4 = flatMap(either3, (value) => right<int, int>(value.length));
    expect(either4, isA<Left<int, int>>());
    expect((either4 as Left<int, int>).value, equals(42));
  });

  test('ap function', () {
    final either1 = right<int, String Function(int)>((value) => 'Hello $value');
    final either2 = right<int, int>(42);
    final either3 = ap(either1, either2);
    expect(either3, isA<Right<int, String>>());
    expect((either3 as Right<int, String>).value, equals('Hello 42'));
  });

  group('tap', () {
    test('with Right', () {
      Either<int, String> rightEither = Right("Hello");

      final printString =
          tap<int, String>((value) => print("Value inside Right: $value"));

      Either<int, String> tappedEither = printString(rightEither);

      expect(tappedEither, rightEither);
    });

    test('with Left', () {
      Either<int, String> leftEither = Left(42);

      final printString =
          tap<int, String>((value) => print("This won't be printed: $value"));

      Either<int, String> tappedEither = printString(leftEither);

      expect(tappedEither, leftEither);
    });
  });

  group('match', () {
    test('with Left', () {
      Either<int, String> leftEither = Left(42);

      final matcher = match<int, String, String>(
        (leftValue) => 'Left with value $leftValue',
        (rightValue) => 'Right with value $rightValue',
      );

      String result = matcher(leftEither);

      expect(result, 'Left with value 42');
    });

    test('with Right', () {
      Either<int, String> rightEither = Right('Hello');

      final matcher = match<int, String, String>(
        (leftValue) => 'Left with value $leftValue',
        (rightValue) => 'Right with value $rightValue',
      );

      String result = matcher(rightEither);

      expect(result, 'Right with value Hello');
    });

    test('getOrElse with Left', () {
      Either<int, String> leftEither = Left(42);

      String result = getOrElse(leftEither, () => 'Default value');

      expect(result, 'Default value');
    });

    test('getOrElse with Right', () {
      Either<int, String> rightEither = Right('Hello');

      String result = getOrElse(rightEither, () => 'Default value');

      expect(result, 'Hello');
    });
  });
  group('EitherEq', () {
    final eitherEq = getEq(eqString, eqInt);

    test('should return true when both Eithers are identical', () {
      final either1 = Right<String, int>(1);
      final either2 = either1;

      expect(eitherEq.equals(either1, either2), isTrue);
    });

    test(
        'should return true when both Eithers are Left and contain equal values',
        () {
      final either1 = Left<String, int>("Error");
      final either2 = Left<String, int>("Error");

      expect(eitherEq.equals(either1, either2), isTrue);
    });

    test(
        'should return true when both Eithers are Right and contain equal values',
        () {
      final either1 = Right<String, int>(1);
      final either2 = Right<String, int>(1);

      expect(eitherEq.equals(either1, either2), isTrue);
    });

    test(
        'should return false when both Eithers are Left but contain different values',
        () {
      final either1 = Left<String, int>("Error 1");
      final either2 = Left<String, int>("Error 2");

      expect(eitherEq.equals(either1, either2), isFalse);
    });

    test(
        'should return false when both Eithers are Right but contain different values',
        () {
      final either1 = Right<String, int>(1);
      final either2 = Right<String, int>(2);

      expect(eitherEq.equals(either1, either2), isFalse);
    });

    test('should return false when one Either is Left and the other is Right',
        () {
      final either1 = Right<String, int>(1);
      final either2 = Left<String, int>("Error");

      expect(eitherEq.equals(either1, either2), isFalse);
    });
  });

  final eitherOrd = getOrd(ordInt, ordString);

  group('EitherOrd', () {
    test('compares Right instances correctly', () {
      expect(eitherOrd.compare(Right("a"), Right("b")), lessThan(0));
      expect(eitherOrd.compare(Right("c"), Right("b")), greaterThan(0));
      expect(eitherOrd.compare(Right("b"), Right("b")), equals(0));
    });

    test('compares Left instances correctly', () {
      expect(eitherOrd.compare(Left(1), Left(2)), lessThan(0));
      expect(eitherOrd.compare(Left(3), Left(2)), greaterThan(0));
      expect(eitherOrd.compare(Left(2), Left(2)), equals(0));
    });

    test('compares Left and Right instances correctly', () {
      expect(eitherOrd.compare(Left(1), Right("b")), lessThan(0));
      expect(eitherOrd.compare(Right("b"), Left(1)), greaterThan(0));
    });
  });
}
