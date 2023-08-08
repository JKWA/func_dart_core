import 'dart:collection';
import 'package:func_dart_core/eq.dart';

/// A list that is guaranteed to have at least one item.
///
/// This is a wrapper around a standard Dart list that ensures it's never empty.
/// It also provides an unmodifiable view to ensure that no empty lists are set.
///
/// Example:
/// ```
/// final myList = NonEmptyList([1, 2, 3]);
/// print(myList.first); // prints 1
/// ```
class NonEmptyList<T> implements Iterable<T> {
  final List<T> _items;

  /// Constructs a [NonEmptyList].
  ///
  /// Throws an [ArgumentError] if the provided list is empty.
  NonEmptyList(List<T> items)
      : _items = items.isNotEmpty
            ? List.unmodifiable(items)
            : throw ArgumentError('List must not be empty');

  /// Provides an unmodifiable view of the items.
  UnmodifiableListView<T> get items => UnmodifiableListView(_items);

  @override
  Iterator<T> get iterator => _items.iterator;

  /// Checks if any item in the list satisfies the provided test.
  @override
  bool any(bool Function(T) test) => _items.any(test);

  /// Casts the items of the list to the desired type [R].
  @override
  Iterable<R> cast<R>() => _items.cast<R>();

  /// Determines if the list contains the provided element.
  @override
  bool contains(Object? element) => _items.contains(element);

  /// Returns the element at the specified index.
  @override
  T elementAt(int index) => _items.elementAt(index);

  /// Checks if every item in the list satisfies the provided test.
  @override
  bool every(bool Function(T) test) => _items.every(test);

  /// Expands each element into zero or more elements.
  @override
  Iterable<T0> expand<T0>(Iterable<T0> Function(T) f) => _items.expand(f);

  /// Gets the first element in the list.
  @override
  T get first => _items.first;

  /// Gets the first element that satisfies the given predicate [test]. If none
  /// are found, it calls the [orElse] function if provided.
  @override
  T firstWhere(bool Function(T) test, {T Function()? orElse}) =>
      _items.firstWhere(test, orElse: orElse);

  /// Accumulates value starting with [initialValue] and applying [combine] for
  /// each element in order.
  @override
  T0 fold<T0>(T0 initialValue, T0 Function(T0, T) combine) =>
      _items.fold(initialValue, combine);

  /// Appends all elements of [other] to the end of this iterable's elements.
  @override
  Iterable<T> followedBy(Iterable<T> other) => _items.followedBy(other);

  /// Applies the function [f] to each element of this collection.
  @override
  void forEach(void Function(T) f) => _items.forEach(f);

  /// Returns true if there are no elements in this collection.
  @override
  bool get isEmpty => _items.isEmpty;

  /// Returns true if there is at least one element in this collection.
  @override
  bool get isNotEmpty => _items.isNotEmpty;

  /// Converts the items in the list to a string and concatenates them using the
  /// provided [separator].
  @override
  String join([String separator = ""]) => _items.join(separator);

  /// Gets the last element in the list.
  @override
  T get last => _items.last;

  /// Gets the last element that satisfies the given predicate [test]. If none
  /// are found, it calls the [orElse] function if provided.
  @override
  T lastWhere(bool Function(T) test, {T Function()? orElse}) =>
      _items.lastWhere(test, orElse: orElse);

  /// Applies the function [f] to each element in the list and returns a new
  /// iterable with elements of type [T0].
  @override
  Iterable<T0> map<T0>(T0 Function(T) f) => _items.map(f);

  /// Reduces the elements in the list to a single value using the [combine]
  /// function.
  @override
  T reduce(T Function(T, T) combine) => _items.reduce(combine);

  /// Gets the single element in the list. Throws an error if the list has more
  /// than one item.
  @override
  T get single => _items.single;

  /// Gets the single element that satisfies the given predicate [test]. If none
  /// are found, it calls the [orElse] function if provided.
  @override
  T singleWhere(bool Function(T) test, {T Function()? orElse}) =>
      _items.singleWhere(test, orElse: orElse);

  /// Skips the first [count] elements.
  @override
  Iterable<T> skip(int count) => _items.skip(count);

  /// Skips leading elements while they satisfy [test].
  @override
  Iterable<T> skipWhile(bool Function(T) test) => _items.skipWhile(test);

  /// Returns the first [count] elements.
  @override
  Iterable<T> take(int count) => _items.take(count);

  /// Returns leading elements satisfying [test].
  @override
  Iterable<T> takeWhile(bool Function(T) test) => _items.takeWhile(test);

  /// Returns a list representation of the iterable.
  @override
  List<T> toList({bool growable = true}) => _items.toList(growable: growable);

  /// Returns a set containing the same elements as this iterable.
  @override
  Set<T> toSet() => _items.toSet();

  /// Returns a new lazy [Iterable] with all elements that satisfy the predicate [test].
  @override
  Iterable<T> where(bool Function(T) test) => _items.where(test);

  /// Returns a new lazy [Iterable] with all elements that have type [T0].
  @override
  Iterable<T0> whereType<T0>() => _items.whereType<T0>();

  /// Gets the number of elements in this list.
  @override
  int get length => _items.length;

  @override
  String toString() {
    return _items.toString();
  }
}

/// Checks whether the given [list] is not empty.
///
/// ```dart
/// print(isNonEmpty([1, 2, 3]));  // true
/// print(isNonEmpty([]));        // false
/// ```
bool isNonEmpty<T>(List<T> list) => list.isNotEmpty;

/// Appends an item to the end of a [NonEmptyList].
///
/// Takes a [NonEmptyList] and returns a new [NonEmptyList] with the given
/// item added to the end.
///
/// Example:
/// ```dart
/// final list = NonEmptyList<int>([1, 2, 3]);
/// final appended = append(4)(list);
/// print(appended.items);  // Outputs: [1, 2, 3, 4]
/// ```
NonEmptyList<T> Function(NonEmptyList<T>) append<T>(T item) =>
    (NonEmptyList<T> list) => NonEmptyList([...list.items, item]);

/// Prepends an item to the beginning of a [NonEmptyList].
///
/// Takes a [NonEmptyList] and returns a new [NonEmptyList] with the given
/// item added to the beginning.
///
/// Example:
/// ```dart
/// final list = NonEmptyList<int>([2, 3, 4]);
/// final prepended = prepend(1)(list);
/// print(prepended.items);  // Outputs: [1, 2, 3, 4]
/// ```
NonEmptyList<T> Function(NonEmptyList<T>) prepend<T>(T item) =>
    (NonEmptyList<T> list) => NonEmptyList([item, ...list.items]);

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
