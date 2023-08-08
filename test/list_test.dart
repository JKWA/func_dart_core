import 'package:func_dart_core/integer.dart';
import 'package:func_dart_core/list.dart' hide group;
import 'package:func_dart_core/list.dart' as l;
import 'package:test/test.dart';

void main() {
  group('ImmutableList tests', () {
    test('Construction and items', () {
      final il = ImmutableList([1, 2, 3]);
      expect(il.items, [1, 2, 3]);
    });

    test('prepend', () {
      final il = ImmutableList([1, 2, 3]);
      final result = prepend<int>(1)(il);
      expect(result.items, equals([1, 1, 2, 3]));
    });

    test('append', () {
      final il = ImmutableList([1, 2, 3, 4]);
      final result = append<int>(5)(il);
      expect(result.items, equals([1, 2, 3, 4, 5]));
    });

    test('unique', () {
      final il = ImmutableList([1, 2, 2, 3, 3]);
      expect(unique(eqInt)(il).items, [1, 2, 3]);
    });

    test('union', () {
      final il1 = ImmutableList([1, 2, 3]);
      final il2 = ImmutableList([2, 3, 4]);
      expect(union(eqInt)(il1)(il2).items, [1, 2, 3, 4]);
    });

    test('reverse', () {
      final il = ImmutableList([1, 2, 3]);
      expect(reverse(il).items, [3, 2, 1]);
    });

    test('group', () {
      final il = ImmutableList([1, 1, 2, 2, 3]);
      final groups = l.group(eqInt)(il);
      expect(groups.map((g) => g.items).toList(), [
        [1, 1],
        [2, 2],
        [3]
      ]);
    });

    test('groupBy', () {
      final il = ImmutableList(["one", "two", "three"]);
      final grouped = groupBy<String, int>((s) => s.length)(il);
      expect(grouped[3]!.items, ["one", "two"]);
    });

    test('map', () {
      final il = ImmutableList([1, 2, 3]);
      expect(map<int, String>((i) => i.toString())(il).items, ["1", "2", "3"]);
    });

    test('flatMap', () {
      final il = ImmutableList([1, 2, 3]);
      expect(flatMap<int, int>((i) => ImmutableList([i, i * 10]))(il).items,
          [1, 10, 2, 20, 3, 30]);
    });

    test('ap', () {
      final il = ImmutableList([1, 2, 3]);
      final fns = ImmutableList([(int i) => i + 1, (int i) => i * 2]);
      expect(ap<int, int>(fns)(il).items, [2, 3, 4, 2, 4, 6]);
    });
    test('difference', () {
      final listA = ImmutableList([1, 2, 3, 4]);
      final listB = ImmutableList([3, 4, 5, 6]);
      final diff = difference<int>(eqInt)(listA)(listB);
      expect(diff.items, [1, 2]);
    });
  });

  group('folding', () {
    test('foldLeft function - sum', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int sumFn(int accumulator, int item) => accumulator + item;
      final result = foldLeft<int, int>(0)(sumFn)(il);
      expect(result, equals(10));
    });
    test('foldLeft function - product', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int productFn(int accumulator, int item) => accumulator * item;
      final result = foldLeft<int, int>(1)(productFn)(il);
      expect(result, equals(24));
    });

    test('foldRight - sum', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int sumFn(int accumulator, int item) => accumulator + item;
      final result = foldRight<int, int>(0)(sumFn)(il);
      expect(result, equals(10));
    });
    test('foldRight - product', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int productFn(int accumulator, int item) => accumulator * item;
      final result = foldRight<int, int>(1)(productFn)(il);
      expect(result, equals(24));
    });
    test('scanLeft function - cumulative sum', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int sumFn(int accumulator, int item) => accumulator + item;
      final result = scanLeft<int, int>(0)(sumFn)(il);
      expect(result.items, equals([0, 1, 3, 6, 10]));
    });
    test('scanRight function - cumulative sum from right', () {
      final il = ImmutableList([1, 2, 3, 4]);
      int sumFn(int accumulator, int item) => accumulator + item;
      final result = scanRight<int, int>(0)(sumFn)(il);
      expect(result.items, equals([10, 9, 7, 4, 0]));
    });
  });
}
