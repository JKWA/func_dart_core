import 'package:func_dart_core/integer.dart';
import 'package:func_dart_core/list.dart' hide group;
import 'package:func_dart_core/list.dart' as l;
import 'package:func_dart_core/option.dart' as option;
import 'package:test/test.dart';

void main() {
  group('ImmutableList -', () {
    test('should properly construct and provide items', () {
      final il = ImmutableList([1, 2, 3]);
      expect(il.items, [1, 2, 3]);
    });

    test('should prepend item correctly', () {
      final il = ImmutableList([1, 2, 3]);
      final result = prepend<int>(1)(il);
      expect(result.items, equals([1, 1, 2, 3]));
    });

    test('should append item correctly', () {
      final il = ImmutableList([1, 2, 3, 4]);
      final result = append<int>(5)(il);
      expect(result.items, equals([1, 2, 3, 4, 5]));
    });

    test('should retrieve unique items', () {
      final il = ImmutableList([1, 2, 2, 3, 3]);
      expect(unique(eqInt)(il).items, [1, 2, 3]);
    });

    test('should union two lists correctly', () {
      final il1 = ImmutableList([1, 2, 3]);
      final il2 = ImmutableList([2, 3, 4]);
      expect(union(eqInt)(il1)(il2).items, [1, 2, 3, 4]);
    });

    test('should reverse the items correctly', () {
      final il = ImmutableList([1, 2, 3]);
      expect(reverse(il).items, [3, 2, 1]);
    });

    test('should group items based on equality', () {
      final il = ImmutableList([1, 1, 2, 2, 3]);
      final groups = l.group(eqInt)(il);
      expect(groups.map((g) => g.items).toList(), [
        [1, 1],
        [2, 2],
        [3]
      ]);
    });

    test('should group items by a specific property', () {
      final il = ImmutableList(["one", "two", "three"]);
      final grouped = groupBy<String, int>((s) => s.length)(il);
      expect(grouped[3]!.items, ["one", "two"]);
    });

    test('should map items to their string representation', () {
      final il = ImmutableList([1, 2, 3]);
      expect(map<int, String>((i) => i.toString())(il).items, ["1", "2", "3"]);
    });

    test('should flatMap items multiplying each by 10', () {
      final il = ImmutableList([1, 2, 3]);
      expect(flatMap<int, int>((i) => ImmutableList([i, i * 10]))(il).items,
          [1, 10, 2, 20, 3, 30]);
    });

    test('should apply functions over the items', () {
      final il = ImmutableList([1, 2, 3]);
      final fns = ImmutableList([(int i) => i + 1, (int i) => i * 2]);
      expect(ap<int, int>(fns)(il).items, [2, 3, 4, 2, 4, 6]);
    });

    test('should compute the difference between two lists', () {
      final listA = ImmutableList([1, 2, 3, 4]);
      final listB = ImmutableList([3, 4, 5, 6]);
      final diff = difference<int>(eqInt)(listA)(listB);
      expect(diff.items, [1, 2]);
    });
  });

  group('folding - ', () {
    test('should compute the sum using foldLeft', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int sumFn(int accumulator, int item) => accumulator + item;
      final result = foldLeft<int, int>(0)(sumFn)(il);
      expect(result, equals(10));
    });

    test('should compute the product using foldLeft', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int productFn(int accumulator, int item) => accumulator * item;
      final result = foldLeft<int, int>(1)(productFn)(il);
      expect(result, equals(24));
    });

    test('should compute the sum using foldRight', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int sumFn(int accumulator, int item) => accumulator + item;
      final result = foldRight<int, int>(0)(sumFn)(il);
      expect(result, equals(10));
    });

    test('should compute the product using foldRight', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int productFn(int accumulator, int item) => accumulator * item;
      final result = foldRight<int, int>(1)(productFn)(il);
      expect(result, equals(24));
    });

    test('should compute cumulative sum using scanLeft', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int sumFn(int accumulator, int item) => accumulator + item;
      final result = scanLeft<int, int>(0)(sumFn)(il);
      expect(result.items, equals([0, 1, 3, 6, 10]));
    });

    test('should compute cumulative sum from the right using scanRight', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int sumFn(int accumulator, int item) => accumulator + item;
      final result = scanRight<int, int>(0)(sumFn)(il);
      expect(result.items, equals([10, 9, 7, 4, 0]));
    });

    test('should concatenate two ImmutableList instances', () {
      final il = ImmutableList([1, 2]);
      final i2 = ImmutableList([3, 4]);
      final result = concat<int>(il)(i2);
      expect(result.items, equals([1, 2, 3, 4]));
    });

    test('should retrieve the length of ImmutableList', () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      expect(size(il), 5);
    });

    test('should check if the index is out of bounds for ImmutableList', () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      expect(isOutOfBounds(6, il), true);
      expect(isOutOfBounds(-1, il), true);
      expect(isOutOfBounds(0, il), false);
      expect(isOutOfBounds(4, il), false);
    });
  });

  group('takeLeft - ', () {
    test('takeLeft function - within bounds', () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeLeft<int>(3)(il);
      expect(result.items, equals([1, 2, 3]));
    });

    test('takeLeft function - out of bounds', () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeLeft<int>(6)(il);
      expect(result.items, equals([1, 2, 3, 4, 5]));
    });

    test('takeLeft function - take zero', () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeLeft<int>(0)(il);
      expect(result.items, equals([]));
    });

    test('takeLeft function - on empty list', () {
      final il = ImmutableList<int>([]);
      final result = takeLeft<int>(3)(il);
      expect(result.items, equals([]));
    });
  });
  group('takeRight - ', () {
    test('within bounds', () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeRight<int>(3)(il);
      expect(result.items, equals([3, 4, 5]));
    });

    test('out of bounds', () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeRight<int>(6)(il);
      expect(result.items, equals([1, 2, 3, 4, 5]));
    });

    test('take zero', () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeRight<int>(0)(il);
      expect(result.items, equals([]));
    });

    test('on empty list', () {
      final il = ImmutableList<int>([]);
      final result = takeRight<int>(3)(il);
      expect(result.items, equals([]));
    });
  });
  group('takeLeftWhile - ', () {
    test('should take items as long as they satisfy the predicate', () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeLeftWhile((int item) => item < 4)(il);
      expect(result.items, equals([1, 2, 3]));
    });

    test('should return all items when all satisfy the predicate', () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeLeftWhile((int item) => item <= 5)(il);
      expect(result.items, equals([1, 2, 3, 4, 5]));
    });

    test(
        'should return an empty list if none of the items satisfy the predicate',
        () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeLeftWhile((int item) => item > 5)(il);
      expect(result.items, equals([]));
    });

    test('should return an empty list when applied on an empty list', () {
      final il = ImmutableList<int>([]);
      final result = takeLeftWhile((int item) => item <= 5)(il);
      expect(result.items, equals([]));
    });
  });
  group('takeRightWhile - ', () {
    test('should take items from the end as long as they satisfy the predicate',
        () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeRightWhile((int item) => item > 3)(il);
      expect(result.items, equals([4, 5]));
    });

    test('should return all items when all satisfy the predicate', () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeRightWhile((int item) => item >= 1)(il);
      expect(result.items, equals([1, 2, 3, 4, 5]));
    });

    test(
        'should return an empty list if none of the items from the end satisfy the predicate',
        () {
      final il = ImmutableList<int>([1, 2, 3, 4, 5]);
      final result = takeRightWhile((int item) => item < 1)(il);
      expect(result.items, equals([]));
    });

    test('should return an empty list when applied on an empty list', () {
      final il = ImmutableList<int>([]);
      final result = takeRightWhile((int item) => item >= 1)(il);
      expect(result.items, equals([]));
    });
  });

  group('dropLeft - ', () {
    final il = ImmutableList<int>([1, 2, 3, 4, 5]);

    test('should drop the specified number of items from the beginning', () {
      expect(dropLeft<int>(3)(il).items, equals([4, 5]));
    });

    test(
        'should return an empty list if the count is greater or equal to list size',
        () {
      expect(dropLeft<int>(5)(il).items, equals([]));
      expect(dropLeft<int>(6)(il).items, equals([]));
    });

    test('should return the same list if the count is zero', () {
      expect(dropLeft<int>(0)(il).items, equals([1, 2, 3, 4, 5]));
    });
  });

  group('dropRight - ', () {
    final il = ImmutableList<int>([1, 2, 3, 4, 5]);

    test('should drop the specified number of items from the end', () {
      expect(dropRight<int>(3)(il).items, equals([1, 2]));
    });

    test(
        'should return an empty list if the count is greater or equal to list size',
        () {
      expect(dropRight<int>(5)(il).items, equals([]));
      expect(dropRight<int>(6)(il).items, equals([]));
    });

    test('should return the same list if the count is zero', () {
      expect(dropRight<int>(0)(il).items, equals([1, 2, 3, 4, 5]));
    });
  });
  group('findIndex - ', () {
    final il = ImmutableList<int>([1, 2, 3, 4, 5]);

    test('should find the index of the first item that satisfies the predicate',
        () {
      expect(findIndex<int>((item) => item > 3)(il), isA<option.Some<int>>());
      expect((findIndex<int>((item) => item > 3)(il) as option.Some<int>).value,
          equals(3));
    });

    test('should return None if no items satisfy the predicate', () {
      expect(findIndex<int>((item) => item > 10)(il), isA<option.None<int>>());
    });

    test(
        'should return the index of the first item if the first item satisfies the predicate',
        () {
      expect(findIndex<int>((item) => item < 3)(il), isA<option.Some<int>>());
      expect((findIndex<int>((item) => item < 3)(il) as option.Some<int>).value,
          equals(0));
    });
  });

  group('findFirst -', () {
    final il = ImmutableList<int>([1, 2, 3, 4, 5]);

    test('should return the first element that matches the predicate', () {
      final result = findFirst(il)((int item) => item.isEven);
      expect(result, isA<option.Some<int>>());
      expect((result as option.Some<int>).value, 2);
    });

    test('should return None if no elements match the predicate', () {
      final result = findFirst(il)((int item) => item > 10);
      expect(result, isA<option.None<int>>());
    });

    test('should return the first element if predicate always true', () {
      final result = findFirst(il)((int item) => true);
      expect(result, isA<option.Some<int>>());
      expect((result as option.Some<int>).value, 1);
    });

    test('should return None if predicate always false', () {
      final result = findFirst(il)((int item) => false);
      expect(result, isA<option.None<int>>());
    });
  });

  group('findLast - ', () {
    final list = ImmutableList<int>([1, 2, 3, 4, 5, 4, 3, 2, 1]);

    test('should find the last even number', () {
      final result = findLast(list)((item) => item % 2 == 0);
      expect(result, option.Some(2));
    });

    test('should return None when no item satisfies the predicate', () {
      final result = findLast(list)((item) => item > 10);
      expect(result, option.None<int>());
    });

    test('should find the last item equal to 3', () {
      final result = findLast(list)((item) => item == 3);
      expect(result, option.Some(3));
    });
  });
  group('copy - ', () {
    test('should create a new copy of the given list', () {
      final originalList = ImmutableList<int>([1, 2, 3]);
      final copiedList = copy(originalList);

      expect(copiedList.items, [1, 2, 3]);
      expect(identical(copiedList, originalList), isFalse);
    });
  });
  group('modifyAt - ', () {
    test('should modify the value at the given index if it is valid', () {
      final originalList = ImmutableList<int>([1, 2, 3]);
      final updatedListOpt = modifyAt(1, (int val) => val * 2)(originalList);

      expect(updatedListOpt is option.Some<ImmutableList<int>>, isTrue);
      expect((updatedListOpt as option.Some<ImmutableList<int>>).value.items,
          [1, 4, 3]);
    });

    test('should return None if the index is out of bounds', () {
      final originalList = ImmutableList<int>([1, 2, 3]);
      final updatedListOpt = modifyAt(5, (int val) => val * 2)(originalList);

      expect(updatedListOpt is option.None<ImmutableList<int>>, isTrue);
    });
  });

  group('updateAt - ', () {
    test('should update the value at the given index if it is valid', () {
      final originalList = ImmutableList<int>([1, 2, 3]);
      final updatedListOpt = updateAt(1, 4)(originalList);

      expect(updatedListOpt is option.Some<ImmutableList<int>>, isTrue);
      expect((updatedListOpt as option.Some<ImmutableList<int>>).value.items,
          [1, 4, 3]);
    });

    test('should return None if the index is out of bounds', () {
      final originalList = ImmutableList<int>([1, 2, 3]);
      final updatedListOpt = updateAt(5, 4)(originalList);

      expect(updatedListOpt is option.None<ImmutableList<int>>, isTrue);
    });
  });
}
