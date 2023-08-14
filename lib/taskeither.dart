import 'package:func_dart_core/either.dart' as e;
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
  Future<e.Either<A, B>> Function() get value;

  /// Factory constructor to create a TaskEither from a computation.
  ///
  /// Example:
  /// ```
  /// final computation = TaskEither(() => Future.value(Right<String, int>(5)));
  /// ```
  factory TaskEither(Future<e.Either<A, B>> Function() value) =
      _TaskEither<A, B>;
}

class _TaskEither<A, B> implements TaskEither<A, B> {
  final Future<e.Either<A, B>> Function() _value;

  _TaskEither(this._value);

  @override
  Future<e.Either<A, B>> Function() get value => _value;

  Future<e.Either<A, B>> call() => _value();
}

/// Create a `Left` value wrapped in a `TaskEither`.
///
/// Example:
/// ```
/// final errorTask = left<String, int>("Error");
/// ```
TaskEither<A, B> left<A, B>(A value) {
  return TaskEither(() => Future.value(e.Left<A, B>(value)));
}

/// Create a `Right` value wrapped in a `TaskEither`.
///
/// Example:
/// ```
/// final successTask = right<String, int>(10);
/// ```
TaskEither<A, B> right<A, B>(B value) {
  return TaskEither(() => Future.value(e.Right<A, B>(value)));
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
        e.Left(value: var leftValue) => await onLeft(leftValue),
        e.Right(value: var rightValue) => await onRight(rightValue)
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
        return await match<A, C, e.Either<A, B>>(
            (leftValue) async => e.Left<A, B>(leftValue),
            (rightValue) async => e.Right<A, B>(f(rightValue)))(taskEither);
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
        await match<A, C, e.Either<A, B>>((a) => Future.value(e.Left<A, B>(a)),
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
      if (eitherResult is e.Right<A, B>) {
        f(eitherResult.value);
      }
    }).catchError((_) {});
    return taskEither;
  };
}

/// Alias for tap.
final chainFirst = tap;

/// Creates a [TaskEither] based on a predicate function.
///
/// This function evaluates a given predicate using the provided value. If the
/// predicate evaluates to `true`, the result is a [TaskEither] that resolves to
/// a [e.Right] with the same value. If the predicate evaluates to `false`, the result
/// is a [TaskEither] that resolves to a [e.Left] with the value produced by the `leftValue` function.
///
/// ```dart
/// /// Example:
/// final predicate = (int value) => value > 5;
/// final leftValue = () => "Less than or equal to 5";
/// final taskEitherFunction = fromPredicate<String, int>(predicate, leftValue);
///
/// taskEitherFunction(6).value().then((result) {
///   if (result is e.Right) {
///     print(result.value); // Outputs: 6
///   } else if (result is e.Left) {
///     print(result.value); // This line won't execute for the value 6
///   }
/// });
///
/// taskEitherFunction(4).value().then((result) {
///   if (result is e.Right) {
///     print(result.value); // This line won't execute for the value 4
///   } else if (result is e.Left) {
///     print(result.value); // Outputs: "Less than or equal to 5"
///   }
/// });
/// ```
///
/// [A]: The type of the left value.
/// [B]: The type of the right value and the input value.
///
/// Returns a function that takes a value of type [B] and produces a [TaskEither] of [A] or [B].
TaskEither<A, B> Function(B value) fromPredicate<A, B>(
  Predicate<B> predicate,
  A Function() leftValue,
) {
  return (B value) =>
      predicate(value) ? right<A, B>(value) : left<A, B>(leftValue());
}

/// Converts an [o.Option<B>] into a [TaskEither<A, B>] based on whether the option contains a value or not.
///
/// If the option is of type [o.Some], the resulting [TaskEither] will contain the encapsulated value of type `B`
/// in its [e.Right] side. If the option is of type [o.None], the provided function `leftValue` will be invoked
/// and its result will be wrapped in the [e.Left] side of the resulting [TaskEither].
///
/// This allows transforming optional values into asynchronous computations that can produce either a value or an error.
///
/// Usage:
/// ```dart
/// final maybeValue = o.Some(5);
/// final fallback = () => "No value found";
/// final taskEither = fromOption<int, String>(fallback)(maybeValue);
///
/// // If `maybeValue` was o.Some(5), `taskEither` will now contain a Right with value 5.
/// // If `maybeValue` was o.None(), `taskEither` will contain a Left with the result of `fallback`.
/// ```
TaskEither<A, B> Function(o.Option<B> option) fromOption<A, B>(
        A Function() leftValue) =>
    (o.Option<B> option) => option is o.Some<B>
        ? right<A, B>(option.value)
        : left<A, B>(leftValue());

/// Retrieves the value from a [TaskEither<A, B>], or produces a default value if it's a [e.Left].
///
/// Usage:
/// ```dart
/// final taskEither = TaskEither.value(e.Right<int, int>(5));
/// final result = await getOrElse<int, int>((error) => -1)(taskEither);
///
/// // `result` will be 5 if `taskEither` contains a Right(5), or -1 if it contains a Left.
/// ```
Future<B> Function(TaskEither<A, B>) getOrElse<A, B>(
    B Function(A) defaultValue) {
  return (TaskEither<A, B> taskEither) async {
    final result = await taskEither.value();
    return result is e.Left<A, B>
        ? defaultValue(result.value)
        : (result as e.Right<A, B>).value;
  };
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
Future<e.Either<A, il.ImmutableList<B>>> sequenceList<A, B>(
    il.ImmutableList<TaskEither<A, B>> list) async {
  final results = <B>[];

  for (var taskEither in list) {
    e.Either<A, B> result = await taskEither.value();
    switch (result) {
      case e.Left(value: var leftValue):
        return e.Left<A, il.ImmutableList<B>>(leftValue);
      case e.Right(value: var rightValue):
        results.add(rightValue);
    }
  }

  return e.Right(il.of(results));
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
Future<e.Either<E, il.ImmutableList<B>>> traverseList<E, A, B>(
    TaskEither<E, B> Function(A) f, il.ImmutableList<A> list) async {
  final results = <B>[];

  for (final item in list) {
    final result = await f(item).value();
    switch (result) {
      case e.Left(value: var leftValue):
        return e.Left<E, il.ImmutableList<B>>(leftValue);
      case e.Right(value: var rightValue):
        results.add(rightValue);
    }
  }

  return e.Right<E, il.ImmutableList<B>>(il.of(results));
}
