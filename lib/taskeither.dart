import 'package:func_dart_core/either.dart';
import 'package:func_dart_core/list.dart' as il;
import 'package:func_dart_core/option.dart' as o;
import 'package:func_dart_core/predicate.dart';

/// `TaskEither` is a representation of asynchronous computations that can fail.
/// It's a way of combining the concepts of `Future` and `Either`.
///
/// Example:
/// ```
/// final myTaskEither = TaskEither(() => Future.value(Right<String, int>(42)));
/// ```
sealed class TaskEither<A, B> {
  /// Represents the computation that will return an `Either<A, B>`.
  Future<Either<A, B>> Function() get taskEither;

  /// Factory constructor to create a TaskEither from a computation.
  ///
  /// Example:
  /// ```
  /// final computation = TaskEither(() => Future.value(Right<String, int>(5)));
  /// ```
  factory TaskEither(Future<Either<A, B>> Function() taskEither) =
      _TaskEither<A, B>;
}

class _TaskEither<A, B> implements TaskEither<A, B> {
  final Future<Either<A, B>> Function() _taskEither;

  _TaskEither(this._taskEither);

  @override
  Future<Either<A, B>> Function() get taskEither => _taskEither;

  Future<Either<A, B>> call() => _taskEither();
}

/// Create a `Left` value wrapped in a `TaskEither`.
///
/// Example:
/// ```
/// final errorTask = left<String, int>("Error");
/// ```
TaskEither<A, B> left<A, B>(A value) {
  return TaskEither(() => Future.value(Left<A, B>(value)));
}

/// Create a `Right` value wrapped in a `TaskEither`.
///
/// Example:
/// ```
/// final successTask = right<String, int>(10);
/// ```
TaskEither<A, B> right<A, B>(B value) {
  return TaskEither(() => Future.value(Right<A, B>(value)));
}

/// Shorthand for creating a `Right` value wrapped in a `TaskEither`.
///
/// Example:
/// ```
/// final myTask = of<String, int>(15);
/// ```
TaskEither<A, B> of<A, B>(B value) {
  return right(value);
}

/// Maps over the successful result of the `TaskEither`, applying the function `f`.
///
/// Example:
/// ```
/// final original = of<String, int>(5);
/// final mapped = map(original, (num) => num * 2);
/// ```
TaskEither<A, B> map<A, C, B>(TaskEither<A, C> taskEither, B Function(C) f) {
  return TaskEither<A, B>(() async {
    final result = await taskEither.taskEither();

    if (result is Left<A, C>) {
      return Left<A, B>(result.value);
    } else if (result is Right<A, C>) {
      return Right<A, B>(f(result.value));
    }
    throw AssertionError("Unreachable code");
  });
}

/// FlatMaps over the successful result of the `TaskEither`, allowing to chain asynchronous operations.
///
/// Example:
/// ```
/// final original = of<String, int>(5);
/// final flatMapped = flatMap(original, (num) => of<String, int>(num * 2));
/// ```
TaskEither<A, B> flatMap<A, C, B>(
    TaskEither<A, C> taskEither, TaskEither<A, B> Function(C) f) {
  return TaskEither<A, B>(() async {
    final result = await taskEither.taskEither();

    if (result is Left<A, C>) {
      return Left<A, B>(result.value);
    } else if (result is Right<A, C>) {
      return await f(result.value).taskEither();
    }
    throw AssertionError("Unreachable code");
  });
}

/// Alias for flatMap, allowing for chaining asynchronous operations.
final chain = flatMap;

/// Applies the function wrapped in the `TaskEither` to another `TaskEither` value.
///
/// Example:
/// ```
/// final functionTask = of<String, Function(int)>( (num) => num + 10 );
/// final valueTask = of<String, int>(5);
/// final applied = ap(functionTask, valueTask);
/// ```
TaskEither<A, B> ap<A, C, B>(
    TaskEither<A, B Function(C)> fTaskEither, TaskEither<A, C> m) {
  return flatMap(fTaskEither, (B Function(C) f) {
    return map(m, f);
  });
}

