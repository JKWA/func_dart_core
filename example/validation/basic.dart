import 'package:func_dart_core/either.dart';
import 'package:func_dart_core/function.dart';
import 'package:func_dart_core/predicate.dart' as p;

// Typedefs for clarity.
typedef UserData = ({String name, int age});
typedef Validator = Either<String, dynamic> Function(UserData);
typedef ValidatorRecord = ({String key, Validator validator});

// Lenses: Functional utilities that focus on specific parts of a data structure.
// Here, they're simple getters, but in more complex cases, they can be used to
// work with nested or immutable structures.
String getName(UserData data) => data.name;
int getAge(UserData data) => data.age;

// Predicates: Pure functions that return a boolean based on input.
bool isNotEmpty(String value) => value.isNotEmpty;
bool hasValidLength(String value) => value.length <= 50;
bool isNotNegative(int value) => value >= 0;

// Higher-order function that generates a predicate.
bool Function(int) isLessThan(int upperBound) {
  return (int value) => value <= upperBound;
}

// Composed Predicates: Combining multiple predicates to form a new one.
// This showcases function composition, a key concept in FP.
final isValidName = pipe2(hasValidLength, p.and(isNotEmpty));
final isValidAge = pipe2(isLessThan(121), p.and(isNotNegative));

// Validators: Use composed predicates to validate data and
// use Either for handling success or error outcomes.
Either<String, String> validateName(UserData user) {
  final response = p.match<String, Either<String, String>>(
    (String v) => Left<String, String>("Invalid name"),
    (String v) => Right<String, String>(v),
  );
  return pipe3(user, getName, pipe2(isValidName, response));
}

Either<String, int> validateAge(UserData user) {
  final response = p.match<int, Either<String, int>>(
    (int v) => Left<String, int>("Invalid Age"),
    (int v) => Right<String, int>(v),
  );
  return pipe3(user, getAge, pipe2(isValidAge, response));
}

// A list of validators.
List<ValidatorRecord> userDataValidators = [
  (key: 'name', validator: validateName),
  (key: 'age', validator: validateAge)
];

// Core logic to validate UserData. Iterates over a list of validators.
// If any validation fails, immediately returns with an error (Left).
// If all validations pass, returns the original user data (Right).
Either<String, UserData> Function(UserData) validateUserData(
        List<ValidatorRecord> validators) =>
    (UserData user) {
      for (var item in validators) {
        final result = item.validator(user);
        if (result is Left<String, dynamic>) {
          return Left(result.value);
        }
      }
      return Right(user);
    };

void main() {
  final john = (name: '', age: 25);
  final bill = (name: 'Bill', age: -1);
  final bob = (name: 'Bob', age: 145);
  final jeff = (name: 'Jeff', age: 34);

  // A flow to process the validation and map the result to a string.
  // This showcases function chaining and composition.
  final parseValue =
      match<dynamic, UserData, String>((left) => '$left', (right) => '$right');

  final message = flow2(validateUserData(userDataValidators), parseValue);

  print(message(john)); // Invalid Name
  print(message(bill)); // Invalid Age
  print(message(bob)); // Invalid Age
  print(message(jeff)); // (age: 34, name: Jeff)
}
