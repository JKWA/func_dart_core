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
  Future<Either<A, B>> Function() get value;

  /// Factory constructor to create a TaskEither from a computation.
  ///
  /// Example:
  /// ```
  /// final computation = TaskEither(() => Future.value(Right<String, int>(5)));
  /// ```
  factory TaskEither(Future<Either<A, B>> Function() value) = _TaskEither<A, B>;
}

class _TaskEither<A, B> implements TaskEither<A, B> {
  final Future<Either<A, B>> Function() _value;

  _TaskEither(this._value);

  @override
  Future<Either<A, B>> Function() get value => _value;

  Future<Either<A, B>> call() => _value();
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

/// Applies the provided functions [onLeft] and [onRight] to handle the
/// contents of a [TaskEither] instance. The returned function takes a [TaskEither]
/// as input, awaits its computation, and depending on whether it's a `Left` or `Right`,
/// invokes the appropriate function.
///
/// Example:
/// ```dart
/// final taskEither = TaskEither<int, String>(() => Future.value(Right<String, int>(5)));
///
/// final result = await matchW<int, String, int, String>(
///     (leftValue) async => 'Error: $leftValue',
///     (rightValue) async => 'Success: $rightValue')(taskEither);
///
/// print(result); // Output: Success: 5
/// ```
Future<D> Function(TaskEither<A, B>) matchW<A, B, C, D>(
    Future<D> Function(A) onLeft, Future<D> Function(B) onRight) {
  return (TaskEither<A, B> taskEither) async =>
      switch (await taskEither.value()) {
        Left(value: var leftValue) => await onLeft(leftValue),
        Right(value: var rightValue) => await onRight(rightValue)
      };
}

/// Matches a [TaskEither<A, B>] to execute a function based on its `Left` or `Right` value asynchronously.
/// Using Dart's pattern matching, the [match] function provides an expressive and concise way to handle
/// `TaskEither` values without manual type checks and returns a [Future<C>] representing the computed value.
///
/// The returned function uses pattern matching on the result of [TaskEither<A, B>] and invokes
/// the relevant asynchronous function (`onLeft` for `Left` or `onRight` for `Right`) based on the match.
///
/// Example:
/// ```dart
/// final myTask = of<String, int>(10);
/// final matchFn = match<String, int, String>(
///     (left) => Future.value("Error: $left"),
///     (right) => Future.value("Value: $right")
/// );
/// final result = await matchFn(myTask);
/// print(result); // Prints: Value: 10
/// ```
// Future<C> Function(TaskEither<A, B>) match<A, B, C>(
//     Future<C> Function(A) onLeft, Future<C> Function(B) onRight) {
//   return (TaskEither<A, B> taskEither) async =>
//       switch (await taskEither.value()) {
//         Left(value: var leftValue) => await onLeft(leftValue),
//         Right(value: var rightValue) => await onRight(rightValue)
//       };
// }
Future<C> Function(TaskEither<A, B>) match<A, B, C>(
    Future<C> Function(A) onLeft, Future<C> Function(B) onRight) {
  return matchW<A, B, C, C>(onLeft, onRight);
}

/// Alias for match.
final fold = match;

/// Transforms the success value of a [TaskEither] instance using the provided function [f].
///
/// The [map] function takes a function [f] of type `B Function(C)` and returns a function
/// that can transform a [TaskEither] with a success value of type `C` into a [TaskEither] with
/// a success value of type `B`. If the [TaskEither] instance contains an error value, it remains unchanged.
///
/// This function is useful when you want to perform a synchronous transformation on the success
/// value of a [TaskEither] without affecting its error value.
///
/// Example:
/// ```dart
/// final myTaskEither = TaskEither<int, String>(() => Future.value(Right<int, String>('Hello')));
///
/// final mappedTaskEither = map<String, int, String>((value) => '$value World')(myTaskEither);
///
/// mappedTaskEither.value.then((result) {
///   // result is Right<int, String>('Hello World')
/// });
///
/// final errorTaskEither = TaskEither<int, String>(() => Future.value(Left<int, String>(404)));
///
/// final anotherMappedTaskEither = map<String, int, String>((value) => '$value World')(errorTaskEither);
///
/// anotherMappedTaskEither.value.then((result) {
///   // result is Left<int, String>(404)
/// });
/// ```
///
/// [f]: The transformation function applied to the success value.
/// Returns: A function that can transform a [TaskEither<A, C>] to a [TaskEither<A, B>].
TaskEither<A, B> Function(TaskEither<A, C>) map<A, C, B>(B Function(C) f) {
  return (TaskEither<A, C> taskEither) => TaskEither<A, B>(() async {
        return await match<A, C, Either<A, B>>(
            (leftValue) async => Left<A, B>(leftValue),
            (rightValue) async => Right<A, B>(f(rightValue)))(taskEither);
      });
}

/// Transforms the success value of a [TaskEither] instance into another [TaskEither] using the provided function [f].
///
/// The [flatMap] function takes a function [f] of type `TaskEither<A, B> Function(C)` and returns a function
/// that can transform a [TaskEither] with a success value of type `C` into a [TaskEither] with a success value of type `B`.
/// If the [TaskEither] instance contains an error value, it remains unchanged.
///
/// This function is useful when you want to chain asynchronous computations that may fail,
/// and transform the success value of one [TaskEither] into another [TaskEither].
///
/// Example:
/// ```dart
/// final myTaskEither = TaskEither<int, String>(() => Future.value(Right<int, String>('Hello')));
///
/// final transformedTaskEither = flatMap<String, int, String>((value) =>
///     TaskEither<int, String>(() => Future.value(Right<int, String>('$value World')))
/// )(myTaskEither);
///
/// transformedTaskEither.value.then((result) {
///   // result is Right<int, String>('Hello World')
/// });
///
/// final errorTaskEither = TaskEither<int, String>(() => Future.value(Left<int, String>(404)));
///
/// final anotherTransformedTaskEither = flatMap<String, int, String>((value) =>
///     TaskEither<int, String>(() => Future.value(Right<int, String>('$value World')))
/// )(errorTaskEither);
///
/// anotherTransformedTaskEither.value.then((result) {
///   // result is Left<int, String>(404)
/// });
/// ```
///
/// [f]: The transformation function applied to the success value.
/// Returns: A function that can transform a [TaskEither<A, C>] to a [TaskEither<A, B>].
TaskEither<A, B> Function(TaskEither<A, C>) flatMap<A, C, B>(
        TaskEither<A, B> Function(C) f) =>
    (TaskEither<A, C> taskEither) => TaskEither<A, B>(() async =>
        await match<A, C, Either<A, B>>((a) => Future.value(Left<A, B>(a)),
            (c) async => await f(c).value())(taskEither));

/// Alias for flatMap, allowing for chaining asynchronous operations.
final chain = flatMap;

/// Applies the provided function wrapped in a [TaskEither] instance to a [TaskEither] instance.
///
/// The [ap] function allows you to apply a function wrapped inside a `TaskEither` (usually referred to as an "applicative action")
/// to another `TaskEither` instance. It is essentially used to combine the effects of two `TaskEither` instances.
///
/// This function is primarily useful in contexts where you have both data and function inside a context (in this case, `TaskEither`)
/// and you want to apply this function to this data, all while keeping everything inside the context.
///
/// Example:
/// ```dart
/// final myFunctionTaskEither = TaskEither<int, String Function(int)>(
///     () => Future.value(Right<int, String Function(int)>((x) => 'Result: ${x + 10}'))
/// );
///
/// final myDataTaskEither = TaskEither<int, int>(() => Future.value(Right<int, int>(5)));
///
/// final resultTaskEither = ap(myFunctionTaskEither)(myDataTaskEither);
///
/// resultTaskEither.value.then((result) {
///   // result is Right<int, String>('Result: 15')
/// });
///
/// final errorFunctionTaskEither = TaskEither<int, String Function(int)>(
///     () => Future.value(Left<int, String Function(int)>(404))
/// );
///
/// final anotherResultTaskEither = ap(errorFunctionTaskEither)(myDataTaskEither);
///
/// anotherResultTaskEither.value.then((result) {
///   // result is Left<int, String Function(int)>(404)
/// });
/// ```
///
/// [fnTaskEither]: The `TaskEither` containing the function to be applied.
/// Returns: A function that takes a [TaskEither] and applies the function contained in [fnTaskEither] to it.
TaskEither<A, B> Function(TaskEither<A, C>) ap<A, C, B>(
        TaskEither<A, B Function(C)> fnTaskEither) =>
    (TaskEither<A, C> taskEither) => flatMap<A, B Function(C), B>(
        (B Function(C) fn) => map<A, C, B>(fn)(taskEither))(fnTaskEither);

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
    taskEither.value().then((eitherResult) {
      if (eitherResult is Right<A, B>) {
        f(eitherResult.value);
      }
    }).catchError((_) {});
    return taskEither;
  };
}

