import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecases/log_in_with_username_password.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.loginUsecase}) : super(LoginInitial()) {
    on<LoginRequested>(onLoginRequested);
  }

  static const loginFailedMessage = 'Wrong username or password';
  static const networkError = 'Could not connect to the server, '
      'are you connected to the Internet?';
  static const serverError = 'There was an error, please try again';
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
          message = serverError;
        } else if (failure is NetworkFailure) {
          message = networkError;
        }
        emit(LoginError(message: message));
      },
      (authenticationData) => emit(LoginSuccess()),
    );
  }
}
