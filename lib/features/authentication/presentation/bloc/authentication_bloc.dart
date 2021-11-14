import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/authentication_data.dart';
import '../../domain/usecases/authenticate.dart';
import '../../domain/usecases/logout.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// AuthenticationBloc manages the application authentication state.
///
/// This class should only interact with authentication use cases and
/// expose events to the views.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required Authenticate usecase, required Logout logout})
      : _usecase = usecase,
        _logout = logout,
        super(AuthenticationInitial()) {
    on<AuthenticationOk>((event, emit) {
      emit(AuthenticationAuthenticated(event.authenticationData));
    });
    on<AuthenticationKo>((event, emit) {
      emit(AuthenticationUnauthenticated());
    });
    on<AuthenticationRequested>((event, emit) {
      // Ignore the call return, result will be pushed to the stream.
      _usecase();
    });
    on<LogoutRequested>((event, emit) {
      // Ignore the call return, result will be pushed to the stream.
      _logout(NoParams());
    });

    _subscription = _usecase.subscribe.listen((either) {
      either.fold(
        (failure) => add(AuthenticationKo()),
        (authenticationData) => add(AuthenticationOk(authenticationData)),
      );
    });
  }

  final Authenticate _usecase;
  final Logout _logout;
  late StreamSubscription<Either<Failure, AuthenticationData>> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
