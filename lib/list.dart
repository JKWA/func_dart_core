import 'dart:collection';
import 'package:collection/collection.dart';

import 'package:func_dart_core/either.dart' as either;
import 'package:func_dart_core/eq.dart';
import 'package:func_dart_core/function.dart';
import 'package:func_dart_core/option.dart' as option;
import 'package:func_dart_core/predicate.dart';

/// A list that cannot be modified after it's created.
///
/// This is a wrapper around a standard Dart list that provides an unmodifiable
/// view of the original list. This ensures that the underlying list cannot
/// be changed once the [ImmutableList] object has been constructed.
///
/// Example:
/// ```
/// final immutableList = ImmutableList([1, 2, 3]);
/// print(immutableList.first); // prints 1
/// ```
class ImmutableList<T> implements Iterable<T> {
  final List<T> _items;

  /// Constructs an [ImmutableList].
  ImmutableList(List<T> items) : _items = List.unmodifiable(items);

  /// Provides an unmodifiable view of the items.
  UnmodifiableListView<T> get items => UnmodifiableListView(_items);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImmutableList<T>) return false;
    final listEquality = ListEquality<T>();
    return listEquality.equals(items, (other).items);
  }

  @override
  int get hashCode => ListEquality<T>().hash(items);

  @override
  Iterator<T> get iterator => _items.iterator;

  /// Returns the number of items in the list.
  @override
  int get length => _items.length;

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

  /// Skips while elements satisfy the given predicate [test].
  @override
  Iterable<T> skipWhile(bool Function(T) test) => _items.skipWhile(test);

  /// Takes the first [count] elements.
  @override
  Iterable<T> take(int count) => _items.take(count);

  /// Takes while elements satisfy the given predicate [test].
  @override
  Iterable<T> takeWhile(bool Function(T) test) => _items.takeWhile(test);

  /// Returns a list representation of the iterable.
  @override
  List<T> toList({bool growable = true}) => _items.toList(growable: growable);

  /// Returns a set representation of the iterable.
  @override
  Set<T> toSet() => _items.toSet();

  /// Filters the elements in the list based on the predicate [test].
  @override
  Iterable<T> where(bool Function(T) test) => _items.where(test);

  /// Returns an iterable of objects of type [T], where [T] is a subtype of [T].
  @override
  Iterable<T1> whereType<T1>() => _items.whereType<T1>();

  /// Returns a string representation of the list.
  @override
  String toString() {
    return toList().toString();
  }
}

/// Returns a function that appends [item] to the end of an [ImmutableList].
///
/// Example:
/// ```dart
/// final list = ImmutableList<int>([1, 2]);
/// final appended = append(3)(list);
/// print(appended.items);  // Outputs: (1, 2, 3)
/// ```
ImmutableList<T> Function(ImmutableList<T>) append<T>(T item) =>
    (ImmutableList<T> list) => ImmutableList([...list.items, item]);

/// Returns a function that prepends [item] to the beginning of an [ImmutableList].
///
/// Example:
/// ```dart
/// final list = ImmutableList<int>([2, 3]);
/// final prepended = prepend(1)(list);
/// print(prepended.items);  // Outputs: (1, 2, 3)
/// ```
ImmutableList<T> Function(ImmutableList<T>) prepend<T>(T item) =>
    (ImmutableList<T> list) => ImmutableList([item, ...list.items]);

/// Creates an [ImmutableList] by filtering out duplicate items using the [eq] comparator.
///
/// Example:
/// ```dart
/// final list = ImmutableList<int>([1, 2, 2, 3, 3]);
/// final uniqueList = unique(Eq.fromDefault<int>())(list);
/// print(uniqueList.items);  // Outputs: (1, 2, 3)
/// ```
ImmutableList<A> Function(ImmutableList<A>) unique<A>(Eq<A> eq) =>
    (ImmutableList<A> list) {
      final seen = <A>{};
      return ImmutableList(list._items.where((item) {
        final isDuplicate = seen.any((seenItem) => eq.equals(item, seenItem));
        if (!isDuplicate) {
          seen.add(item);
        }
        return !isDuplicate;
      }).toList());
    };

/// Returns a function that combines two [ImmutableList]s into a single list without duplicates.
///
/// Example:
/// ```dart
/// final list1 = ImmutableList<int>([1, 2]);
/// final list2 = ImmutableList<int>([2, 3]);
/// final unionList = union(Eq.fromDefault<int>())(list1)(list2);
/// print(unionList.items);  // Outputs: (1, 2, 3)
/// ```
ImmutableList<A> Function(ImmutableList<A>) Function(ImmutableList<A>) union<A>(
        Eq<A> eq) =>
    (ImmutableList<A> list1) => (ImmutableList<A> list2) =>
        unique(eq)(ImmutableList([...list1._items, ...list2._items]));

