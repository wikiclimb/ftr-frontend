import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wikiclimb_flutter_frontend/core/error/failure.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/usecases/log_in_with_username_password.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.loginUsecase}) : super(LoginInitial()) {
    on<LoginRequested>(onLoginRequested);
  }

  static const loginFailedMessage = 'Wrong username or password';
  static const serverNetworkError = 'There was an error, please try again';
  static const undefinedError = 'Something went wrong';

  final LogInWithUsernamePassword loginUsecase;

  /// Handle LoginRequested events.
  void onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    // Delegate login to the usecase.
    final result = await loginUsecase(
      Params(
        username: event.username,
        password: event.password,
      ),
    );
    result.fold(
      (failure) {
        String message = undefinedError;
        if (failure is UnauthorizedFailure) {
          message = loginFailedMessage;
        } else if (failure is ServerFailure) {
          message = serverNetworkError;
        }
        emit(LoginError(message: message));
      },
      (authenticationData) => emit(LoginSuccess()),
    );
  }
}
