/// `Identity` is a wrapper type that holds a single value of any type `A`.
/// This class is typically used in functional programming contexts.
class Identity<A> {
  /// The value that this `Identity` instance holds.
  final A value;

  /// Constructs an `Identity` instance that holds the provided [value].
  Identity(this.value);
}

/// Wraps the given [value] in an `Identity` instance.
/// This is also known as the 'return' operation in monadic terms.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Wrap an integer in the Identity monad
///   Identity<int> number = of(42);
///
///   // Print the value inside the Identity monad
///   print(number.value); // Output: 42
/// }
/// ```
Identity<B> of<B>(B value) {
  return Identity<B>(value);
}

/// Takes an `Identity` instance [m] and a function [f],
/// applies [f] to the value in [m],
/// and wraps the result in a new `Identity` instance.
/// This operation is known as 'map' or 'bind' in functional programming.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create an Identity monad for a string
///   Identity<String> strMonad = of("hello");
///
///   // Map the string to its length
///   Identity<int> lengthMonad = map(strMonad, (str) => str.length);
///
///   // Print the result
///   print(lengthMonad.value); // Output: 5 (Length of the string "hello")
/// }
/// ```
Identity<B> map<A, B>(Identity<A> m, B Function(A) f) {
  return Identity<B>(f(m.value));
}

/// Takes an `Identity` instance [m] and a function [f],
/// applies [f] to the value in [m],
/// and assumes [f] returns an `Identity` instance.
/// This operation is known as 'flatMap', 'chain', or 'bind' in functional programming.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create an Identity monad for an integer
///   Identity<int> numberMonad = of(42);
///
///   // FlatMap the integer to an Identity monad of its double value
///   Identity<double> doubleMonad = flatMap(numberMonad, (num) => of(num * 2.0));
///
///   // Print the result
///   print(doubleMonad.value); // Output: 84.0
/// }
/// ```
Identity<B> flatMap<A, B>(Identity<A> m, Identity<B> Function(A) f) {
  return f(m.value);
}

/// Takes an `Identity` instance [m] and an `Identity` instance [f] that holds a function,
/// applies the function in [f] to the value in [m],
/// and wraps the result in a new `Identity` instance.
/// This operation is known as 'ap' or 'apply' in functional programming.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Create an Identity monad for an integer
///   Identity<int> numberMonad = of(5);
///
///   // Create an Identity monad for a function that adds 10
///   Identity<Function(int)> addTenMonad = of((int x) => x + 10);
///
///   // Apply the function to the integer using 'ap'
///   Identity<int> resultMonad = ap(numberMonad, addTenMonad);
///
///   // Print the result
///   print(resultMonad.value); // Output: 15 (5 + 10)
/// }
/// ```
Identity<B> ap<A, B>(Identity<A> m, Identity<B Function(A)> f) {
  return map(m, f.value);
}