/// Alias for tap.
final chainFirst = tap;

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
    switch (option) {
      case o.Some(value: var someValue):
        return Right<A, B>(someValue);
      case o.None():
        return Left<A, B>(leftValue());
    }
  });
}

/// Extracts the value from `Right` or provides a default value for `Left`.
///
/// Example:
/// ```
/// final myTask = left<String, int>("Error");
/// final value = await getOrElse(myTask, (error) => 0); // 0
/// ```
Future<B> getOrElse<A, B>(
    TaskEither<A, B> taskEither, B Function(A) defaultValue) async {
  final result = await taskEither.value();

  switch (result) {
    case Left(value: var leftValue):
      return defaultValue(leftValue);
    case Right(value: var rightValue):
      return rightValue;
  }
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
/// final result = await sequenceList(taskEithers);
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
/// final result = await sequenceList(taskEithers);
///
/// if (result is Left) {
///   print(result.value); // Expected output: "Error"
/// }
/// ```
///
/// @param list The list of `TaskEither` computations to be sequenced.
/// @return A `Future` that resolves to an `Either` containing either an error
/// or a list of results.
Future<Either<A, il.ImmutableList<B>>> sequenceList<A, B>(
    il.ImmutableList<TaskEither<A, B>> list) async {
  final results = <B>[];

  for (var taskEither in list) {
    Either<A, B> result = await taskEither.value();
    switch (result) {
      case Left(value: var leftValue):
        return Left<A, il.ImmutableList<B>>(leftValue);
      case Right(value: var rightValue):
        results.add(rightValue);
    }
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
/// final result = await traverseList(doublingFunction, items);
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
/// final result = await traverseList(functionWithError, items);
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
Future<Either<E, il.ImmutableList<B>>> traverseList<E, A, B>(
    TaskEither<E, B> Function(A) f, il.ImmutableList<A> list) async {
  final results = <B>[];

  for (final item in list) {
    final result = await f(item).value();
    switch (result) {
      case Left(value: var leftValue):
        return Left<E, il.ImmutableList<B>>(leftValue);
      case Right(value: var rightValue):
        results.add(rightValue);
    }
  }

  return Right<E, il.ImmutableList<B>>(il.of(results));
}
