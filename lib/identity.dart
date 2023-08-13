import 'package:func_dart_core/monoid.dart';

/// Represents a container that wraps a single value.
///
/// An identity monad is a design pattern that allows wrapping a value.
/// It's useful as a basic monad implementation, to understand the monadic structure without any side effects.
class Identity<A> {
  /// The value that this `Identity` instance holds.
  final A value;

  /// Constructs an `Identity` instance that holds the provided [value].
  Identity(this.value);
}

/// Wraps the provided value into an `Identity`.
///
/// This acts as a constructor for the Identity monad, allowing
/// you to wrap values without calling the class constructor directly.
///
/// Example:
/// ```dart
/// final intValue = of(5);
/// final stringValue = of("Hello");
/// ```
Identity<B> of<B>(B value) => Identity<B>(value);

/// Extracts the value contained within the [identity].
///
/// This is a utility function to retrieve the raw value wrapped inside the Identity.
/// You can think of it as a way to perform a "safe unwrap" of the Identity's contents.
///
/// Example:
/// ```dart
/// final wrappedInt = Identity(5);
/// final intValue = extract(wrappedInt); // Returns 5
///
/// final wrappedString = Identity("Hello");
/// final stringValue = extract(wrappedString); // Returns "Hello"
/// ```
A extract<A>(Identity<A> identity) => identity.value;

/// Transforms the value inside an [Identity] using a given function.
///
/// The [map] function applies a function to the encapsulated value
/// inside an [Identity] and wraps the result back into a new [Identity].
///
/// Example:
/// ```dart
/// final id = Identity(5);
/// final result = map<int, int>((x) => x * 2)(id);
/// print(result.value); // Outputs: 10
/// ```
Identity<B> Function(Identity<A>) map<A, B>(B Function(A) f) =>
    (Identity<A> m) => Identity<B>(f(m.value));

/// Flat maps (or binds) the value inside an [Identity] using a given function.
///
/// The [flatMap] function applies a function that returns an [Identity] to
/// the encapsulated value inside an [Identity].
///
/// Example:
/// ```dart
/// final id = Identity(5);
/// final result = flatMap<int, int>((x) => Identity(x + 3))(id);
/// print(result.value); // Outputs: 8
/// ```
Identity<B> Function(Identity<A>) flatMap<A, B>(Identity<B> Function(A) f) =>
    (Identity<A> m) => f(m.value);

/// Applies the function wrapped in an [Identity] to the value inside another [Identity].
///
/// The [ap] function takes a wrapped function inside an [Identity] and
/// applies it to the value of another [Identity], giving a new [Identity] of the result.
///
/// Example:
/// ```dart
/// final idValue = Identity(3);
/// final idFn = Identity<int Function(int)>((x) => x * 2);
/// final result = ap(idFn)(idValue);
/// print(result.value); // Outputs: 6
/// ```
Identity<B> Function(Identity<A>) ap<A, B>(Identity<B Function(A)> f) =>
    (Identity<A> m) => map(f.value)(m);

/// Folds the value within an [Identity] monad.
///
/// Applies a binary function `f` to the initial value and the value wrapped in the [Identity].
/// This function is useful for combining the wrapped value with another value.
///
/// Example:
/// ```dart
/// Identity<int> id = Identity(5);
/// var sum = fold(10, (accum, value) => accum + value);
/// print(sum(id));  // Outputs: 15
/// ```
///
/// [initial] is the initial accumulator value.
/// [f] is the binary function that takes the accumulator and the value wrapped in [Identity] as arguments.
B Function(Identity<A>) fold<A, B>(B initial, B Function(B, A) f) =>
    (Identity<A> m) => f(initial, m.value);

/// An alias to [fold] function.
///
/// Useful for scenarios where "reduce" is a more familiar terminology than "fold".
final reduce = fold;

/// Maps over the value within an [Identity] monad and then folds the result using a given [monoid].
///
/// This function is a combination of a `map` and a `fold`. It first applies the function `f` to
/// the value wrapped in [Identity] and then combines it using the provided monoid's `concat` method.
///
/// Example:
/// ```dart
/// Identity<String> id = Identity("world");
/// var greet = foldMap(MonoidConcat(), (s) => "Hello, " + s + "!");
/// print(greet(id));  // Outputs: "Hello, world!"
/// ```
///
/// [monoid] provides the `empty` value and the binary `concat` operation for folding.
/// [f] is the function that maps over the wrapped value.
M Function(Identity<A>) foldMap<A, M>(BaseMonoid<M> monoid, M Function(A) f) =>
    (Identity<A> id) => monoid.concat(monoid.empty, f(id.value));

// Map<String, dynamic> letFn<A, B>(String name, B Function(A) f, Map<String, A> fa) {
//   // Copy the original map
//   final newMap = Map<String, dynamic>.from(fa);

//   // Add the new property
//   newMap[name] = f(fa);

//   return newMap;
// }

class MergedMap<K, V1, V2> {
  final Map<K, V1> original;
  final Map<K, V2> added;

  MergedMap(this.original, this.added);

  dynamic operator [](K key) {
    return added.containsKey(key) ? added[key] : original[key];
  }
}

MergedMap<String, A, B> letFn<A, B>(
    String name, B Function(Map<String, A> fa) f, Map<String, A> fa) {
  final addedValue = f(fa);
  final addedMap = {name: addedValue};
  return MergedMap<String, A, B>(fa, addedMap);
}
