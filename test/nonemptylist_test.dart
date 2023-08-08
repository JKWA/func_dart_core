import 'package:func_dart_core/integer.dart';
import 'package:func_dart_core/nonemptylist.dart' hide group;
import 'package:func_dart_core/nonemptylist.dart' as n;
import 'package:test/test.dart';

void main() {
  group('NonEmptyList', () {
    test('should not allow empty lists', () {
      expect(() => NonEmptyList([]), throwsArgumentError);
    });

    test('items should be unmodifiable', () {
      final nel = NonEmptyList([1]);
      expect(() => nel.items[0] = 2, throwsUnsupportedError);
    });

    test('prepend should add an item to the beginning', () {
      final nel = prepend(0, [1, 2, 3]);
      expect(nel.items, [0, 1, 2, 3]);
    });

    test('head should return the first item', () {
      final nel = NonEmptyList([1, 2, 3]);
      expect(head(nel), 1);
    });

    test('tail should return all but the first item', () {
      final nel = NonEmptyList([1, 2, 3]);
      expect(tail(nel), [2, 3]);
    });

    test('unique should remove duplicates', () {
      final nel = NonEmptyList([1, 2, 2, 3, 3, 3]);
      final uniqueNel = unique(eqInt)(nel);
      expect(uniqueNel.items, [1, 2, 3]);
    });

    test('union should combine two lists and remove duplicates', () {
      final nel1 = NonEmptyList([1, 2, 3]);
      final nel2 = NonEmptyList([3, 4, 5]);
      final unionNel = union(eqInt)(nel1)(nel2);
      expect(unionNel.items, [1, 2, 3, 4, 5]);
    });

    test('reverse should reverse the list', () {
      final nel = NonEmptyList([1, 2, 3]);
      final reversed = reverse(nel);
      expect(reversed.items, [3, 2, 1]);
    });

    test('group should group contiguous equal elements', () {
      final nel = NonEmptyList([1, 1, 2, 3, 3, 3, 4]);
      final grouped = n.group(eqInt)(nel);

      expect(grouped.length, 4);
      expect(grouped[0].items, [1, 1]);
      expect(grouped[1].items, [2]);
      expect(grouped[2].items, [3, 3, 3]);
      expect(grouped[3].items, [4]);
    });

    test('groupBy should group by key function', () {
      final nel = NonEmptyList(["a", "aa", "aaa", "b", "bb"]);
      final grouped = groupBy<String, int>((s) => s.length)(nel);

      expect(grouped.keys.toList(), [1, 2, 3]);
      expect(grouped[1]!.items, ["a", "b"]);
      expect(grouped[2]!.items, ["aa", "bb"]);
      expect(grouped[3]!.items, ["aaa"]);
    });

    test('map should transform each item in the list', () {
      final nel = NonEmptyList([1, 2, 3]);
      final mapped = map<int, String>((i) => 'item-$i')(nel);

      expect(mapped.items, ["item-1", "item-2", "item-3"]);
    });

    test('flatMap should transform and flatten', () {
      final nel = NonEmptyList([1, 2, 3]);
      final flatMapped =
          flatMap<int, int>((i) => NonEmptyList([i, i * 10]))(nel);

      expect(flatMapped.items, [1, 10, 2, 20, 3, 30]);
    });

    test('ap should apply list of functions to list', () {
      final fns = NonEmptyList([(int i) => i + 1, (int i) => i * 2]);
      final nel = NonEmptyList([1, 2, 3]);
      final result = ap(fns)(nel);

      expect(result.items, [2, 3, 4, 2, 4, 6]);
    });
  });
}
