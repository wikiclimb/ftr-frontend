import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;

import '../../../../core/authentication/authentication_provider.dart';
import '../../../../core/collections/page.dart';
import '../../../../core/environment/environment_config.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/network/request_handler.dart';
import '../../../../core/utils/http_pagination_helper.dart';
import '../models/image_model.dart';

/// Remote data source for image data.
///
/// Handles fetching the data from the main server.
abstract class ImageRemoteDataSource {
  /// Calls the image GET endpoint with the given parameters
  ///
  /// Throws a [ServerException] for server response codes.
  /// Throws a [NetworkException] for network errors.
  Future<Page<ImageModel>> fetchAll(Map<String, dynamic>? params);
}

/// Provides implementations for the methods exposed on [ImageRemoteDataSource].
class ImageRemoteDataSourceImpl
    with RequestHandler
    implements ImageRemoteDataSource {
  ImageRemoteDataSourceImpl({
    required this.authenticationProvider,
    required this.client,
  });

  final AuthenticationProvider authenticationProvider;
  final http.Client client;
  final endpoint = 'images';

  @override
  Future<Page<ImageModel>> fetchAll(Map<String, dynamic>? params) async {
    final uri = Uri.https(EnvironmentConfig.apiUrl, endpoint, params);
    final response = await handleRequest(client: client, uri: uri);
    try {
      final jsonMap = jsonDecode(response.body);

      final result = Page<ImageModel>((p) => p
        ..items = ListBuilder(jsonMap.map(
          (n) => ImageModel.fromJson(jsonEncode(n)),
        ))
        ..pageNumber = HttpPaginationHelper.pageNumber(response)
        ..nextPageNumber = HttpPaginationHelper.nextPageNumber(response)
        ..isLastPage = HttpPaginationHelper.isLastPage(response));
      return result;
    } catch (_) {
      throw ApplicationException();
    }
  }
}
