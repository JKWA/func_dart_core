import 'package:func_dart_core/function.dart';

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

/// Constructs a task that resolves to a given value.
///
/// Example:
/// ```dart
/// Task<int> sampleTask = of(10);
/// ```
Task<B> of<B>(B value) {
  return Task<B>(() => Future.value(value));
}

/// Maps over a [Task] by applying the provided function [fn] to its result.
///
/// Given a function [fn] that transforms a value of type [A] to a value of type [B],
/// and a [Task] that will eventually produce a value of type [A],
/// this function returns a new [Task] that will eventually produce a value of type [B].
///
/// Example:
/// ```dart
/// Task<int> sampleTask = Task(() => Future.value(5));
/// Task<String> mappedTask = map<int, String>((int value) => 'Value is: $value')(sampleTask);
/// ```
Task<B> Function(Task<A> task) map<A, B>(B Function(A) fn) {
  return (Task<A> task) {
    return Task<B>(() async => fn(await task.task()));
  };
}

/// Flat-maps over a [Task] by applying the provided function [fn] to its result.
///
/// Given a function [fn] that takes a value of type [A] and returns a [Task] of type [B],
/// and a [Task] that will eventually produce a value of type [A],
/// this function returns a new [Task] that will eventually produce a value of type [B].
///
/// Example:
/// ```dart
/// Task<int> sampleTask = Task(() => Future.value(5));
/// Task<String> flatMappedTask = flatMap<int, String>((int value) => Task(() => Future.value('Value is: $value')))(sampleTask);
/// ```
Task<B> Function(Task<A> task) flatMap<A, B>(Task<B> Function(A) fn) =>
    (Task<A> task) =>
        Task<B>(() async => (await (fn(await task.task())).task()));

/// Alias for [flatMap].
///
/// Provides a way to handle an [Task] by chaining function calls.final chain = flatMap;
final chain = flatMap;

/// Applies the function inside a [Task] to the value inside another [Task].
///
/// Given a [Task] containing a function from [A] to [B] (`fTask`)
/// and another [Task] containing a value of type [A] (`m`),
/// this function returns a new [Task] that will eventually produce
/// a value of type [B] by applying the function to the value.
///
/// Example:
/// ```dart
/// Task<int Function(String)> funcTask = Task(() => Future.value((String s) => s.length));
/// Task<String> valueTask = Task(() => Future.value("Hello"));
/// Task<int> resultTask = ap(funcTask)(valueTask);
/// ```
Task<B> Function(Task<A> task) ap<A, B>(Task<B Function(A)> fTask) =>
    (Task<A> m) => Task<B>(() async => (await fTask.task())(await m.task()));

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
