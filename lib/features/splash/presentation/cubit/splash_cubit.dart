import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState());
  Future<void> startSplash() async {
    emit(state.copyWith(status: SplashStateStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(status: SplashStateStatus.finished));
    } catch (e) {
      emit(
        state.copyWith(
          status: SplashStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
