import 'package:func_dart_core/either.dart' as e;
import 'package:func_dart_core/option.dart' as o;
import 'package:func_dart_core/taskeither.dart';
import 'package:test/test.dart';

void main() {
  group('TaskEither - lift', () {
    test('left should return a Left wrapped in a Future', () async {
      final String value = 'Error';
      final te = left<String, int>(value);

      expect(await te.taskEither(), e.Left<String, int>(value));
    });

    test('right should return a Right wrapped in a Future', () async {
      final int value = 42;
      final te = right<String, int>(value);

      expect(await te.taskEither(), e.Right<String, int>(value));
    });

    test('of should wrap a value into a Right wrapped in a Future', () async {
      final int value = 99;
      final te = of<String, int>(value);

      expect(await te.taskEither(), e.Right<String, int>((value)));
    });
  });
  group('TaskEither - map', () {
    test('should not transform a Left value', () async {
      final String leftValue = 'Error';
      final taskEither = left<String, int>(leftValue);
      final mapped = map(taskEither, (int value) => value + 1);

      final result = await mapped.taskEither();

      expect(result is e.Left<String, int>, true);
      expect((result as e.Left<String, int>).value, equals(leftValue));
    });

    test('should transform a Right value', () async {
      final int rightValue = 42;
      final taskEither = right<String, int>(rightValue);
      final mapped = map(taskEither, (int value) => value + 1);

      final result = await mapped.taskEither();

      expect(result is e.Right<String, int>, true);
      expect((result as e.Right<String, int>).value, equals(43));
    });
  });
  group('TaskEither - flatMap', () {
    test('should not transform a Left value', () async {
      final String leftValue = 'Error';
      final taskEither = left<String, int>(leftValue);
      final flatMapped =
          flatMap(taskEither, (int value) => right<String, int>(value + 1));

      final result = await flatMapped.taskEither();

      expect(result is e.Left<String, int>, true);
      expect((result as e.Left<String, int>).value, equals(leftValue));
    });

    test('should transform a Right value', () async {
      final int rightValue = 42;
      final taskEither = right<String, int>(rightValue);
      final flatMapped =
          flatMap(taskEither, (int value) => right<String, int>(value + 1));

      final result = await flatMapped.taskEither();

      expect(result is e.Right<String, int>, true);
      expect((result as e.Right<String, int>).value, equals(43));
    });

    test('should handle transformation to a Left value from a Right value',
        () async {
      final int rightValue = 42;
      final String transformedLeftValue = 'Transformed Error';
      final taskEither = right<String, int>(rightValue);
      final flatMapped = flatMap(
          taskEither, (int value) => left<String, int>(transformedLeftValue));

      final result = await flatMapped.taskEither();

      expect(result is e.Left<String, int>, true);
      expect(
          (result as e.Left<String, int>).value, equals(transformedLeftValue));
    });
  });
  group('TaskEither - ap', () {
    test('should not apply function if fTaskEither is Left', () async {
      final String leftValue = 'Error';
      final taskEitherFunc = left<String, int Function(int)>(leftValue);
      final taskEitherVal = right<String, int>(5);

      final applied = ap(taskEitherFunc, taskEitherVal);

      final result = await applied.taskEither();

      expect(result is e.Left<String, int>, true);
      expect((result as e.Left<String, int>).value, equals(leftValue));
    });

    test('ap should not apply function if m is Left', () async {
      final String leftValue = 'Error';
      final taskEitherFunc = right<String, int Function(int)>((x) => x + 1);
      final taskEitherVal = left<String, int>(leftValue);

      final applied = ap(taskEitherFunc, taskEitherVal);

      final result = await applied.taskEither();

      expect(result is e.Left<String, int>, true);
      expect((result as e.Left<String, int>).value, equals(leftValue));
    });

    test('ap should apply function if both fTaskEither and m are Right',
        () async {
      final taskEitherFunc = right<String, int Function(int)>((x) => x + 1);
      final taskEitherVal = right<String, int>(5);

      final applied = ap(taskEitherFunc, taskEitherVal);

      final result = await applied.taskEither();

      expect(result is e.Right<String, int>, true);
      expect((result as e.Right<String, int>).value, equals(6));
    });
  });

  group('TaskEither - tap', () {
    test(
        'tap should not modify the TaskEither and perform a side effect on a Right value',
        () async {
      final int rightValue = 10;
      int sideEffectResult = 0;

      final taskEither = right<String, int>(rightValue);
      final newTaskEither = tap<String, int>((value) {
        sideEffectResult = value + 5;
      })(taskEither);

      final result = await newTaskEither.taskEither();

      expect(result is e.Right<String, int>, true);
      expect((result as e.Right<String, int>).value, equals(rightValue));
      expect(sideEffectResult, equals(15));
    });

    test(
        'tap should not modify the TaskEither and not perform a side effect on a Left value',
        () async {
      final String leftValue = 'Error';
      int sideEffectResult = 0;

      final taskEither = left<String, int>(leftValue);
      final newTaskEither = tap<String, int>((value) {
        sideEffectResult = value + 5;
      })(taskEither);

      final result = await newTaskEither.taskEither();

      expect(result is e.Left<String, int>, true);
      expect((result as e.Left<String, int>).value, equals(leftValue));
      expect(
          sideEffectResult, equals(0)); // Ensure side effect was not performed.
    });
  });
  group('Refinements - ', () {
    test('isLeft should return true for a TaskEither containing a Left value',
        () async {
      final taskEither = left<String, int>('Error');
      final bool result = await isLeft(taskEither);

      expect(result, true);
    });

    test('isRight should return true for a TaskEither containing a Right value',
        () async {
      final taskEither = right<String, int>(42);
      final bool result = await isRight(taskEither);

      expect(result, true);
    });

    test('isLeft should return false for a TaskEither containing a Right value',
        () async {
      final taskEither = right<String, int>(42);
      final bool result = await isLeft(taskEither);

      expect(result, false);
    });

    test('isRight should return false for a TaskEither containing a Left value',
        () async {
      final taskEither = left<String, int>('Error');
      final bool result = await isRight(taskEither);

      expect(result, false);
    });
  });
  group('TaskEither - fromPredicateTaskEither', () {
    bool isEven(int value) => value % 2 == 0;
    final String errorMessage = "Not even!";

    final fromPredicate = fromPredicateTaskEither<String, int>(
      isEven,
      () => errorMessage,
    );

    test('should return a right value if predicate is true', () async {
      final result = fromPredicate(4); // 4 is even.
      final eitherResult = await result.taskEither();

      expect(eitherResult, isA<e.Right<String, int>>());
      expect((eitherResult as e.Right<String, int>).value, 4);
    });

    test('should return a left value if predicate is false', () async {
      final result = fromPredicate(5); // 5 is not even.
      final eitherResult = await result.taskEither();

      expect(eitherResult, isA<e.Left<String, int>>());
      expect((eitherResult as e.Left<String, int>).value, errorMessage);
    });
  });
  group('TaskEither - fromOption', () {
    final String errorMessage = "No value present";

    test('should return a right value if Option is Some', () async {
      final option = o.Some<int>(42);
      final result = fromOption(option, () => errorMessage);
      final eitherResult = await result.taskEither();

      expect(eitherResult, isA<e.Right<String, int>>());
      expect((eitherResult as e.Right<String, int>).value, 42);
    });

    test('should return a left value if Option is None', () async {
      final option = o.None<int>();
      final result = fromOption(option, () => errorMessage);
      final eitherResult = await result.taskEither();

      expect(eitherResult, isA<e.Left<String, int>>());
      expect((eitherResult as e.Left<String, int>).value, errorMessage);
    });
  });

  group('match - ', () {
    test('should handle a Left value', () async {
      final te = left<String, int>('Error');

      final result = await match<String, int, String>(
        (leftValue) async => 'Got left: $leftValue',
        (rightValue) async => 'Got right: $rightValue',
      )(te);

      expect(result, 'Got left: Error');
    });

    test('should handle a Right value', () async {
      final te = right<String, int>(42);

      final result = await match<String, int, String>(
        (leftValue) async => 'Got left: $leftValue',
        (rightValue) async => 'Got right: $rightValue',
      )(te);

      expect(result, 'Got right: 42');
    });
  });

  group('getOrElse', () {
    test('should provide a default value for a Left value', () async {
      final te = left<String, int>('Error');

      final result = await getOrElse(te, (leftValue) => 0);

      expect(result, 0);
    });

    test('should return the Right value when present', () async {
      final te = right<String, int>(42);

      final result = await getOrElse(te, (leftValue) => 0);

      expect(result, 42);
    });
  });
}
