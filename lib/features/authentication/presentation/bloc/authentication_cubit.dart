import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/authentication_data.dart';
import '../../domain/usecases/fetch_cached.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({required this.fetchCachedUsecase})
      : super(AuthenticationInitial());

  final FetchCached fetchCachedUsecase;

  void fetchCachedData() async {
    emit(AuthenticationLoading());
    final result = await fetchCachedUsecase(NoParams());
    result.fold(
      (failure) {
        emit(AuthenticationError());
      },
      (authData) {
        emit(AuthenticationSuccess(authData));
      },
    );
  }
}
