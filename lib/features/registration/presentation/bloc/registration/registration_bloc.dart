import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../domain/entities/sign_up_params.dart';
import '../../../domain/usecases/sign_up_with_email_password.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({required SignUpWithEmailPassword signUp})
      : _signUp = signUp,
        super(const RegistrationState()) {
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationUsernameChanged>(_onUsernameChanged);
    on<RegistrationPasswordChanged>(_onPasswordChanged);
    on<RegistrationPasswordRepeatChanged>(_onPasswordRepeatChanged);
    on<RegistrationSubmitted>(_onSubmitted);
  }

  final SignUpWithEmailPassword _signUp;

  void _onEmailChanged(
    RegistrationEmailChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: _validate(email: email),
    ));
  }

  void _onUsernameChanged(
    RegistrationUsernameChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(
      username: username,
      status: _validate(username: username),
    ));
  }

  void _onPasswordChanged(
    RegistrationPasswordChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: _validate(password: password),
    ));
  }

  void _onPasswordRepeatChanged(
    RegistrationPasswordRepeatChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final passwordRepeat = Password.dirty(event.passwordRepeat);
    // TODO Pass a message about the problem.
    emit(state.copyWith(
        passwordRepeat: passwordRepeat,
        status: _validate(passwordRepeat: passwordRepeat)));
  }

  void _onSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        final result = await _signUp(SignUpParams((p) => p
          ..email = state.email.value
          ..username = state.username.value
          ..password = state.password.value));
        result.fold(
          (failure) => throw (failure),
          (r) {
            emit(state.copyWith(status: FormzStatus.submissionSuccess));
          },
        );
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }

  // Extract the validation logic to avoid copying property names
  // in each validation call.
  FormzStatus _validate({
    Email? email,
    Username? username,
    Password? password,
    Password? passwordRepeat,
  }) {
    return Formz.validate([
      email ?? state.email,
      username ?? state.username,
      password ?? state.password,
      passwordRepeat ?? state.passwordRepeat,
    ]);
  }
}
