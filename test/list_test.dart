import 'package:func_dart_core/either.dart' as either;
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

  group('symmetricDifference - ', () {
    test('should find elements that are in either list1 or list2 but not both',
        () {
      final differ = symmetricDifference(eqInt);
      final list1 = ImmutableList([1, 2, 3, 4]);
      final list2 = ImmutableList([3, 4, 5, 6]);
      final result = differ(list1)(list2);

      expect(result.items, equals([1, 2, 5, 6]));
    });

    test('should return concatenated lists when no common elements found', () {
      final differ = symmetricDifference(eqInt);
      final list1 = ImmutableList([1, 2]);
      final list2 = ImmutableList([3, 4]);
      final result = differ(list1)(list2);

      expect(result.items, equals([1, 2, 3, 4]));
    });
  });

  group('intersection - ', () {
    test('should find common elements in two lists', () {
      final intersector = intersection(eqInt);
      final list1 = ImmutableList([1, 2, 3, 4]);
      final list2 = ImmutableList([3, 4, 5, 6]);
      final result = intersector(list1)(list2);

      expect(result.items, equals([3, 4]));
    });

    test('should return empty list when no common elements found', () {
      final intersector = intersection(eqInt);
      final list1 = ImmutableList([1, 2]);
      final list2 = ImmutableList([3, 4]);
      final result = intersector(list1)(list2);

      expect(result.items, isEmpty);
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
  group('every - :', () {
    test('should all be positive', () {
      final list = ImmutableList([1, 2, 3, 4, 5]);
      expect(every(list, (n) => n > 0), true);
    });

    test('should NOT all be even', () {
      final list = ImmutableList([1, 2, 3, 4, 5]);
      expect(every(list, (n) => n % 2 == 0), false);
    });

    test('empty list should return true', () {
      final list = ImmutableList([]);
      expect(every(list, (n) => n % 2 == 0), true);
    });

    test('should be true with nulls', () {
      final list = ImmutableList<int?>([1, 2, null, 4, 5]);
      expect(every(list, (n) => n == null || n > 0), true);
    });
  });
  group('isSubset -', () {
    test('should confirm that a list is a subset of another', () {
      final list1 = ImmutableList([1, 2, 3]);
      final list2 = ImmutableList([1, 2, 3, 4, 5]);
      final check = isSubset(eqInt)(list2);
      expect(check(list1), true);
    });

    test('should confirm that a list is not a subset of another', () {
      final list1 = ImmutableList([1, 2, 6]);
      final list2 = ImmutableList([1, 2, 3, 4, 5]);
      final check = isSubset(eqInt)(list2);
      expect(check(list1), false);
    });

    test('should return true for identical lists', () {
      final list1 = ImmutableList([1, 2, 3]);
      final list2 = ImmutableList([1, 2, 3]);
      final check = isSubset(eqInt)(list2);
      expect(check(list1), true);
    });

    test('should return false when the subset candidate is longer than the set',
        () {
      final list1 = ImmutableList([1, 2, 3, 4, 5]);
      final list2 = ImmutableList([1, 2, 3]);
      final check = isSubset(eqInt)(list2);

      expect(check(list1), false);
    });
  });
  group('isSuperset - ', () {
    test('should confirm that a list is a superset of another', () {
      final list1 = ImmutableList([1, 2, 3, 4, 5]);
      final list2 = ImmutableList([1, 2, 3]);
      final check = isSuperset(eqInt)(list2);
      expect(check(list1), true);
    });

    test('should confirm that a list is not a superset of another', () {
      final list1 = ImmutableList([1, 2, 3]);
      final list2 = ImmutableList([1, 2, 3, 4, 5]);
      final check = isSuperset(eqInt)(list2);
      expect(check(list1), false);
    });

    test('should return true for identical lists', () {
      final list1 = ImmutableList([1, 2, 3]);
      final list2 = ImmutableList([1, 2, 3]);
      final check = isSuperset(eqInt)(list1);
      expect(check(list2), true);
    });

    test(
        'should return true when the superset candidate is shorter than the subset',
        () {
      final list1 = ImmutableList([1, 2, 3]);
      final list2 = ImmutableList([1, 2, 3, 4, 5]);
      final check = isSuperset(eqInt)(list1);
      expect(check(list2), true);
    });
  });

  group('similar - ', () {
    test('should return 1 for two identical lists', () {
      final list1 = ImmutableList([1, 2, 3, 4, 5]);
      final list2 = ImmutableList([1, 2, 3, 4, 5]);
      final similarityScore = similar(eqInt)(list1)(list2);
      expect(similarityScore, 1.0);
    });

    test('should return 0 for two completely different lists', () {
      final list1 = ImmutableList([1, 2, 3]);
      final list2 = ImmutableList([4, 5, 6]);
      final similarityScore = similar(eqInt)(list1)(list2);
      expect(similarityScore, 0.0);
    });

    test('should calculate similarity for partially overlapping lists', () {
      final list1 = ImmutableList([1, 2, 3, 4, 5]);
      final list2 = ImmutableList([4, 5, 6, 7, 8]);
      final similarityScore = similar(eqInt)(list1)(list2);
      expect(similarityScore, 2 / 8); // Intersection = 2, Union = 8
    });

    test('should handle empty lists appropriately', () {
      final list1 = ImmutableList<int>([]);
      final list2 = ImmutableList<int>([]);
      final similarityScore = similar(eqInt)(list1)(list2);
      expect(similarityScore, 0.0); // As both lists are empty
    });

    test('should handle one empty list and one non-empty list', () {
      final list1 = ImmutableList<int>([]);
      final list2 = ImmutableList([1, 2, 3]);
      final similarityScore = similar(eqInt)(list1)(list2);
      expect(similarityScore, 0.0); // No intersection
    });
  });

  group('separate - ', () {
    test('should separate a list of Eithers into lefts and rights', () {
      final eithers = ImmutableList([
        either.Left<int, String>(1),
        either.Right<int, String>('a'),
        either.Left<int, String>(2),
        either.Right<int, String>('b'),
      ]);

      final result = separate(eithers);

      expect(result.lefts, equals(ImmutableList([1, 2])));
      expect(result.rights, equals(ImmutableList(['a', 'b'])));
    });

    test('should return empty lefts and rights for an empty list', () {
      final eithers = ImmutableList<either.Either<int, String>>([]);

      final result = separate(eithers);

      expect(result.lefts, isEmpty);
      expect(result.rights, isEmpty);
    });

    test('should return all lefts and empty rights if Eithers are all lefts',
        () {
      final eithers = ImmutableList([
        either.Left<int, String>(1),
        either.Left<int, String>(2),
        either.Left<int, String>(3),
      ]);

      final result = separate(eithers);

      expect(result.lefts, equals(ImmutableList([1, 2, 3])));
      expect(result.rights, isEmpty);
    });

    test('should return all rights and empty lefts if Eithers are all rights',
        () {
      final eithers = ImmutableList([
        either.Right<int, String>('a'),
        either.Right<int, String>('b'),
        either.Right<int, String>('c'),
      ]);

      final result = separate(eithers);

      expect(result.lefts, isEmpty);
      expect(result.rights, equals(ImmutableList(['a', 'b', 'c'])));
    });
  });
  group('compact function', () {
    test('should compact a list of options into a list of values', () {
      final optionsList = ImmutableList<option.Option<int>>([
        option.Some(1),
        option.None(),
        option.Some(2),
        option.None(),
        option.Some(3),
      ]);

      final result = compact(optionsList);

      expect(result, ImmutableList([1, 2, 3]));
    });

    test('should return an empty list when all options are None', () {
      final optionsList = ImmutableList<option.Option<int>>([
        option.None(),
        option.None(),
        option.None(),
      ]);

      final result = compact(optionsList);

      expect(result, ImmutableList([]));
    });

    test('should return a list of all values when all options are Some', () {
      final optionsList = ImmutableList<option.Option<int>>([
        option.Some(1),
        option.Some(2),
        option.Some(3),
      ]);

      final result = compact(optionsList);

      expect(result, ImmutableList([1, 2, 3]));
    });
  });
  test('of should create an ImmutableList from an iterable', () {
    final list = of<int>([1, 2, 3, 4]);
    expect(list, ImmutableList([1, 2, 3, 4]));
  });

  test('zero should return an empty ImmutableList', () {
    final list = zero<int>();
    expect(list, ImmutableList([]));
  });

  test('flatten should transform a nested ImmutableList into a flat one', () {
    final nestedList = ImmutableList<ImmutableList<int>>([
      ImmutableList<int>([1, 2]),
      ImmutableList<int>([3, 4]),
    ]);
    final flatList = flatten<int>(nestedList);
    expect(flatList, ImmutableList([1, 2, 3, 4]));
  });
  group('filter - ', () {
    test('should retain elements that satisfy the predicate', () {
      final list = ImmutableList<int>([1, 2, 3, 4, 5]);
      final evens = filter<int>((n) => n % 2 == 0)(list);
      expect(evens, ImmutableList<int>([2, 4]));
    });

    test('should return an empty list if no elements satisfy the predicate',
        () {
      final list = ImmutableList<int>([1, 3, 5, 7, 9]);
      final evens = filter<int>((n) => n % 2 == 0)(list);
      expect(evens, ImmutableList<int>([]));
    });

    test(
        'should return the original list if all elements satisfy the predicate',
        () {
      final list = ImmutableList<int>([2, 4, 6, 8, 10]);
      final evens = filter<int>((n) => n % 2 == 0)(list);
      expect(evens, list);
    });
  });
}