/// Reverses the order of items in an [ImmutableList].
///
/// Example:
/// ```dart
/// final list = ImmutableList<int>([1, 2, 3]);
/// final reversed = reverse(list);
/// print(reversed.items);  // Outputs: (3, 2, 1)
/// ```
ImmutableList<A> reverse<A>(ImmutableList<A> list) =>
    ImmutableList(list._items.reversed.toList());

/// Groups consecutive duplicate items in an [ImmutableList] using the [eq] comparator.
///
/// Example:
/// ```dart
/// final list = ImmutableList<int>([1, 2, 2, 3, 3]);
/// final groups = group(Eq.fromDefault<int>())(list);
/// print(groups.map((group) => group.items));
/// // Outputs: [(1), (2, 2), (3, 3)]
/// ```
List<ImmutableList<A>> Function(ImmutableList<A>) group<A>(Eq<A> eq) =>
    (ImmutableList<A> list) {
      List<ImmutableList<A>> result = [];
      if (list._items.isEmpty) return result;
      List<A> currentGroup = [list._items.first];
      list._items.skip(1).forEach((item) {
        if (eq.equals(item, currentGroup.last)) {
          currentGroup.add(item);
        } else {
          result.add(ImmutableList(currentGroup));
          currentGroup = [item];
        }
      });
      result.add(ImmutableList(currentGroup));
      return result;
    };

/// Groups items in an [ImmutableList] by a key produced by the [keyFunc] function.
///
/// Example:
/// ```dart
/// final list = ImmutableList<String>(["apple", "banana", "avocado"]);
/// final grouped = groupBy<String, int>((fruit) => fruit.length)(list);
/// print(grouped);  // Outputs: {5: [apple], 6: [banana, avocado]}
/// ```
Map<K, ImmutableList<A>> Function(ImmutableList<A>) groupBy<A, K>(
        K Function(A) keyFunc) =>
    (ImmutableList<A> list) {
      Map<K, List<A>> tempMap = SplayTreeMap();
      for (var item in list._items) {
        final key = keyFunc(item);
        tempMap[key] ??= [];
        tempMap[key]!.add(item);
      }
      return tempMap.map((key, items) => MapEntry(key, ImmutableList(items)));
    };

/// Returns a function that takes an `ImmutableList<A>` and maps each item
/// in the list using the provided function [f] to produce a new `ImmutableList<B>`.
///
/// This operation does not modify the original list but instead produces
/// a new list with items of a potentially different type.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var mapToDouble = map<int, double>((item) => item * 2.5);
/// var newList = mapToDouble(myList); // Returns ImmutableList([2.5, 5.0, 7.5, 10.0, 12.5])
/// ```
///
/// - Parameter [f]: The mapping function that takes an item of type `A`
///   and returns a new item of type `B`.
/// - Returns: A function that processes an `ImmutableList<A>` and produces
///   a new `ImmutableList<B>` with mapped items.
ImmutableList<B> Function(ImmutableList<A>) map<A, B>(B Function(A) f) =>
    (ImmutableList<A> list) => ImmutableList(list._items.map(f).toList());

/// Returns a function that takes an `ImmutableList<A>` and maps each item
/// in the list using the provided function [f] to produce a new `ImmutableList<B>`.
///
/// Unlike the regular `map` function, `flatMap` expects the mapping function [f]
/// to return an `ImmutableList<B>` for each item in the original list, and
/// it will flatten the resulting lists into a single `ImmutableList<B>`.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3]);
/// var flatMapToLists = flatMap<int, int>((item) => ImmutableList([item, item + 10]));
/// var newList = flatMapToLists(myList); // Returns ImmutableList([1, 11, 2, 12, 3, 13])
/// ```
///
/// - Parameter [f]: The mapping function that takes an item of type `A`
///   and returns an `ImmutableList<B>`.
/// - Returns: A function that processes an `ImmutableList<A>` and produces
///   a new `ImmutableList<B>` with mapped and flattened items.
ImmutableList<B> Function(ImmutableList<A>) flatMap<A, B>(
        ImmutableList<B> Function(A) f) =>
    (ImmutableList<A> list) =>
        ImmutableList(list._items.expand((item) => f(item)._items).toList());

/// Applies a list of functions from [fns] to each item in the [ImmutableList].
///
/// Example:
/// ```dart
/// final list = ImmutableList<int>([10, 20]);
/// final functions = ImmutableList<Function>([(int x) => x + 1, (int x) => x - 1]);
/// final applied = ap(functions)(list);
/// print(applied.items);  // Outputs: (11, 21, 9, 19)
/// ```
ImmutableList<B> Function(ImmutableList<A>) ap<A, B>(
        ImmutableList<B Function(A)> fns) =>
    (ImmutableList<A> list) =>
        ImmutableList(fns._items.expand((fn) => list._items.map(fn)).toList());

