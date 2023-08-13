import 'package:func_dart_core/either.dart' as e;
import 'package:func_dart_core/list.dart' as il;
import 'package:func_dart_core/option.dart' as o;
import 'package:func_dart_core/taskeither.dart';
import 'package:test/test.dart';

class TaskError {
  final String message;
  TaskError(this.message);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

void main() {
  group('TaskEither - lift', () {
    test('left should return a Left wrapped in a Future', () async {
      final String value = 'Error';
      final te = left<String, int>(value);

      expect(await te.value(), e.Left<String, int>(value));
    });

    test('right should return a Right wrapped in a Future', () async {
      final int value = 42;
      final te = right<String, int>(value);

      expect(await te.value(), e.Right<String, int>(value));
    });

    test('of should wrap a value into a Right wrapped in a Future', () async {
      final int value = 99;
      final te = of<String, int>(value);

      expect(await te.value(), e.Right<String, int>((value)));
    });
  });
  group('map - ', () {
    test('it should map over a Right value', () async {
      final te = TaskEither<Error, int>(() async => e.Right(5));
      final mapper = map<Error, int, String>((int value) => 'Value: $value');
      final mappedTE = mapper(te);

      final result = await mappedTE.value();

      expect(
          result,
          isA<
              e.Right<Error,
                  String>>()); // Notice the change here from int to String
      expect((result as e.Right<Error, String>).value, 'Value: 5');
    });

    test('it should not affect a Left value', () async {
      final te = TaskEither<Error, int>(() async => e.Left(Error()));
      final mapper = map<Error, int, String>((int value) => 'Value: $value');
      final mappedTE = mapper(te);

      final result = await mappedTE.value();

      expect(
          result,
          isA<
              e.Left<Error,
                  String>>()); // Notice the change here from int to String
      expect((result as e.Left<Error, String>).value, isA<Error>());
    });

    test('it should handle exceptions thrown inside the TaskEither', () async {
      final te = TaskEither<Error, int>(() async {
        throw Error();
      });

      final mapper = map<Error, int, String>((int value) => 'Value: $value');
      final mappedTE = mapper(te);

      expect(mappedTE.value(), throwsA(isA<Error>()));
    });
  });

  group('flatMap - ', () {
    test('it should process a Right value correctly', () async {
      final te = TaskEither<Error, int>(() async => e.Right(5));
      final mapper = flatMap<Error, int, String>((int value) =>
          TaskEither<Error, String>(() async => e.Right('Value: $value')));
      final mappedTE = mapper(te);

      final result = await mappedTE.value();

      expect(result, isA<e.Right<Error, String>>());
      expect((result as e.Right<Error, String>).value, 'Value: 5');
    });

    test('it should not affect a Left value', () async {
      final te = TaskEither<Error, int>(() async => e.Left(Error()));
      final mapper = flatMap<Error, int, String>((int value) =>
          TaskEither<Error, String>(() async => e.Right('Value: $value')));
      final mappedTE = mapper(te);

      final result = await mappedTE.value();

      expect(result, isA<e.Left<Error, String>>());
      expect((result as e.Left<Error, String>).value, isA<Error>());
    });

    test('it should handle nested Right values correctly', () async {
      final te = TaskEither<Error, int>(() async => e.Right(5));
      final mapper = flatMap<Error, int, String>((int value) =>
          TaskEither<Error, String>(() async => value > 3
              ? e.Right('Value is greater than 3')
              : e.Right('Value is not greater than 3')));
      final mappedTE = mapper(te);

      final result = await mappedTE.value();

      expect(result, isA<e.Right<Error, String>>());
      expect(
          (result as e.Right<Error, String>).value, 'Value is greater than 3');
    });
  });

  group('ap -', () {
    test('it should apply a Right function to a Right value', () async {
      final fTaskEither = TaskEither<Error, String Function(int)>(
          () async => e.Right((int val) => 'Value: $val'));
      final m = TaskEither<Error, int>(() async => e.Right(5));

      final resultTE = ap(fTaskEither)(m);
      final result = await resultTE.value();

      expect(result, isA<e.Right<Error, String>>());
      expect((result as e.Right<Error, String>).value, 'Value: 5');
    });

    test('it should not apply a Right function to a Left value', () async {
      final fTaskEither = TaskEither<Error, String Function(int)>(
          () async => e.Right((int val) => 'Value: $val'));
      final m = TaskEither<Error, int>(() async => e.Left(Error()));

      final resultTE = ap(fTaskEither)(m);
      final result = await resultTE.value();

      expect(result, isA<e.Left<Error, String>>());
      expect((result as e.Left).value, isA<Error>());
    });

    test('it should not apply a Left function to a Right value', () async {
      final fTaskEither =
          TaskEither<Error, String Function(int)>(() async => e.Left(Error()));
      final m = TaskEither<Error, int>(() async => e.Right(5));

      final resultTE = ap(fTaskEither)(m);
      final result = await resultTE.value();

      expect(result, isA<e.Left<Error, String>>());
      expect((result as e.Left).value, isA<Error>());
    });

    test('it should not apply a Left function to a Left value', () async {
      final fTaskEither =
          TaskEither<Error, String Function(int)>(() async => e.Left(Error()));
      final m = TaskEither<Error, int>(() async => e.Left(Error()));

      final resultTE = ap(fTaskEither)(m);
      final result = await resultTE.value();

      expect(result, isA<e.Left<Error, String>>());
      expect((result as e.Left).value, isA<Error>());
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

      final result = await newTaskEither.value();

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

      final result = await newTaskEither.value();

      expect(result is e.Left<String, int>, true);
      expect((result as e.Left<String, int>).value, equals(leftValue));
      expect(
          sideEffectResult, equals(0)); // Ensure side effect was not performed.
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
      final eitherResult = await result.value();

      expect(eitherResult, isA<e.Right<String, int>>());
      expect((eitherResult as e.Right<String, int>).value, 4);
    });

    test('should return a left value if predicate is false', () async {
      final result = fromPredicate(5); // 5 is not even.
      final eitherResult = await result.value();

      expect(eitherResult, isA<e.Left<String, int>>());
      expect((eitherResult as e.Left<String, int>).value, errorMessage);
    });
  });
  group('TaskEither - fromOption', () {
    final String errorMessage = "No value present";

    test('should return a right value if Option is Some', () async {
      final option = o.Some<int>(42);
      final result = fromOption(option, () => errorMessage);
      final eitherResult = await result.value();

      expect(eitherResult, isA<e.Right<String, int>>());
      expect((eitherResult as e.Right<String, int>).value, 42);
    });

    test('should return a left value if Option is None', () async {
      final option = o.None<int>();
      final result = fromOption(option, () => errorMessage);
      final eitherResult = await result.value();

      expect(eitherResult, isA<e.Left<String, int>>());
      expect((eitherResult as e.Left<String, int>).value, errorMessage);
    });
  });

  group('matchW for TaskEither', () {
    test('should handle Left value', () async {
      final taskEither =
          TaskEither<int, String>(() => Future.value(e.Left(42)));
      final result = await matchW<int, String, int, String>(
          (a) async => 'Error: $a', (b) async => 'Success: $b')(taskEither);
      expect(result, equals('Error: 42'));
    });

    test('should handle Right value', () async {
      final taskEither =
          TaskEither<int, String>(() => Future.value(e.Right('Hello')));
      final result = await matchW<int, String, int, String>(
          (a) async => 'Error: $a', (b) async => 'Success: $b')(taskEither);
      expect(result, equals('Success: Hello'));
    });

    test('should propagate errors from onLeft function', () async {
      final taskEither =
          TaskEither<int, String>(() => Future.value(e.Left(42)));
      final result = matchW<int, String, int, String>(
          (a) async => throw Exception('Error in onLeft'),
          (b) async => 'Success: $b')(taskEither);
      expect(result, throwsException);
    });

    test('should propagate errors from onRight function', () async {
      final taskEither =
          TaskEither<int, String>(() => Future.value(e.Right('Hello')));
      final result = matchW<int, String, int, String>((a) async => 'Error: $a',
          (b) async => throw Exception('Error in onRight'))(taskEither);
      expect(result, throwsException);
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
  group('sequenceList', () {
    test('should sequence a list of TaskEither successfully', () async {
      var tasks = il.ImmutableList<TaskEither<String, int>>([
        TaskEither(() => Future.value(e.Right<String, int>(1))),
        TaskEither(() => Future.value(e.Right<String, int>(2))),
        TaskEither(() => Future.value(e.Right<String, int>(3))),
      ]);

      var result = await sequenceList(tasks);

      expect(result, isA<e.Right<String, il.ImmutableList<int>>>());
      expect(
          (result as e.Right<String, il.ImmutableList<int>>).value, [1, 2, 3]);
    });

    test('should return error if any TaskEither fails', () async {
      var tasks = il.ImmutableList<TaskEither<String, int>>([
        TaskEither(() => Future.value(e.Right<String, int>(1))),
        TaskEither(() => Future.value(e.Left<String, int>("Error"))),
        TaskEither(() => Future.value(e.Right<String, int>(3))),
      ]);

      var result = await sequenceList(tasks);

      expect(result, isA<e.Left<String, il.ImmutableList<int>>>());
      expect((result as e.Left<String, il.ImmutableList<int>>).value, "Error");
    });

    test('should handle an empty list of TaskEither', () async {
      var tasks = il.ImmutableList<TaskEither<String, int>>([]);

      var result = await sequenceList(tasks);

      expect(result, isA<e.Right<String, il.ImmutableList<int>>>());
      expect((result as e.Right<String, il.ImmutableList<int>>).value,
          il.zero<int>());
    });
  });

  group('traverseList - ', () {
    test('should traverse a list of items to TaskEither successfully',
        () async {
      final items = il.ImmutableList<int>([1, 2, 3]);
      TaskEither<String, int> function(int item) =>
          TaskEither(() => Future.value(e.Right<String, int>(item * 2)));

      final result = await traverseList(function, items);

      expect(result, isA<e.Right<String, il.ImmutableList<int>>>());
      expect((result as e.Right).value, [2, 4, 6]);
    });

    test(
        'should return error if any function call returns a Left in TaskEither',
        () async {
      final items = il.ImmutableList<int>([1, 2, 3]);
      TaskEither<String, int> function(int item) {
        if (item == 2) {
          return TaskEither(
              () => Future.value(e.Left<String, int>("Error on 2")));
        } else {
          return TaskEither(() => Future.value(e.Right<String, int>(item * 2)));
        }
      }

      final result = await traverseList(function, items);

      expect(result, isA<e.Left<String, il.ImmutableList<int>>>());
      expect((result as e.Left).value, "Error on 2");
    });

    test('should handle an empty list of items', () async {
      final items = il.ImmutableList<int>([]);
      TaskEither<String, int> function(int item) =>
          TaskEither(() => Future.value(e.Right<String, int>(item * 2)));

      final result = await traverseList(function, items);

      expect(result, isA<e.Right<String, il.ImmutableList<int>>>());
      expect((result as e.Right).value, il.zero<int>());
    });
  });
}
