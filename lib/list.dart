import 'dart:collection';

import 'package:func_dart_core/eq.dart';
import 'package:func_dart_core/option.dart' as option;
import 'package:func_dart_core/predicate.dart';

/// Represents an immutable list of items of type [T].
///
/// Example:
/// ```dart
/// final list = ImmutableList<int>([1, 2, 3]);
/// print(list.items);  // Outputs: (1, 2, 3)
/// ```
class ImmutableList<T> {
  final List<T> _items;

  ImmutableList(List<T> items) : _items = List.unmodifiable(items);

  UnmodifiableListView<T> get items => UnmodifiableListView(_items);
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
