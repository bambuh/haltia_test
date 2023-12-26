typedef FutureResult<S, F> = Future<Result<S, F>>;

sealed class Result<S, F> {
  const Result();
  const factory Result.success({required S value}) = Success;
  const factory Result.failure({required F data}) = Failure;
}

final class Success<S, F> extends Result<S, F> {
  final S value;
  const Success({required this.value});

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => other is Success<S, F> && other.value == value;

  @override
  String toString() => 'Success(value: $value)';
}

final class Failure<S, F> extends Result<S, F> {
  final F data;
  const Failure({required this.data});

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => other is Failure<S, F> && other.data == data;

  @override
  String toString() => 'Failure()';
}

extension ResultExtension<S, F> on Result<S, F> {
  S sureOr(S defaultValue) {
    return switch (this) {
      Success(:final value) => value,
      _ => defaultValue,
    };
  }

  S? maybe() {
    return switch (this) {
      Success(:final value) => value,
      _ => null,
    };
  }
}
