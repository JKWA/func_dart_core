import 'package:functional_dart/eq.dart';
import 'package:functional_dart/integer.dart';
import 'package:functional_dart/string.dart';

import 'a_user_record.dart';

// A contramap takes a function to transform the input before it is processed
// The function below uses the contramap to transform a String into length
// and applies equality for integers.
final eqStringLength = contramap(size)(eqInt);

// Define user equality based on different attributes.
final eqAge = contramap(getUserAge)(eqInt);
final eqName = contramap(getUserName)(eqString);
final eqNameLength = contramap(getUserName)(eqStringLength);

UserRecord dave = (name: "Dave", age: 23);
UserRecord john = (name: "John", age: 23);

void main() {
  // Check if dave and john have the same age.
  print('Yes: ${eqAge.equals(dave, john)}');

  // Check if dave and john have same names.
  print('No:  ${eqName.equals(dave, john)}');

  // Check if dave and john's names are the same length.
  print('Yes:  ${eqNameLength.equals(dave, john)}');
}