/// Computes the difference between two [ImmutableList]s.
///
/// Example:
/// ```dart
/// final list1 = ImmutableList<int>([1, 2, 3]);
/// final list2 = ImmutableList<int>([3, 4, 5]);
/// final differenceList = difference(Eq.fromDefault<int>())(list1)(list2);
/// print(differenceList.items);  // Outputs: (1, 2)
/// ```
ImmutableList<A> Function(ImmutableList<A>) Function(ImmutableList<A>)
    difference<A>(Eq<A> eq) {
  return (ImmutableList<A> list1) {
    return (ImmutableList<A> list2) {
      final itemsInList2 = list2.items.toSet();
      return ImmutableList(list1.items
          .where(
              (item1) => !itemsInList2.any((item2) => eq.equals(item1, item2)))
          .toList());
    };
  };
}

/// Returns a function that computes the symmetric difference between two `ImmutableList`s.
///
/// Given two lists, `list1` and `list2`, it returns a new list containing
/// the elements that are in either `list1` or `list2` but not both, based on the provided equality comparison.
///
/// Example:
///
/// ```dart
/// final eqInt = EqInt();
/// final differ = symmetricDifference(eqInt);
/// final list1 = ImmutableList([1, 2, 3, 4]);
/// final list2 = ImmutableList([3, 4, 5, 6]);
/// final result = differ(list1)(list2);
/// print(result);  // [1, 2, 5, 6]
/// ```
ImmutableList<A> Function(ImmutableList<A>) Function(ImmutableList<A>)
    symmetricDifference<A>(Eq<A> eq) {
  final diff = difference(eq);
  return (ImmutableList<A> list1) {
    return (ImmutableList<A> list2) {
      final diff1to2 = diff(list1)(list2).items;
      final diff2to1 = diff(list2)(list1).items;
      return ImmutableList([...diff1to2, ...diff2to1]);
    };
  };
}

/// Returns a function that computes the intersection between two `ImmutableList`s.
///
/// Given two lists, `list1` and `list2`, it returns a new list containing
/// only the elements that exist in both lists based on the provided equality comparison.
///
/// Example:
///
/// ```dart
/// final eqInt = EqInt();
/// final intersector = intersection(eqInt);
/// final list1 = ImmutableList([1, 2, 3, 4]);
/// final list2 = ImmutableList([3, 4, 5, 6]);
/// final result = intersector(list1)(list2);
/// print(result);  // [3, 4]
/// ```
ImmutableList<A> Function(ImmutableList<A>) Function(ImmutableList<A>)
    intersection<A>(Eq<A> eq) {
  return (ImmutableList<A> list1) {
    return (ImmutableList<A> list2) {
      final itemsInList2 = list2.items.toSet();
      return ImmutableList(list1.items
          .where(
              (item1) => itemsInList2.any((item2) => eq.equals(item1, item2)))
          .toList());
    };
  };
}

/// Folds a list from the left with a binary operation.
///
/// Example:
/// ```dart
/// final list = ImmutableList<int>([1, 2, 3]);
/// final sum = foldLeft<int, int>(0)((acc, item) => acc + item)(list);
/// print(sum);  // Outputs: 6
/// ```
B Function(ImmutableList<T>) Function(B Function(B, T)) foldLeft<T, B>(
    B empty) {
  return (B Function(B, T) concat) {
    return (ImmutableList<T> list) {
      return list.items.fold(empty, concat);
    };
  };
}

/// An alias for the `foldLeft` function.
///
/// `reduceLeft` serves the same purpose and functionality as `foldLeft`.
/// In some programming contexts or traditions, "reduce" might be more familiar
/// or intuitive than "fold". By providing an alias, users can use the term they are
/// more comfortable with.
///
/// Usage:
/// ```dart
/// var result = reduceLeft(myList, initialValue, myFunction);
/// ```
///
/// Note: Ensure that the functionality and behavior of `foldLeft` is
/// well-documented since `reduceLeft` is directly referencing it.
const reduceLeft = foldLeft;

/// Folds a list from the right with a binary operation.
///
/// Example:
/// ```dart
/// final list = ImmutableList<int>([1, 2, 3]);
/// final product = foldRight<int, int>(1)((item, acc) => item * acc)(list);
/// print(product);  // Outputs: 6
/// ```
B Function(ImmutableList<T>) Function(B Function(B, T)) foldRight<T, B>(
    B empty) {
  return (B Function(B, T) concat) {
    return (ImmutableList<T> list) {
      return list.items.reversed.fold(empty, concat);
    };
  };
}

