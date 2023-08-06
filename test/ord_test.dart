import 'package:functional_dart/integer.dart';
import 'package:functional_dart/ord.dart';
import 'package:functional_dart/string.dart';
import 'package:test/test.dart';

typedef UserRecord = ({String name, int age});

void main() {
  UserRecord bob = (name: "Bob", age: 25);
  UserRecord dave = (name: "Dave", age: 23);
  UserRecord john = (name: "John", age: 21);
  String getUserName(UserRecord u) => u.name;
  int getUserAge(UserRecord u) => u.age;
  final ordName = contramap(getUserName)(ordString);
  final ordAge = contramap(getUserAge)(ordInt);

  group('Ord', () {
    test('between', () {
      final isBetween5and10 = between(ordInt)(5, 10);
      expect(isBetween5and10(7), isTrue);
      expect(isBetween5and10(3), isFalse);
      expect(isBetween5and10(12), isFalse);
    });

    test('clamp', () {
      final clampTo5and10 = clamp(ordInt)(5, 10);
      expect(clampTo5and10(7), 7);
      expect(clampTo5and10(3), 5);
      expect(clampTo5and10(12), 10);
    });

    test('contramap', () {
      int stringToInt(String s) => int.parse(s);
      final ordString = contramap<String, int>(stringToInt)(ordInt);
      expect(ordString.compare("5", "10"), -1);
    });

    test('gt and lt', () {
      final greaterThan = gt(ordInt);
      final lessThan = lt(ordInt);
      expect(greaterThan(10, 5), isTrue);
      expect(lessThan(5, 10), isTrue);
    });

    test('max and min', () {
      final maximum = max(ordInt);
      final minimum = min(ordInt);
      expect(maximum(10, 5), 10);
      expect(minimum(5, 10), 5);
    });

    test('reverse', () {
      final reversedIntOrd = reverse(ordInt);
      expect(ordInt.compare(5, 10), -1);
      expect(reversedIntOrd.compare(5, 10), 1);
    });

    final userCompare = contramap<UserRecord, String>(getUserName)(ordString);

    test('reverse with a record', () {
      final reversedIntOrd = reverse(userCompare);
      expect(userCompare.compare(dave, john), -1);
      expect(reversedIntOrd.compare(dave, john), 1);
    });
  });
  group('Ord as Eq', () {
    test('Ord function works in Eq context', () {
      expect(ordInt.equals(3, 3), isTrue);
      expect(ordInt.equals(3, 4), isFalse);
    });
  });

  group('Semigroup', () {
    test('Ord Semigroup should combine two comparisons', () {
      final semigroup = getSemigroup<UserRecord>();

      final ordNameThenAge = semigroup.concat(ordName, ordAge);
      final ordAgeThenName = semigroup.concat(ordAge, ordName);

      expect(ordNameThenAge.compare(dave, bob), 1);
      expect(ordNameThenAge.compare(bob, john), -1);
      expect(ordAgeThenName.compare(dave, bob), -1);
      expect(ordAgeThenName.compare(bob, john), 1);
      expect(ordAgeThenName.compare(bob, bob), 0);
    });

    test('Ord Monoid should provide an empty element', () {
      final monoid = getMonoid<UserRecord>();

      final ordNameWithEmpty = monoid.concat(monoid.empty, ordName);
      final ordAgeWithEmpty = monoid.concat(monoid.empty, ordAge);

      expect(ordNameWithEmpty.compare(dave, bob), 1);
      expect(ordNameWithEmpty.compare(bob, john), -1);
      expect(ordAgeWithEmpty.compare(dave, bob), -1);
      expect(ordAgeWithEmpty.compare(bob, john), 1);
      expect(ordAgeWithEmpty.compare(bob, bob), 0);

      final reverseOrdAge = reverse(ordAgeWithEmpty);

      expect(reverseOrdAge.compare(dave, bob), 1);
      expect(reverseOrdAge.compare(bob, john), -1);
    });
  });
}