typedef TapFunctionEither<A, B> = TaskEither<A, B> Function(
    TaskEither<A, B> taskEither);

/// Applies a side effect on a successful result of the `TaskEither` without modifying it.
///
/// Example:
/// ```
/// final original = of<String, int>(10);
/// tap<int, int>((value) => print(value))(original);
/// ```
TapFunctionEither<A, B> tap<A, B>(void Function(B) f) {
  return (TaskEither<A, B> taskEither) {
    taskEither.taskEither().then((eitherResult) {
      if (eitherResult is Right<A, B>) {
        f(eitherResult.value);
      }
    }).catchError((_) {});
    return taskEither;
  };
}

/// Alias for tap.
final chainFirst = tap;

/// Checks if the `TaskEither` is a Left value.
///
/// Example:
/// ```
/// final original = left<String, int>("Error");
/// final result = await isLeft(original); // true
/// ```
Future<bool> isLeft<A, B>(TaskEither<A, B> taskEither) async {
  final either = await taskEither.taskEither();
  return either is Left<A, B>;
}

/// Checks if the `TaskEither` is a Right value.
///
/// Example:
/// ```
/// final original = of<String, int>(15);
/// final result = await isRight(original); // true
/// ```
Future<bool> isRight<A, B>(TaskEither<A, B> taskEither) async {
  final either = await taskEither.taskEither();
  return either is Right<A, B>;
}

/// Creates a `TaskEither` from a predicate and value.
/// Returns `Right` if predicate passes, otherwise returns `Left` with a provided error value.
///
/// Example:
/// ```
/// final checkPositive = fromPredicateTaskEither<String, int>(
///     (num) => num > 0,
///     () => "Number is not positive"
/// );
/// final result = checkPositive(5); // Right(5)
/// ```
TaskEither<A, B> Function(B value) fromPredicateTaskEither<A, B>(
    Predicate<B> predicate, A Function() leftValue) {
  return (B value) {
    if (predicate(value)) {
      return right<A, B>(value);
    } else {
      return left<A, B>(leftValue());
    }
  };
}

/// Converts an `Option` into a `TaskEither`, providing a default `Left` value for `None`.
///
/// Example:
/// ```
/// final myOption = o.Some(10);
/// final result = fromOption<String, int>(myOption, () => "No value");
/// ```
TaskEither<A, B> fromOption<A, B>(o.Option<B> option, A Function() leftValue) {
  return TaskEither<A, B>(() async {
    if (option is o.Some<B>) {
      return Right<A, B>(option.value);
    } else if (option is o.None<B>) {
      return Left<A, B>(leftValue());
    }
    throw AssertionError("Unreachable code");
  });
}

/// Allows handling both `Left` and `Right` values of the `TaskEither` and returns a new value.
///
/// Example:
/// ```
/// final myTask = of<String, int>(10);
/// final result = await match<String, int, String>(
///     (left) => Future.value("Error: $left"),
///     (right) => Future.value("Value: $right")
/// )(myTask); // Value: 10
/// ```
Future<C> Function(TaskEither<A, B>) match<A, B, C>(
    Future<C> Function(A) onLeft, Future<C> Function(B) onRight) {
  return (TaskEither<A, B> taskEither) async {
    final either = await taskEither.taskEither();

    if (either is Left<A, B>) {
      return await onLeft(either.value);
    } else if (either is Right<A, B>) {
      return await onRight(either.value);
    }
    throw Exception("TaskEither must be Left or Right");
  };
}

/// Alias for match.
final fold = match;

/// Extracts the value from `Right` or provides a default value for `Left`.
///
/// Example:
/// ```
/// final myTask = left<String, int>("Error");
/// final value = await getOrElse(myTask, (error) => 0); // 0
/// ```
Future<B> getOrElse<A, B>(
    TaskEither<A, B> taskEither, B Function(A) defaultValue) async {
  final result = await taskEither.taskEither();

  if (result is Left<A, B>) {
    return defaultValue(result.value);
  } else if (result is Right<A, B>) {
    return result.value;
  }
  throw Exception("TaskEither must be Left or Right");
}