/// An alias for the `foldRight` function.
///
/// `reduceRight` serves the same purpose and functionality as `foldRight`.
/// As with `reduceLeft`, in certain programming contexts or traditions,
/// "reduce" might be more commonly used or understood than "fold". By
/// providing this alias, users can select the terminology they prefer.
///
/// Usage:
/// ```dart
/// var result = reduceRight(myList, initialValue, myFunction);
/// ```
///
/// Note: It's crucial that the functionality and behavior of `foldRight` is
/// comprehensively documented since `reduceRight` directly references it.
const reduceRight = foldRight;

/// Scans a list from the left, producing a new list with intermediate results.
///
/// Example:
/// ```dart
/// final list = ImmutableList<int>([1, 2, 3]);
/// final scanResult = scanLeft<int, int>(0)((acc, item) => acc + item)(list);
/// print(scanResult.items);  // Outputs: (0, 1, 3, 6)
/// ```
ImmutableList<B> Function(ImmutableList<T>) Function(B Function(B, T) combine)
    scanLeft<T, B>(B initial) {
  return (B Function(B, T) combine) {
    return (ImmutableList<T> list) {
      List<B> results = [initial];
      B accumulator = initial;

      for (T item in list.items) {
        accumulator = combine(accumulator, item);
        results.add(accumulator);
      }

      return ImmutableList(results);
    };
  };
}

/// Scans a list from the right, producing a new list with intermediate results.
///
/// Example:
/// ```dart
/// final list = ImmutableList<int>([1, 2, 3]);
/// final scanResult = scanRight<int, int>(0)((item, acc) => item + acc)(list);
/// print(scanResult.items);  // Outputs: (6, 5, 3, 0)
/// ```
ImmutableList<B> Function(ImmutableList<T>) Function(B Function(B, T) combine)
    scanRight<T, B>(B initial) {
  return (B Function(B, T) combine) {
    return (ImmutableList<T> list) {
      List<B> results = [initial];
      B accumulator = initial;

      for (T item in list.items.reversed) {
        accumulator = combine(accumulator, item);
        results.add(accumulator);
      }

      return ImmutableList(results.reversed.toList());
    };
  };
}

/// Concatenates two [ImmutableList] instances.
///
/// Takes two [ImmutableList] instances and returns a new [ImmutableList]
/// containing elements from both lists: elements of the first list followed by elements of the second list.
///
/// Example:
/// ```dart
/// final listA = NonEmptyList<int>([1, 2, 3]);
/// final listB = NonEmptyList<int>([4, 5, 6]);
/// final concatenated = concat(listA)(listB);
/// print(concatenated.items);  // Outputs: [1, 2, 3, 4, 5, 6]
/// ```
ImmutableList<T> Function(ImmutableList<T>) concat<T>(ImmutableList<T> first) =>
    (ImmutableList<T> second) =>
        ImmutableList([...first.items, ...second.items]);

/// Returns the size of the [ImmutableList].
///
/// Takes an [ImmutableList] instance and returns its length.
///
/// Example:
/// ```dart
/// final il = ImmutableList<int>([1, 2, 3, 4]);
/// final length = size(il);
/// print(length);  // Outputs: 4
/// ```
int size<T>(ImmutableList<T> list) => list.items.length;

/// Checks if the given [index] is out of bounds for the provided [list].
///
/// Determines whether the specified [index] is less than zero or greater
/// than or equal to the length of the [list]. This is useful for validating
/// index values before attempting to access or modify list items.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var isIndexOutOfBounds = isOutOfBounds(6, myList);  // Returns true
/// ```
///
/// - Parameters:
///   - [index]: The index value to check.
///   - [list]: The `ImmutableList<T>` against which the index will be checked.
/// - Returns: `true` if the index is out of bounds, otherwise `false`.
bool isOutOfBounds<T>(int index, ImmutableList<T> list) {
  return index < 0 || index >= list.items.length;
}

/// Returns a function that takes an `ImmutableList<T>` and returns
/// a new `ImmutableList<T>` containing only the first [n] elements.
///
/// The returned function can be used to process lists and take the
/// first [n] elements from them.
///
/// If [n] is out of bounds (less than 0 or greater than the length
/// of the list), the returned function will return the original list.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var takeTwo = takeLeft<int>(2);
/// var newList = takeTwo(myList); // Returns ImmutableList([1, 2])
/// ```
///
/// - Parameter [n]: The number of elements to take from the left.
/// - Returns: A function that processes an `ImmutableList<T>` and returns
///   an `ImmutableList<T>` containing only the first [n] elements.
ImmutableList<T> Function(ImmutableList<T>) takeLeft<T>(int n) =>
    (ImmutableList<T> list) => isOutOfBounds(n, list)
        ? list
        : ImmutableList(list.items.take(n).toList());

