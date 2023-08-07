import 'dart:async';

import 'package:functional_dart/task.dart';
import 'package:test/test.dart';

void main() {
  test('of should lift a value into a Task', () async {
    var value = 10;
    var task = of(value);

    expect(await task.task(), value);
  });
  group('Task map - ', () {
    test('should transform Task<int> to Task<String>', () async {
      var task = Task<int>(() => Future.value(10));
      var mappedTask = map(task, (a) => 'Number $a');

      expect(await mappedTask.task(), 'Number 10');
    });

    test('should transform Task<List<int>> to Task<int> (length of list)',
        () async {
      var task = Task<List<int>>(() => Future.value([1, 2, 3, 4, 5]));
      var mappedTask = map(task, (a) => a.length);

      expect(await mappedTask.task(), 5);
    });

    test('should handle exceptions and preserve them', () async {
      var task = Task<int>(() => Future.error(Exception('Test exception')));
      var mappedTask = map(task, (a) => 'Number $a');

      try {
        await mappedTask.task();
      } catch (e) {
        expect(e, isException);
      }
    });
  });
  group('Task flatMap - ', () {
    test('should transform Task<int> to Task<String>', () async {
      var task = Task<int>(() => Future.value(10));
      var flatMappedTask =
          flatMap(task, (a) => Task<String>(() => Future.value('Number $a')));

      expect(await flatMappedTask.task(), 'Number 10');
    });

    test('should transform Task<List<int>> to Task<int> (length of list)',
        () async {
      var task = Task<List<int>>((() => Future.value([1, 2, 3, 4, 5])));
      var flatMappedTask =
          flatMap(task, (a) => Task<int>(() => Future.value(a.length)));

      expect(await flatMappedTask.task(), 5);
    });

    test('should handle exceptions and preserve them', () async {
      var task = Task<int>(() => Future.error(Exception('Test exception')));
      var flatMappedTask =
          flatMap(task, (a) => Task<String>(() => Future.value('Number $a')));

      try {
        await flatMappedTask.task();
      } catch (e) {
        expect(e, isException);
      }
    });
  });
  group('Task ap - ', () {
    test('should apply Task<B Function(A)> to Task<A>', () async {
      var taskF = Task<int Function(String)>(
          () => Future.value((String a) => int.parse(a)));
      var task = Task<String>(() => Future.value("10"));
      var apTask = ap(taskF, task);

      expect(await apTask.task(), 10);
    });

    test('should handle exceptions and preserve them', () async {
      var taskF = Task<int Function(String)>(
          () => Future.error(Exception('Test exception')));
      var task = Task<String>(() => Future.value("10"));
      var apTask = ap(taskF, task);

      try {
        await apTask.task();
      } catch (e) {
        expect(e, isException);
      }
    });
  });
  test('fromTask should return the same Task', () async {
    var task = Task<int>(() => Future.value(10));
    var sameTask = fromTask(task);

    expect(await sameTask.task(), await task.task());
  });

  group('Task tap - ', () {
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
