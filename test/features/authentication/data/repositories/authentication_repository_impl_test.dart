import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:wikiclimb_flutter_frontend/core/platform/network_info.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/data/repositories/authentication_repository_impl.dart';

import 'authentication_repository_impl_test.mocks.dart';

@GenerateMocks([
  AuthenticationRemoteDataSource,
  AuthenticationLocalDataSource,
  NetworkInfo,
])
void main() {
  late AuthenticationRepositoryImpl repository;
  late MockAuthenticationRemoteDataSource mockRemoteDataSource;
  late MockAuthenticationLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockAuthenticationRemoteDataSource();
    mockLocalDataSource = MockAuthenticationLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthenticationRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
}
