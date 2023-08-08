import 'dart:collection';
import 'package:func_dart_core/eq.dart';

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

ImmutableList<B> Function(ImmutableList<A>) map<A, B>(B Function(A) f) =>
    (ImmutableList<A> list) => ImmutableList(list._items.map(f).toList());

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

// ImmutableList<B> Function(ImmutableList<A>) ap<A, B>(
//         ImmutableList<B Function(A)> fns) =>
//     (ImmutableList<A> list) =>
//         ImmutableList(fns._items.expand((fn) => list._items.map(fn)).toList());

// ImmutableList<A> Function(ImmutableList<A>) Function(ImmutableList<A>)
//     difference<A>(Eq<A> eq) {
//   return (ImmutableList<A> list1) {
//     return (ImmutableList<A> list2) {
//       final itemsInList2 = list2.items.toSet();
//       return ImmutableList(list1.items
//           .where(
//               (item1) => !itemsInList2.any((item2) => eq.equals(item1, item2)))
//           .toList());
//     };
//   };
// }

// B Function(ImmutableList<T>) Function(B Function(B, T)) foldLeft<T, B>(
//     B empty) {
//   return (B Function(B, T) concat) {
//     return (ImmutableList<T> list) {
//       return list.items.fold(empty, concat);
//     };
//   };
// }

// const reduceLeft = foldLeft;

// B Function(ImmutableList<T>) Function(B Function(B, T)) foldRight<T, B>(
//     B empty) {
//   return (B Function(B, T) concat) {
//     return (ImmutableList<T> list) {
//       return list.items.reversed.fold(empty, concat);
//     };
//   };
// }

// const reduceRight = foldRight;

// ImmutableList<B> Function(ImmutableList<T>) Function(B Function(B, T) combine)
//     scanLeft<T, B>(B initial) {
//   return (B Function(B, T) combine) {
//     return (ImmutableList<T> list) {
//       List<B> results = [initial];
//       B accumulator = initial;

//       for (T item in list.items) {
//         accumulator = combine(accumulator, item);
//         results.add(accumulator);
//       }

//       return ImmutableList(results);
//     };
//   };
// }

// ImmutableList<B> Function(ImmutableList<T>) Function(B Function(B, T) combine)
//     scanRight<T, B>(B initial) {
//   return (B Function(B, T) combine) {
//     return (ImmutableList<T> list) {
//       List<B> results = [initial];
//       B accumulator = initial;

//       for (T item in list.items.reversed) {
//         accumulator = combine(accumulator, item);
//         results.add(accumulator);
//       }

//       return ImmutableList(results.reversed.toList());
//     };
//   };
// }