/// Returns a function that takes an `ImmutableList<T>` and returns
/// a new `ImmutableList<T>` containing only the last [n] elements.
///
/// The returned function can be used to process lists and take the
/// last [n] elements from them.
///
/// If [n] is out of bounds (less than 0 or greater than the length
/// of the list), the returned function will return the original list.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var takeLastTwo = takeRight<int>(2);
/// var newList = takeLastTwo(myList); // Returns ImmutableList([4, 5])
/// ```
///
/// - Parameter [n]: The number of elements to take from the right.
/// - Returns: A function that processes an `ImmutableList<T>` and returns
///   an `ImmutableList<T>` containing only the last [n] elements.
ImmutableList<T> Function(ImmutableList<T>) takeRight<T>(int n) =>
    (ImmutableList<T> list) => isOutOfBounds(n, list)
        ? list
        : ImmutableList(list.items.skip(list.items.length - n).toList());

/// Returns a function that takes an `ImmutableList<T>` and returns a new
/// `ImmutableList<T>` containing elements from the start of the list
/// as long as they satisfy the given [predicate].
///
/// The returned function can be used to process lists and take elements
/// from the start as long as they match the given condition.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var takeWhileLessThanFour = takeLeftWhile<int>((item) => item < 4);
/// var newList = takeWhileLessThanFour(myList); // Returns ImmutableList([1, 2, 3])
/// ```
///
/// - Parameter [predicate]: The condition used to test each element.
/// - Returns: A function that processes an `ImmutableList<T>` and returns
///   an `ImmutableList<T>` containing elements from the start as long as
///   they satisfy the given predicate.
ImmutableList<T> Function(ImmutableList<T>) takeLeftWhile<T>(
        Predicate<T> predicate) =>
    (ImmutableList<T> list) =>
        ImmutableList(list.items.takeWhile(predicate).toList());

/// Returns a function that takes an `ImmutableList<T>` and returns a new
/// `ImmutableList<T>` containing elements from the end of the list as long
/// as they satisfy the given [predicate].
///
/// The returned function can be used to process lists and take elements
/// from the end as long as they match the given condition.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var takeRightWhileGreaterThanThree = takeRightWhile<int>((item) => item > 3);
/// var newList = takeRightWhileGreaterThanThree(myList); // Returns ImmutableList([4, 5])
/// ```
///
/// - Parameter [predicate]: The condition used to test each element.
/// - Returns: A function that processes an `ImmutableList<T>` and returns
///   an `ImmutableList<T>` containing elements from the end as long as
///   they satisfy the given predicate.
ImmutableList<T> Function(ImmutableList<T>) takeRightWhile<T>(
    Predicate<T> predicate) {
  return (ImmutableList<T> list) => ImmutableList(list.items
      .sublist(list.items.lastIndexWhere((item) => !predicate(item)) + 1));
}

/// Returns a function that takes an `ImmutableList<T>` and returns a new
/// `ImmutableList<T>` with the first [count] elements removed.
///
/// If [count] is greater than or equal to the length of the list,
/// an empty `ImmutableList<T>` will be returned.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var dropFirstTwo = dropLeft<int>(2);
/// var newList = dropFirstTwo(myList); // Returns ImmutableList([3, 4, 5])
/// ```
///
/// - Parameter [count]: The number of elements to drop from the left.
/// - Returns: A function that processes an `ImmutableList<T>` and returns
///   an `ImmutableList<T>` with the first [count] elements removed.
ImmutableList<T> Function(ImmutableList<T>) dropLeft<T>(int count) {
  return (ImmutableList<T> list) {
    if (count >= list.items.length) return ImmutableList<T>([]);
    return ImmutableList(list.items.sublist(count));
  };
}

/// Returns a function that takes an `ImmutableList<T>` and returns a new
/// `ImmutableList<T>` with the last [count] elements removed.
///
/// If [count] is greater than or equal to the length of the list,
/// an empty `ImmutableList<T>` will be returned.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var dropLastTwo = dropRight<int>(2);
/// var newList = dropLastTwo(myList); // Returns ImmutableList([1, 2, 3])
/// ```
///
/// - Parameter [count]: The number of elements to drop from the right.
/// - Returns: A function that processes an `ImmutableList<T>` and returns
///   an `ImmutableList<T>` with the last [count] elements removed.
ImmutableList<T> Function(ImmutableList<T>) dropRight<T>(int count) {
  return (ImmutableList<T> list) {
    if (count >= list.items.length) return ImmutableList<T>([]);
    return ImmutableList(list.items.sublist(0, list.items.length - count));
  };
}

/// Returns a function that takes an `ImmutableList<T>` and searches
/// for the index of the first element that satisfies the given [predicate].
///
/// If an element is found that satisfies the [predicate], the index of
/// that element is returned wrapped in an `Option<int>`.
/// If no element is found, `None<int>()` is returned.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var findIndexOfFirstEven = findIndex<int>((item) => item % 2 == 0);
/// var indexOption = findIndexOfFirstEven(myList); // Returns option containing index 1
/// ```
///
/// - Parameter [predicate]: The condition used to test each element.
/// - Returns: A function that processes an `ImmutableList<T>` and returns
///   an `Option<int>` containing the index of the first element that
///   satisfies the given predicate, or `None<int>()` if no such element is found.
option.Option<int> Function(ImmutableList<T>) findIndex<T>(
    Predicate<T> predicate) {
  return (ImmutableList<T> list) {
    final index = list.items.indexWhere(predicate);
    return index != -1 ? option.of(index) : option.None<int>();
  };
}

