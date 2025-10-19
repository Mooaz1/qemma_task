part of 'splash_cubit.dart';

enum SplashStateStatus {
  initial,
  loading,
  finished,
  error,
}

extension SplashStateX on SplashState {
  bool get isInitial => status == SplashStateStatus.initial;
  bool get isLoading => status == SplashStateStatus.loading;
  bool get isFinished => status == SplashStateStatus.finished;
  bool get isError => status == SplashStateStatus.error;
}

@immutable
class SplashState {
  final SplashStateStatus status;
  final String? errorMessage;

  const SplashState({
    this.status = SplashStateStatus.initial,
    this.errorMessage,
  });

  SplashState copyWith({
    SplashStateStatus? status,
    String? errorMessage,
  }) {
    return SplashState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SplashState &&
        other.status == status &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => status.hashCode ^ errorMessage.hashCode;
}
