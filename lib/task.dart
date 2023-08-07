import 'package:functional_dart/function.dart';

/// Abstract class `Task` that represents a computation
/// that may produce a result of type [A] in the future.
///
/// Example:
/// ```dart
/// Task<int> sampleTask = Task<int>(() => Future.value(10));
/// ```
abstract class Task<A> {
  /// The computation of this task represented as a Future.
  Future<A> Function() get task;

  /// Factory constructor that creates a task from a computation.
  factory Task(Future<A> Function() task) = _Task<A>;
}

/// The concrete implementation of the abstract class `Task`.
class _Task<A> implements Task<A> {
  /// The computation of this task represented as a Future.
  final Future<A> Function() _task;

  _Task(this._task);

  /// Getter for the computation.
  @override
  Future<A> Function() get task => _task;

  /// Calls the computation of this task.
  Future<A> call() => _task();
}

/// Transforms the result of a task using a function `f`.
///
/// Example:
/// ```dart
/// Task<int> sampleTask = Task<int>(() => Future.value(10));
/// Task<int> newTask = map(sampleTask, (value) => value + 10);
/// ```
Task<B> map<A, B>(Task<A> task, B Function(A) f) {
  return Task<B>(() async => f(await task.task()));
}

/// Transforms the result of a task using a function `f` that
/// returns a new task.
///
/// Example:
/// ```dart
/// Task<int> sampleTask = Task<int>(() => Future.value(10));
/// Task<int> newTask = flatMap(sampleTask, (value) => Task<int>(() => Future.value(value + 10)));
/// ```
Task<B> flatMap<A, B>(Task<A> task, Task<B> Function(A) f) {
  return Task<B>(() async => (await (f(await task.task())).task()));
}

/// Alias for [flatMap].
///
/// Provides a way to handle an [Task] by chaining function calls.final chain = flatMap;
final chain = flatMap;

/// Transforms the result of a task using a function contained in another task.
///
/// Example:
/// ```dart
/// Task<int> sampleTask = Task<int>(() => Future.value(10));
/// Task<int Function(int)> functionTask = Task<int Function(int)>(() => Future.value((value) => value * 2));
/// Task<int> newTask = ap(functionTask, sampleTask);
/// ```
Task<B> ap<A, B>(Task<B Function(A)> fTask, Task<A> m) {
  return flatMap(fTask, (B Function(A) f) {
    return map(m, f);
  });
}

/// Constructs a task that resolves to a given value.
///
/// Example:
/// ```dart
/// Task<int> sampleTask = of(10);
/// ```
Task<B> of<B>(B value) {
  return Task<B>(() => Future.value(value));
}

/// Returns the same task given as argument.
///
/// Example:
/// ```dart
/// Task<int> sampleTask = Task<int>(() => Future.value(10));
/// Task<int> newTask = fromTask(sampleTask);  // newTask is the same as sampleTask.
/// ```
Task<A> fromTask<A>(Task<A> fa) {
  return identity(fa);
}

/// Type definition for a function that transforms a task into another task
/// after performing a side effect.
typedef TapFunction<A> = Task<A> Function(Task<A> task);

/// Transforms a task into another task after performing a side effect.
///
/// Example:
/// ```dart
/// Task<int> sampleTask = Task<int>(() => Future.value(10));
/// Task<int> newTask = tap<int>((value) => print(value))(sampleTask); // Prints the result and returns the same task.
/// ```
TapFunction<A> tap<A>(void Function(A) f) {
  return (Task<A> task) {
    task.task().then(f).catchError((_) {});
    return task;
  };
}

/// Alias for [tap].
///
/// Provides a side effect function [Function] that is applied to the value
final chainFirst = tap;