/// Returns a function that searches for the first element in the
/// given [list] that satisfies the provided [Predicate].
///
/// If an element is found that satisfies the [Predicate], that element
/// is returned wrapped in an `Option<T>`. If no element is found,
/// `None<T>()` is returned.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var findFirstEven = findFirst<int>(myList);
/// var itemOption = findFirstEven((item) => item % 2 == 0); // Returns option containing value 2
/// ```
///
/// - Parameter [list]: The list in which to search for an element.
/// - Returns: A function that takes a [Predicate] and returns an
///   `Option<T>` containing the first element that satisfies the given predicate,
///   or `None<T>()` if no such element is found.
option.Option<T> Function(Predicate<T> predicate) findFirst<T>(
    ImmutableList<T> list) {
  return (Predicate<T> predicate) {
    for (T item in list.items) {
      if (predicate(item)) {
        return option.of(item);
      }
    }
    return option.None<T>();
  };
}

/// Returns a function that searches for the last element in the
/// given [list] that satisfies the provided [Predicate].
///
/// If an element is found that satisfies the [Predicate], that element
/// is returned wrapped in an `Option<T>`. If no element is found,
/// `None<T>()` is returned.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var findLastEven = findLast<int>(myList);
/// var itemOption = findLastEven((item) => item % 2 == 0); // Returns option containing value 4
/// ```
///
/// - Parameter [list]: The list in which to search for an element.
/// - Returns: A function that takes a [Predicate] and returns an
///   `Option<T>` containing the last element that satisfies the given predicate,
///   or `None<T>()` if no such element is found.
option.Option<T> Function(Predicate<T> predicate) findLast<T>(
    ImmutableList<T> list) {
  return (Predicate<T> predicate) {
    for (T item in list.items.reversed) {
      if (predicate(item)) {
        return option.of(item);
      }
    }
    return option.None<T>();
  };
}

/// Creates a copy of the given [list].
///
/// This function returns a new `ImmutableList<T>` with the same elements as the provided [list].
/// This ensures that the original list remains unchanged while operations can be performed
/// on the new list without affecting the original.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var copiedList = copy<int>(myList);
/// ```
///
/// - Parameter [list]: The list to be copied.
/// - Returns: A new `ImmutableList<T>` containing the same elements as the input list.
ImmutableList<T> copy<T>(ImmutableList<T> list) {
  return ImmutableList<T>(list.items);
}

/// Returns a function that takes an `ImmutableList<T>` and modifies a specified item at the given [index]
/// using the provided [modify] function.
///
/// If the given [index] is out of bounds of the list, `None<ImmutableList<T>>()`
/// is returned. Otherwise, a new `ImmutableList<T>` with the modified item is returned.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var incrementItemAt2 = modifyAt<int>(2, (item) => item + 1);
/// var newListOption = incrementItemAt2(myList); // Returns option containing ImmutableList([1, 2, 4, 4, 5])
/// ```
///
/// - Parameters:
///   - [index]: The index of the item to be modified.
///   - [modify]: A function that takes an item of type `T` and returns the modified item of type `T`.
/// - Returns: A function that processes an `ImmutableList<T>` and returns
///   an `Option<ImmutableList<T>>` containing the list with the modified item, or
///   `None<ImmutableList<T>>()` if the index is out of bounds.
option.Option<ImmutableList<T>> Function(ImmutableList<T>) modifyAt<T>(
    int index, T Function(T) modify) {
  return (ImmutableList<T> list) {
    if (index < 0 || index >= list.items.length) {
      return option.None<ImmutableList<T>>();
    }
    final List<T> newListItems = List.from(list.items);
    newListItems[index] = modify(newListItems[index]);
    return option.of(ImmutableList(newListItems));
  };
}

/// Returns a function that takes an `ImmutableList<T>` and updates a specified item
/// at the given [index] with a new [value].
///
/// This is essentially a specialized version of [modifyAt] where the modification
/// function simply replaces the item with a new value.
///
/// Usage:
/// ```dart
/// var myList = ImmutableList([1, 2, 3, 4, 5]);
/// var setItemAt2To99 = updateAt<int>(2, 99);
/// var newListOption = setItemAt2To99(myList); // Returns option containing ImmutableList([1, 2, 99, 4, 5])
/// ```
///
/// - Parameters:
///   - [index]: The index of the item to be updated.
///   - [value]: The new value to be set at the specified index.
/// - Returns: A function that processes an `ImmutableList<T>` and returns
///   an `Option<ImmutableList<T>>` containing the list with the updated item, or
///   `None<ImmutableList<T>>()` if the index is out of bounds.
option.Option<ImmutableList<T>> Function(ImmutableList<T>) updateAt<T>(
    int index, T value) {
  return modifyAt(index, (_) => value);
}

