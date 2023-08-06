/// `Option` is a type representing the presence or absence of a value `A`.
/// This class is part of the Option type system used in functional programming
/// that is an alternative to using null. It can be one of two subclasses: `Some` and `None`.
sealed class Option<A> {
  const Option();
}

/// `Some` is a subclass of `Option` indicating that there is a value present.
/// It encapsulates or "wraps" that value.
class Some<A> extends Option<A> {
  /// The value that this `Some` instance holds.
  final A value;

  /// Constructs a `Some` instance that holds the provided [value].
  Some(this.value);
}

/// `None` is a subclass of `Option` indicating the absence of a value.
/// It is used where in other languages you might find null or undefined.
class None<A> extends Option<A> {
  const None();
}

/// Wraps the given [value] in a `Some`, indicating the presence of a value.
Option<B> of<B>(B value) {
  return Some<B>(value);
}

/// Applies the function [f] to the value in the `Option` [option],
/// if it is a `Some`. If [option] is `None`, returns `None`.
/// This operation is known as 'map' in functional programming.
Option<B> map<A, B>(Option<A> option, B Function(A) f) {
  if (option is Some<A>) {
    return Some<B>(f(option.value));
  } else {
    return None<B>();
  }
}

/// Applies the function [f] to the value in the `Option` [option],
/// if it is a `Some`, and assumes [f] returns an `Option`.
/// If [option] is `None`, returns `None`.
/// This operation is known as 'flatMap', 'chain', or 'bind' in functional programming.
Option<B> flatMap<A, B>(Option<A> option, Option<B> Function(A) f) {
  if (option is Some<A>) {
    return f(option.value);
  } else {
    return None<B>();
  }
}

/// Applies the function wrapped in an `Option` [fOpt] to the value in the `Option` [m],
/// if both [fOpt] and [m] are `Some`, and wraps the result in an `Option`.
/// If either [fOpt] or [m] is `None`, returns `None`.
/// This operation is known as 'ap' or 'apply' in functional programming.
Option<B> ap<A, B>(Option<B Function(A)> fOpt, Option<A> m) {
  return flatMap(fOpt, (B Function(A) f) {
    return map(m, f);
  });
}
