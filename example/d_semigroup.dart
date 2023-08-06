import 'package:functional_dart/eq.dart' as eq;
import 'package:functional_dart/ord.dart' as ord;

import 'a_user_record.dart';
import 'b_eq.dart';
import 'c_ord.dart';

// semigroup is an abstraction that combines things together
// this example abstracts concepts from eq_example and ord_example

// Combine Eq (order does matter)
final eqAgeAndNameLength =
    eq.getSemigroup<UserRecord>().concat(eqNameLength, eqAge);

// Combine Ord, (order of the concat params change the sort)

// sort by age, then name length
final ordAgeThenNameLength =
    ord.getSemigroup<UserRecord>().concat(ordAge, ordNameLength);

// sort by name lenth then age
final ordNameLengthThenAge =
    ord.getSemigroup<UserRecord>().concat(ordNameLength, ordAge);

UserRecord dave = (name: "Dave", age: 23);
UserRecord john = (name: "John", age: 23);
UserRecord bob = (name: "Bob", age: 25);

void main() {
  // Check if dave and john have the same age AND same name length
  print('Yes: ${eqAgeAndNameLength.equals(dave, john)}');

  // Check if dave and bob have the same age AND same name length
  print('No: ${eqAgeAndNameLength.equals(dave, bob)}');

  // Where does bob compare to dave if sorted by age then name length
  print('After: ${ordAgeThenNameLength.compare(bob, dave)}');

  // Where does bob compare to dave if sorted by name length then age
  print('Before ${ordNameLengthThenAge.compare(bob, dave)}');
}