/// Checks if all the items in the provided [ImmutableList] satisfy the given predicate.
///
/// The [every] function will iterate over each item in the list and apply the provided predicate.
/// It will return `true` if every item satisfies the predicate, or `false` otherwise.
///
/// Example:
/// ```dart
/// final list = ImmutableList([1, 2, 3, 4, 5]);
///
/// final allPositive = every(list, (num) => num > 0);
/// print(allPositive); // true
///
/// final allEven = every(list, (num) => num % 2 == 0);
/// print(allEven); // false
/// ```
///
/// [list]: The [ImmutableList] whose items are to be tested.
/// [predicate]: A function that a value in the list has to satisfy.
bool every<T>(ImmutableList<T> list, bool Function(T) predicate) {
  return list.items.every(predicate);
}

/// Determines if one [ImmutableList] is a subset of another [ImmutableList] using a curried function.
///
/// This function checks if all items in the first list (`subsetCandidate`) are contained
/// in the second list (`set`). It uses a custom equality comparer [Eq<T>] to
/// determine if elements are the same.
///
/// Example:
/// ```dart
/// final list1 = ImmutableList([1, 2, 3]);
/// final list2 = ImmutableList([1, 2, 3, 4, 5]);
/// final intEq = Eq<int>((a, b) => a == b);
///
/// final check = isSubset(intEq)(list2);
/// print(check(list1)); // true
/// ```
///
/// [eq]: An equality comparer that checks if two items of type [T] are the same.
bool Function(ImmutableList<T> subsetCandidate) Function(ImmutableList<T> set)
    isSubset<T>(Eq<T> eq) {
  return (ImmutableList<T> set) {
    return (ImmutableList<T> subsetCandidate) {
      return every(
          subsetCandidate, (x) => set.items.any((y) => eq.equals(x, y)));
    };
  };
}

/// Determines whether one list is a superset of another list.
///
/// A superset means that all elements in the second list (potential subset)
/// are contained in the first list (potential superset).
///
/// The function leverages an [Eq] instance to determine equality between elements.
///
/// Example:
/// ```dart
/// final eqInt = Eq<int>((a, b) => a == b);
/// final list1 = ImmutableList([1, 2, 3, 4, 5]);
/// final list2 = ImmutableList([1, 2, 3]);
///
/// final check = isSuperset(eqInt)(list1);
/// assert(check(list2) == true);  // because list1 is a superset of list2
/// ```
///
/// [Eq]: A type class that defines how to compare the equality of two values of the same type.
bool Function(ImmutableList<T> set) Function(ImmutableList<T> supersetCandidate)
    isSuperset<T>(Eq<T> eq) {
  return flip(isSubset(eq));
}

/// Computes the Jaccard index between two lists.
///
/// The Jaccard index, also known as the Jaccard similarity coefficient,
/// is a statistic used for gauging the similarity and diversity of sample sets.
double _jaccardIndex<T>(
    ImmutableList<T> list1, ImmutableList<T> list2, Eq<T> eq) {
  final intersectionSize = intersection(eq)(list1)(list2).length;
  final unionSize = union(eq)(list1)(list2).length;

  if (unionSize == 0) {
    return 0.0; // To handle cases where both sets are empty
  }

  return intersectionSize / unionSize;
}

/// Determines how similar two lists are based on the Jaccard Index.
///
/// The function returns a value between 0 and 1, where 1 means the lists are identical,
/// and 0 means they have no elements in common.
double Function(ImmutableList<T>) Function(ImmutableList<T>) similar<T>(
    Eq<T> eq) {
  return (ImmutableList<T> list1) {
    return (ImmutableList<T> list2) {
      return _jaccardIndex(list1, list2, eq);
    };
  };
}

/// Creates an [ImmutableList] from the provided iterable [items].
///
/// This function constructs an unmodifiable [ImmutableList] from a given
/// iterable of items.
///
/// Example:
/// ```dart
/// final list = of<int>([1, 2, 3, 4]);
/// print(list);  // Outputs: ImmutableList([1, 2, 3, 4])
/// ```
///
/// @param items An iterable to be converted into an [ImmutableList].
/// @return An [ImmutableList] containing all the elements of [items].
ImmutableList<T> of<T>(Iterable<T> items) =>
    ImmutableList<T>(List<T>.unmodifiable(items));

