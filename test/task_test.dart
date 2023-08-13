import 'dart:async';

import 'package:func_dart_core/task.dart';
import 'package:test/test.dart';

void main() {
  test('of should lift a value into a Task', () async {
    var value = 10;
    var task = of(value);

    expect(await task.task(), value);
  });
  group('map', () {
    test('should transform task result from int to string', () async {
      final addOne = map<int, String>((x) => (x + 1).toString());

      final task = Task(() async => 5);
      final transformedTask = addOne(task);

      final result = await transformedTask.task();
      expect(result, '6');
    });

    test('should transform task result from double to int', () async {
      final halfToInt = map<double, int>((x) => x.toInt());

      final task = Task(() async => 3.5);
      final transformedTask = halfToInt(task);

      final result = await transformedTask.task();
      expect(result, 3);
    });

    test('should transform task result from string to uppercase', () async {
      final uppercase = map<String, String>((s) => s.toUpperCase());

      final task = Task(() async => 'hello');
      final transformedTask = uppercase(task);

      final result = await transformedTask.task();
      expect(result, 'HELLO');
    });
  });

  group('flatMap', () {
    test('should flatMap task result from int to string task', () async {
      final stringify = flatMap<int, String>((x) {
        final stringValue = x.toString();
        return Task(() async => stringValue);
      });

      final task = Task(() async => 5);
      final flatMappedTask = stringify(task);

      final result = await flatMappedTask.task();
      expect(result, '5');
    });

    test('should flatMap task result from int to double task', () async {
      final doubleValue = flatMap<int, double>((x) {
        final doubleValue = x.toDouble();
        return Task(() async => doubleValue);
      });

      final task = Task(() async => 10);
      final flatMappedTask = doubleValue(task);

      final result = await flatMappedTask.task();
      expect(result, 10.0);
    });

    test('should flatMap task result from string to length task', () async {
      final lengthTask = flatMap<String, int>((s) {
        return Task(() async => s.length);
      });

      final task = Task(() async => 'hello');
      final flatMappedTask = lengthTask(task);

      final result = await flatMappedTask.task();
      expect(result, 5);
    });
  });

  group('ap - ', () {
    test('should apply function wrapped in Task to value wrapped in Task',
        () async {
      final taskFunction = Task<int Function(int)>(
          () async => (int x) => x + 5); // Task wrapping a function that adds 5
      final taskValue = Task<int>(() async => 10); // Task wrapping a value 10
      final resultTask = ap(taskFunction)(taskValue);
      expect(await resultTask.task(), 15);
    });

    test('identity function should not modify the task', () async {
      final taskFunction = Task<int Function(int)>(
          () async => (int x) => x); // Task wrapping identity function
      final taskValue = Task<int>(() async => 10); // Task wrapping a value 10
      final resultTask = ap(taskFunction)(taskValue);
      expect(await resultTask.task(), 10);
    });

    test('should handle async delays', () async {
      final taskFunction = Task<int Function(int)>(() async {
        await Future.delayed(
            Duration(milliseconds: 50), () => (int x) => x * 2);
        return (int x) => x * 2;
      });
      final taskValue = Task<int>(() async => 20);
      final resultTask = ap(taskFunction)(taskValue);
      expect(await resultTask.task(), 40);
    });
  });

  test('ap with async failures', () async {
    final taskFunction = Task<int Function(int)>(() async {
      await Future<void>.delayed(Duration(milliseconds: 50));
      return (int x) => x * 2;
    });
    final taskValue = Task<int>(() async {
      throw Exception('Sample error');
    });
    final resultTask = ap(taskFunction)(taskValue);
    expect(resultTask.task(), throwsA(isA<Exception>()));
  });

  test('fromTask should return the same Task', () async {
    var task = Task<int>(() => Future.value(10));
    var sameTask = fromTask(task);

    expect(await sameTask.task(), await task.task());
  });

  group('tap - ', () {
    test('tap should create a side effect without changing the Task', () async {
      var value = 10;
      var task = Task<int>(() => Future.value(value));
      var sideEffect = 0;

      var tappedTask = tap<int>((value) => sideEffect = value)(task);
      expect(await tappedTask.task(), value);
      expect(sideEffect, value);
    });

    test('tap should not affect Task if side effect throws', () async {
      var value = 10;
      var task = Task<int>(() => Future.value(value));

      var tappedTask = tap<int>((value) {
        throw Exception('Side effect exception');
      })(task);

      expect(await tappedTask.task(), value);
    });
  });
}
