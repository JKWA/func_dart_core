import 'package:functional_dart/eq.dart' as eq;

typedef UserRecord = ({String name, int age});
String getUserName(UserRecord u) => u.name;
int getUserAge(UserRecord u) => u.age;

final eqInt = eq.fromEquals<int>((x, y) => x == y);
final eqStringLength = eq.contramap<String, int>((s) => s.length)(eqInt);

final eqUserNameLength =
    eq.contramap<UserRecord, String>(getUserName)(eqStringLength);
final eqUserAge = eq.contramap<UserRecord, int>(getUserAge)(eqInt);

UserRecord dave = (name: "Dave", age: 23);
UserRecord john = (name: "John", age: 23);
UserRecord bob = (name: "Bob", age: 23);

void main() {
  final combinedEq =
      eq.getSemigroup<UserRecord>().concat(eqUserNameLength, eqUserAge);

  print('dave and john are equal ${combinedEq.equals(dave, john)}');
  print('dave and bob are equal ${combinedEq.equals(dave, bob)}');
}