/// Returns an empty [ImmutableList] of the specified type.
///
/// Example:
/// ```dart
/// final list = zero<int>();
/// print(list);  // Outputs: ImmutableList([])
/// ```
///
/// @return An empty [ImmutableList] of type T.
ImmutableList<T> zero<T>() => ImmutableList<T>([]);

/// Flattens a nested [ImmutableList] into a single-dimensional [ImmutableList].
///
/// Given an [ImmutableList] containing other [ImmutableList]s as elements,
/// this function will flatten it into a single-dimensional list.
///
/// Example:
/// ```dart
/// final nestedList = ImmutableList<ImmutableList<int>>([
///   ImmutableList<int>([1, 2]),
///   ImmutableList<int>([3, 4]),
/// ]);
/// final flatList = flatten<int>(nestedList);
/// print(flatList);  // Outputs: ImmutableList([1, 2, 3, 4])
/// ```
///
/// @param nestedList An [ImmutableList] of [ImmutableList]s.
/// @return A flattened [ImmutableList].
ImmutableList<T> flatten<T>(ImmutableList<ImmutableList<T>> nestedList) {
  return flatMap<ImmutableList<T>, T>(identity)(nestedList);
}

/// Compacts a list by filtering out `None` values and extracting values from `Some` options.
///
/// The `compact` function transforms an [ImmutableList] of [option.Option] values into an [ImmutableList]
/// containing only the values inside the `Some` options, effectively filtering out any `None` values.
///
/// Example:
/// ```dart
/// final optionsList = ImmutableList<option.Option<int>>([
///   option.Some(1),
///   option.None(),
///   option.Some(2),
///   option.None(),
///   option.Some(3),
/// ]);
///
/// final compacted = compact(optionsList);
///
/// print(compacted);  // Outputs: ImmutableList([1, 2, 3])
/// ```
///
/// @param listOfOptions An [ImmutableList] of [option.Option] values to be compacted.
/// @return An [ImmutableList] containing only the values from `Some` options.
ImmutableList<A> compact<A>(ImmutableList<option.Option<A>> listOfOptions) =>
    flatMap<option.Option<A>, A>((value) => value is option.Some<A>
        ? ImmutableList<A>([value.value])
        : ImmutableList<A>([]))(listOfOptions);

/// Separates a list of [either.Either] values into two lists: one containing all the [either.Left] values and the other containing all the [either.Right] values.
///
/// Given an [ImmutableList] of [either.Either]s, this function will produce a record containing two [ImmutableList]s:
/// one for values that are [either.Left] and another for values that are [either.Right].
///
/// Examples:
/// ```dart
/// final eithers = ImmutableList([
///   Left<int, String>(1),
///   Right<int, String>('a'),
///   Left<int, String>(2),
///   Right<int, String>('b'),
/// ]);
///
/// final result = separate(eithers);
///
/// print(result.lefts);  // Outputs: ImmutableList([1, 2])
/// print(result.rights); // Outputs: ImmutableList(['a', 'b'])
/// ```
///
/// When provided with an empty list:
/// ```dart
/// final emptyEithers = ImmutableList<either.Either<int, String>>([]);
///
/// final emptyResult = separate(emptyEithers);
///
/// print(emptyResult.lefts);  // Outputs: ImmutableList([])
/// print(emptyResult.rights); // Outputs: ImmutableList([])
/// ```
///
/// @param eithers An [ImmutableList] of [either.Either] values to be separated.
/// @return A record with two properties: `lefts` and `rights` which are [ImmutableList]s containing the separated values.
({ImmutableList<A> lefts, ImmutableList<B> rights}) separate<A, B>(
        ImmutableList<either.Either<A, B>> eithers) =>
    foldLeft<
        either.Either<A, B>,
        ({
          ImmutableList<A> lefts,
          ImmutableList<B> rights
        })>((lefts: zero<A>(), rights: zero<B>()))((acc, curr) {
      if (curr is either.Left<A, B>) {
        return (lefts: append(curr.value)(acc.lefts), rights: acc.rights);
      } else if (curr is either.Right<A, B>) {
        return (lefts: acc.lefts, rights: append(curr.value)(acc.rights));
      }
      return acc;
    })(eithers);

/// Filters the elements of an [ImmutableList] based on a predicate.
///
/// The returned list contains all elements for which the provided
/// predicate [pred] returns `true`.
///
/// Example:
/// ```dart
/// final numbers = ImmutableList<int>([1, 2, 3, 4, 5]);
/// final evens = filter<int>((n) => n % 2 == 0)(numbers);
/// print(evens); // Outputs: ImmutableList([2, 4])
/// ```
///
/// [pred]: The filtering predicate.
/// Returns: A new [ImmutableList] with elements that satisfy the predicate.
ImmutableList<T> Function(ImmutableList<T>) filter<T>(bool Function(T) pred) =>
    (ImmutableList<T> list) => ImmutableList(list._items.where(pred).toList());
