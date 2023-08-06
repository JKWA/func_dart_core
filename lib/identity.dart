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
Identity<B> of<B>(B value) {
  return Identity<B>(value);
}

/// Takes an `Identity` instance [m] and a function [f],
/// applies [f] to the value in [m],
/// and wraps the result in a new `Identity` instance.
/// This operation is known as 'map' or 'bind' in functional programming.
Identity<B> map<A, B>(Identity<A> m, B Function(A) f) {
  return Identity<B>(f(m.value));
}

/// Takes an `Identity` instance [m] and a function [f],
/// applies [f] to the value in [m],
/// and assumes [f] returns an `Identity` instance.
/// This operation is known as 'flatMap', 'chain', or 'bind' in functional programming.
Identity<B> flatMap<A, B>(Identity<A> m, Identity<B> Function(A) f) {
  return f(m.value);
}

/// Takes an `Identity` instance [m] and an `Identity` instance [f] that holds a function,
/// applies the function in [f] to the value in [m],
/// and wraps the result in a new `Identity` instance.
/// This operation is known as 'ap' or 'apply' in functional programming.
Identity<B> ap<A, B>(Identity<A> m, Identity<B Function(A)> f) {
  return map(m, f.value);
}