/// Sequences a list of `TaskEither` into a single `TaskEither` that produces a list of results.
///
/// If any of the `TaskEither` computations in the list results in a `Left`,
/// the whole computation will short-circuit and return that `Left`.
/// If all computations are successful (i.e., they all result in a `Right`),
/// a single `Right` containing a list of all the results is returned.
///
/// Example:
/// ```dart
/// final taskEithers = il.ImmutableList<TaskEither<String, int>>([
///   TaskEither(() => Future.value(Right<String, int>(1))),
///   TaskEither(() => Future.value(Right<String, int>(2))),
///   TaskEither(() => Future.value(Right<String, int>(3))),
/// ]);
///
/// final result = await sequenceListTaskEither(taskEithers);
///
/// if (result is Right) {
///   print(result.value); // Expected output: [1, 2, 3]
/// }
/// ```
///
/// Error handling example:
/// ```dart
/// final taskEithers = il.ImmutableList<TaskEither<String, int>>([
///   TaskEither(() => Future.value(Right<String, int>(1))),
///   TaskEither(() => Future.value(Left<String, int>("Error"))),
///   TaskEither(() => Future.value(Right<String, int>(3))),
/// ]);
///
/// final result = await sequenceListTaskEither(taskEithers);
///
/// if (result is Left) {
///   print(result.value); // Expected output: "Error"
/// }
/// ```
///
/// @param list The list of `TaskEither` computations to be sequenced.
/// @return A `Future` that resolves to an `Either` containing either an error
/// or a list of results.
Future<Either<A, il.ImmutableList<B>>> sequenceListTaskEither<A, B>(
    il.ImmutableList<TaskEither<A, B>> list) async {
  final results = <B>[];

  for (var taskEither in list) {
    Either<A, B> result = await taskEither.taskEither();
    if (result is Left<A, B>) {
      return Left(result.value);
    }
    results.add((result as Right<A, B>).value);
  }

  return Right(il.of(results));
}

/// Traverses a list of items, applying a function to each item, and then
/// sequences the resulting list of `TaskEither` into a single `TaskEither` that
/// produces a list of results.
///
/// The provided function `f` should transform an item of type `A` into a `TaskEither<E, B>`.
///
/// If any of the transformed `TaskEither` computations results in a `Left`,
/// the whole computation will short-circuit and return that `Left`.
/// If all computations are successful (i.e., they all result in a `Right`),
/// a single `Right` containing a list of all the results is returned.
///
/// Example:
/// ```dart
/// final items = il.ImmutableList<int>([1, 2, 3]);
/// TaskEither<String, int> doublingFunction(int item) =>
///   TaskEither(() => Future.value(Right<String, int>(item * 2)));
///
/// final result = await traverseListTaskEither(doublingFunction, items);
///
/// if (result is Right) {
///   print(result.value); // Expected output: [2, 4, 6]
/// }
/// ```
///
/// Error handling example:
/// ```dart
/// final items = il.ImmutableList<int>([1, 2, 3]);
/// TaskEither<String, int> functionWithError(int item) {
///   if (item == 2) {
///     return TaskEither(() => Future.value(Left<String, int>("Error on 2")));
///   } else {
///     return TaskEither(() => Future.value(Right<String, int>(item * 2)));
///   }
/// }
///
/// final result = await traverseListTaskEither(functionWithError, items);
///
/// if (result is Left) {
///   print(result.value); // Expected output: "Error on 2"
/// }
/// ```
///
/// @param f The function to be applied to each item in the list.
/// @param list The list of items to traverse.
/// @return A `Future` that resolves to an `Either` containing either an error
/// or a list of results.
Future<Either<E, il.ImmutableList<B>>> traverseListTaskEither<E, A, B>(
    TaskEither<E, B> Function(A) f, il.ImmutableList<A> list) async {
  final results = <B>[];

  for (final item in list) {
    final result = await f(item).taskEither();

    if (result is Left<E, B>) {
      return Left<E, il.ImmutableList<B>>(result.value);
    }
    results.add((result as Right<E, B>).value);
  }

  return Right<E, il.ImmutableList<B>>(il.ImmutableList<B>(results));
}
