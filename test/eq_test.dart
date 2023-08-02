import 'package:test/test.dart';
import 'package:functional_dart/eq.dart';
import 'package:functional_dart/integer.dart';

class Person {
  final String name;

  Person(this.name);
}

typedef UserRecord = ({String name, int age});

void main() {
  getUserName(UserRecord u) => u.name;
  getUserAge(UserRecord u) => u.age;

  final eqStringLength = contramap<String, int>((s) => s.length)(eqInt);

  group('Eq', () {
    test(
        'fromEquals constructs an Eq object with the provided equality function',
        () {
      expect(eqInt.equals(3, 3), isTrue);
      expect(eqInt.equals(3, 4), isFalse);
    });

    test('fromEquals works with custom object types', () {
      final eqPerson = fromEquals<Person>((x, y) => x.name == y.name);

      expect(eqPerson.equals(Person('Alice'), Person('Alice')), isTrue);
      expect(eqPerson.equals(Person('Alice'), Person('Bob')), isFalse);
    });

    test(
        'fromEquals allows null comparisons if the equality function handles them',
        () {
      final eqNullableString = fromEquals<String?>((x, y) => x == y);

      expect(eqNullableString.equals(null, null), isTrue);
      expect(eqNullableString.equals(null, 'test'), isFalse);
      expect(eqNullableString.equals('test', null), isFalse);
    });

    test(
        'contramap constructs an Eq<B> object based on Eq<A> and a mapping function',
        () {
      expect(eqStringLength.equals('foo', 'bar'), isTrue);
      expect(eqStringLength.equals('foo', 'hello'), isFalse);
    });
  });

  final eqUserNameLength =
      contramap<UserRecord, String>(getUserName)(eqStringLength);
  final eqUserAge = contramap<UserRecord, int>(getUserAge)(eqInt);

  UserRecord dave = (name: "Dave", age: 23);
  UserRecord john = (name: "John", age: 23);
  UserRecord bob = (name: "Bob", age: 23);

  group('Semigroup', () {
    test('concat', () {
      final s = getSemigroup<int>();
      final combinedEq = s.concat(eqInt, eqInt);
      expect(combinedEq.equals(5, 5), isTrue);
      expect(combinedEq.equals(5, 10), isFalse);
    });
    test('concat Record', () {
      final s = getSemigroup<UserRecord>();
      final eqNameLengthAndAge = s.concat(eqUserNameLength, eqUserAge);
      expect(eqNameLengthAndAge.equals(dave, john), isTrue);
      expect(eqNameLengthAndAge.equals(dave, bob), isFalse);
    });
  });

  group('Monoid', () {
    test('concat', () {
      final m = getMonoid<int>();
      final combinedEq = m.concat(eqInt, eqInt);
      expect(combinedEq.equals(5, 5), isTrue);
      expect(combinedEq.equals(5, 10), isFalse);
    });

    test('empty', () {
      final m = getMonoid<int>();
      expect(m.empty.equals(5, 5), isTrue);
      expect(m.empty.equals(5, 10), isTrue);
    });

    test('concat with empty', () {
      final m = getMonoid<int>();
      final combinedEq = m.concat(eqInt, m.empty);
      expect(combinedEq.equals(5, 5), isTrue);
      expect(combinedEq.equals(5, 10), isFalse);
    });

    test('concat with empty for a Record', () {
      final m = getMonoid<UserRecord>();
      final eqAge = m.concat(eqUserAge, m.empty);
      final eqAgeAndNameLength = m.concat(eqAge, eqUserNameLength);
      expect(eqAge.equals(dave, bob), isTrue);
      expect(eqAgeAndNameLength.equals(dave, john), isTrue);
      expect(eqAgeAndNameLength.equals(dave, bob), isFalse);
    });
  });
}
