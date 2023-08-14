import 'package:func_dart_core/either.dart';
import 'package:func_dart_core/function.dart';
import 'package:func_dart_core/nonemptylist.dart' as nel;
import 'package:func_dart_core/predicate.dart' as p;

typedef UserData = ({String name, int age});
typedef Error = nel.NonEmptyList<String>;
typedef ValidationResult<T> = Either<Error, T>;
typedef Validator<T> = ValidationResult<T> Function(T p1);

// Lenses: These are "getters" that allow us to focus on specific fields of a data structure.
String getName(UserData data) => data.name;
int getAge(UserData data) => data.age;

// Predicates: These are functions that test a certain condition and return a boolean.
bool isNegative(int value) => value < 0;
bool isZero(int value) => value == 0;
bool isEmpty(String value) => value.isEmpty;

// Higher-order functions: These are functions that return another function, providing flexibility.
p.Predicate<int> isPositive = p.and<int>(p.not(isNegative))(p.not(isZero));

p.Predicate<int> isLessThan(int upperBound) {
  return (int value) => value < upperBound;
}

// Constructing a validator using predicates and error messages.
Validator<T> Function(String) validate<T>(p.Predicate<T> predicate) =>
    (String errorMsg) => (T value) => predicate(value)
        ? Right<Error, T>(value)
        : Left<Error, T>(nel.of([errorMsg]));

// Apply a sequence of validators, collecting errors along the way.
Validator<T> applySequentially<T>(List<Validator<T>> validators) => (T value) {
      final errors = <String>[];

      for (var validator in validators) {
        final result = validator(value);
        if (result is Left<Error, T>) {
          errors.addAll(result.value);
        }
      }

      return errors.isEmpty ? Right(value) : Left(nel.of(errors));
    };

// Define specific validators for our fields using the higher-order functions and predicates.
final validatePositive = validate(isPositive)("Age must be positive");
final validateLessThan120 =
    validate(isLessThan(120))("Age must be less than 120");
final validateNotEmpty = validate(p.not(isEmpty))("Name cannot be empty");

// Combine multiple validators into a single validator.
final positiveLess120 =
    applySequentially([validatePositive, validateLessThan120]);

// Constructed validators for UserData.
Validator<UserData> validateUserAge = (UserData user) {
  return pipe4(
      user,
      getAge,
      positiveLess120,
      match<Error, int, ValidationResult<UserData>>(
          (error) => Left(error), (_) => Right(user)));
};

Validator<UserData> validateUserName = (UserData user) {
  return pipe4(
      user,
      getName,
      validateNotEmpty,
      match<Error, String, ValidationResult<UserData>>(
          (error) => Left(error), (_) => Right(user)));
};

// Helper function to transform validation results into readable strings.
final parseToString =
    match((left) => 'Fail: $left', (right) => 'Success: $right');

// Define the final pipeline: validate and then transform the result.
final parseValidUser = flow2(
    applySequentially([validateUserAge, validateUserName]), parseToString);

void main() {
  // Sample Users:
  final amara = (name: 'Amara', age: 34);
  final takashi = (name: 'Takashi', age: 0);
  final esra = (name: 'Esra', age: 22);
  final xiomara = (name: '', age: 300);

  // Use our pipeline to validate and print results for each user.

  print(parseValidUser(amara)); // Success: (age: 34, name: Amara)
  print(parseValidUser(takashi)); // Fail: [Age must be positive]
  print(parseValidUser(esra)); // Fail: [Name cannot be empty]
  print(parseValidUser(
      xiomara)); // Fail: [Age must be less than 120, Name cannot be empty]
}
