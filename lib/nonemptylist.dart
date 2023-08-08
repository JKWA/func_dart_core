import 'dart:collection';
import 'package:func_dart_core/eq.dart';

/// Represents a non-empty list of items.
///
/// ```dart
/// var nel = NonEmptyList([1, 2, 3]);
/// print(nel.items);  // [1, 2, 3]
/// ```
class NonEmptyList<T> {
  final List<T> _items;

  /// Constructs a [NonEmptyList].
  ///
  /// Throws [ArgumentError] if the input [items] list is empty.
  ///
  /// ```dart
  /// var nel = NonEmptyList([1, 2, 3]);
  /// ```
  NonEmptyList(List<T> items)
      : _items = items.isNotEmpty
            ? List.unmodifiable(items)
            : throw ArgumentError('List must not be empty');

  /// Gets an unmodifiable view of the items in the list.
  UnmodifiableListView<T> get items => UnmodifiableListView(_items);
}

/// Checks whether the given [list] is not empty.
///
/// ```dart
/// print(isNonEmpty([1, 2, 3]));  // true
/// print(isNonEmpty([]));        // false
/// ```
bool isNonEmpty<T>(List<T> list) => list.isNotEmpty;

/// Prepends [item] to the provided [list] and returns a [NonEmptyList].
///
/// ```dart
/// var nel = prepend(0, [1, 2, 3]);
/// print(nel.items);  // [0, 1, 2, 3]
/// ```
NonEmptyList<T> prepend<T>(T item, List<T> list) {
  return NonEmptyList([item, ...list]);
}

/// Returns the first item of the [list].
///
/// ```dart
/// var nel = NonEmptyList([1, 2, 3]);
/// print(head(nel));  // 1
/// ```
T head<T>(NonEmptyList<T> list) {
  return list._items.first;
}

/// Returns all items from [list] except the first.
///
/// Throws [ArgumentError] if the list contains only one item.
///
/// ```dart
/// var nel = NonEmptyList([1, 2, 3]);
/// print(tail(nel));  // [2, 3]
/// ```
List<T> tail<T>(NonEmptyList<T> list) {
  if (list._items.length == 1) {
    throw ArgumentError('Tail of a single-element list is empty.');
  }
  return list._items.sublist(1);
}

/// Returns a new [NonEmptyList] with unique items based on the equality [eq].
///
/// ```dart
/// var eq = Eq<int>((a, b) => a == b);
/// var nel = NonEmptyList([1, 2, 2, 3, 3]);
/// print(unique(eq)(nel).items);  // [1, 2, 3]
/// ```
NonEmptyList<A> Function(NonEmptyList<A>) unique<A>(Eq<A> eq) =>
    (NonEmptyList<A> list) {
      final seen = <A>{};
      return NonEmptyList(list._items.where((item) {
        final isDuplicate = seen.any((seenItem) => eq.equals(item, seenItem));
        if (!isDuplicate) {
          seen.add(item);
        }
        return !isDuplicate;
      }).toList());
    };

/// Combines two [NonEmptyList]s while removing duplicates based on the equality [eq].
///
/// ```dart
/// var eq = Eq<int>((a, b) => a == b);
/// var nel1 = NonEmptyList([1, 2, 3]);
/// var nel2 = NonEmptyList([2, 3, 4]);
/// print(union(eq)(nel1)(nel2).items);  // [1, 2, 3, 4]
/// ```
NonEmptyList<A> Function(NonEmptyList<A>) Function(NonEmptyList<A>) union<A>(
        Eq<A> eq) =>
    (NonEmptyList<A> list1) => (NonEmptyList<A> list2) =>
        unique(eq)(NonEmptyList([...list1._items, ...list2._items]));

/// Returns a new [NonEmptyList] with reversed items.
///
/// ```dart
/// var nel = NonEmptyList([1, 2, 3]);
/// print(reverse(nel).items);  // [3, 2, 1]
/// ```
NonEmptyList<A> reverse<A>(NonEmptyList<A> list) =>
    NonEmptyList(list._items.reversed.toList());

/// Groups consecutive similar items based on the equality [eq].
///
/// ```dart
/// var eq = Eq<int>((a, b) => a == b);
/// var nel = NonEmptyList([1, 1, 2, 2, 3]);
/// var groups = group(eq)(nel);
/// print(groups.map((g) => g.items).toList());  // [[1, 1], [2, 2], [3]]
/// ```
List<NonEmptyList<A>> Function(NonEmptyList<A>) group<A>(Eq<A> eq) =>
    (NonEmptyList<A> list) {
      List<NonEmptyList<A>> result = [];
      List<A> currentGroup = [list._items.first];
      list._items.skip(1).forEach((item) {
        if (eq.equals(item, currentGroup.last)) {
          currentGroup.add(item);
        } else {
          result.add(NonEmptyList(currentGroup));
          currentGroup = [item];
        }
      });
      result.add(NonEmptyList(currentGroup));
      return result;
    };

/// Groups items by a derived key, as determined by the [keyFunc].
///
/// ```dart
/// var nel = NonEmptyList(["one", "two", "three"]);
/// var grouped = groupBy<String, int>((s) => s.length)(nel);
/// print(grouped[3]!.items);  // ["one", "two"]
/// ```
Map<K, NonEmptyList<A>> Function(NonEmptyList<A>) groupBy<A, K>(
        K Function(A) keyFunc) =>
    (NonEmptyList<A> list) {
      Map<K, List<A>> tempMap = SplayTreeMap();
      for (var item in list._items) {
        final key = keyFunc(item);
        tempMap[key] ??= [];
        tempMap[key]!.add(item);
      }
      return tempMap.map((key, items) => MapEntry(key, NonEmptyList(items)));
    };

/// Maps over the items of the [NonEmptyList] using function [f].
///
/// ```dart
/// var nel = NonEmptyList([1, 2, 3]);
/// print(map<int, String>((i) => i.toString())(nel).items);  // ["1", "2", "3"]
/// ```
NonEmptyList<B> Function(NonEmptyList<A>) map<A, B>(B Function(A) f) =>
    (NonEmptyList<A> list) => NonEmptyList(list._items.map(f).toList());

/// Maps over the items of the [NonEmptyList] using function [f], then flattens the result.
///
/// ```dart
/// var nel = NonEmptyList([1, 2, 3]);
/// print(flatMap<int, int>((i) => NonEmptyList([i, i * 10]))(nel).items);  // [1, 10, 2, 20, 3, 30]
/// ```
NonEmptyList<B> Function(NonEmptyList<A>) flatMap<A, B>(
        NonEmptyList<B> Function(A) f) =>
    (NonEmptyList<A> list) =>
        NonEmptyList(list._items.expand((item) => f(item)._items).toList());

/// Applies each function in the [fns] [NonEmptyList] to each item in the [List].
///
/// ```dart
/// var nel = NonEmptyList([1, 2, 3]);
/// var fns = NonEmptyList([(int i) => i + 1, (int i) => i * 2]);
/// print(ap<int, int>(fns)(nel).items);  // [2, 3, 4, 2, 4, 6]
/// ```
NonEmptyList<B> Function(NonEmptyList<A>) ap<A, B>(
        NonEmptyList<B Function(A)> fns) =>
    (NonEmptyList<A> list) =>
        NonEmptyList(fns._items.expand((fn) => list._items.map(fn)).toList());
