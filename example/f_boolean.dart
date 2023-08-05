import 'package:functional_dart/eq.dart';
import 'package:functional_dart/string.dart';
import 'package:functional_dart/integer.dart';
import 'a_user_record.dart';
import 'package:functional_dart/boolean.dart';

UserRecord dave = (name: "Dave", age: 23);
UserRecord john = (name: "John", age: 23);

final eqAge = contramap(getUserAge)(eqInt).equals(dave, john);
final eqName = contramap(getUserName)(eqString).equals(dave, john);

// eqAge and eqName return boolean values, which can be combined
final eqAgeAndName = MonoidAll().concat(eqAge, eqName);
final eqAgeOrName = MonoidAny().concat(eqAge, eqName);

void main() {
  // Do dave and john have the same age and name?
  print('Age and name: $eqAgeAndName');

  // So dave and john have the same age or name.
  print('Age or name: $eqAgeOrName');
}
