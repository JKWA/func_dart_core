import 'package:func_dart_core/either.dart';
import 'package:func_dart_core/function.dart';
import 'package:func_dart_core/nonemptylist.dart' as nel;
import 'package:func_dart_core/predicate.dart' as p;

/*
 * Why use NonEmptyList for errors?
 * - We can accumulate multiple errors.
 * - Ensure at least one error is present; an empty list doesn't make sense for errors.
 */
typedef Error = nel.NonEmptyList<String>;
typedef Validator<T> = Either<Error, T> Function(T p1);

// Direct functions
bool isNegative(int value) => value < 0;
bool isZero(int value) => value == 0;
bool isEven(int value) => value % 2 == 0;

// Higher-order functions
p.Predicate<int> isPositive = p.and<int>(p.not(isNegative))(p.not(isZero));
p.Predicate<int> isLessThan(int upperBound) {
  return (int value) => value < upperBound;
}

// Higher-order function constructing a validator with predicate and error message
Validator<T> Function(String) validate<T>(p.Predicate<T> predicate) =>
    (String errorMsg) => (T value) => predicate(value)
        ? Right<Error, T>(value)
        : Left<Error, T>(nel.of([errorMsg]));

// Higher-order function that sequentially applies a list of validators
// It accumulates any errors produced by each validator
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

// Validators
final validateIsOdd = validate(p.not(isEven))("Must be odd");
final validatePositive = validate(isPositive)("Must be positive");
final validateLessThan100 = validate(isLessThan(100))("Must be less than 100");

// Combined Validators using the sequential application
final positiveAndOdd = applySequentially([validateIsOdd, validatePositive]);
final positiveOddLess100 =
    applySequentially([validateIsOdd, validatePositive, validateLessThan100]);

// Higher-order function to parse the Either type into a readable string
final parseToString =
    match((left) => 'Fail: $left', (right) => 'Success: $right');

// Pipelines: Combine validation logic with the formatting function
final parsePositiveAndOdd = flow2(positiveAndOdd, parseToString);
final parsePositiveAndOddAndLess100 = flow2(positiveOddLess100, parseToString);

void main() {
  print(parsePositiveAndOdd(-1)); // Fail: [Must be positive]
  print(parsePositiveAndOdd(2)); // Fail: [Must be odd]
  print(parsePositiveAndOdd(-2)); // Fail: [Must be odd, Must be positive]
  print(parsePositiveAndOdd(1)); // Success: 1

  print(parsePositiveAndOddAndLess100(98)); // Fail: [Must be odd]
  print(parsePositiveAndOddAndLess100(99)); // Success: 99
  print(parsePositiveAndOddAndLess100(
      100)); // Fail: [Must be odd, Must be less than 100]
  print(parsePositiveAndOddAndLess100(101)); // Fail: [Must be less than 100]
}
