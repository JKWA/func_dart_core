import 'package:functional_dart/ord.dart';
import 'package:functional_dart/string.dart';
import 'package:functional_dart/integer.dart';
import 'a_user_record.dart';

// Define ordering based on different attributes.
final ordAge = contramap(getUserAge)(ordInt);
final reverseOrdAge = reverse(ordAge);
final ordName = contramap(getUserName)(ordString);
final ordStringLength = contramap(size)(ordInt);
final ordNameLength = contramap(getUserName)(ordStringLength);

UserRecord dave = (name: "Dave", age: 23);
UserRecord john = (name: "John", age: 21);

void main() {
  // Sort dave and john by which is older
  print('After: ${ordAge.compare(dave, john)}');

  // Sort dave and john by which is younger
  print('Before: ${reverseOrdAge.compare(dave, john)}');

  // Sort john and dave by name
  print('After ${ordName.compare(john, dave)}');

  // Sort john and dave by name length
  print('Eq ${ordNameLength.compare(john, dave)}');
}
