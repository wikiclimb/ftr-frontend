import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/entities/form_input/email.dart';
import '../../../domain/entities/password_recovery_params.dart';
import '../../../domain/usecases/request_password_recovery_email.dart';

part 'password_recovery_bloc.freezed.dart';
part 'password_recovery_event.dart';
part 'password_recovery_state.dart';

/// Manages state for a password recovery email request action.
class PasswordRecoveryBloc
    extends Bloc<PasswordRecoveryEvent, PasswordRecoveryState> {
  PasswordRecoveryBloc({
    required RequestPasswordRecoveryEmail requestPasswordRecoveryEmailUseCase,
  })  : _requestPasswordRecoveryEmailUseCase =
            requestPasswordRecoveryEmailUseCase,
        super(PasswordRecoveryState()) {
    on<_EmailUpdated>(_onEmailUpdated);
    on<_Submit>(_onSubmit);
  }

  final RequestPasswordRecoveryEmail _requestPasswordRecoveryEmailUseCase;

  _onEmailUpdated(_EmailUpdated event, Emitter<PasswordRecoveryState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(email: email, status: Formz.validate([email])));
  }

  _onSubmit(_Submit event, Emitter<PasswordRecoveryState> emit) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        final params = PasswordRecoveryParams(email: state.email.value);
        final result = await _requestPasswordRecoveryEmailUseCase(params);
        result.fold((failure) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }, (r) {
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        });
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
