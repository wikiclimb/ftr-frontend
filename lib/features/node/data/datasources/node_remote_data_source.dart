import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;

import '../../../../core/collections/page.dart';
import '../../../../core/environment/environment_config.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/utils/http_pagination_helper.dart';
import '../models/node_model.dart';

/// Remote data source for node data.
abstract class NodeRemoteDataSource {
  /// Calls the node GET endpoint with the given parameters
  ///
  /// Throws a [ServerException] for server response codes.
  /// Throws a [NetworkException] for network errors.
  Future<Page<NodeModel>> fetchAll(Map<String, dynamic>? params);
}

/// Provides implementations to the methods exposed on [NodeRemoteDataSource].
class NodeRemoteDataSourceImpl extends NodeRemoteDataSource {
  NodeRemoteDataSourceImpl({required this.client});

  final http.Client client;
  final endpoint = 'nodes';

  @override
  Future<Page<NodeModel>> fetchAll(Map<String, dynamic>? params) async {
    try {
      final url = Uri.https(EnvironmentConfig.apiUrl, endpoint, params);
      final response = await client.get(url);
      switch (response.statusCode) {
        case 200:
          final jsonMap = jsonDecode(response.body);
          return Page<NodeModel>((p) => p
            ..items = ListBuilder(jsonMap.map(
              (n) => NodeModel.fromJson(jsonEncode(n)),
            ))
            ..pageNumber = HttpPaginationHelper.pageNumber(response)
            ..nextPageNumber = HttpPaginationHelper.nextPageNumber(response)
            ..isLastPage = HttpPaginationHelper.isLastPage(response));
        case 401:
          throw UnauthorizedException();
        case 403:
          throw ForbiddenException();
        default:
          // We got a response from the server but not one of the expected ones.
          throw ServerException();
      }
    } on UnauthorizedException {
      throw UnauthorizedException();
    } on ForbiddenException {
      throw ForbiddenException();
    } on ServerException {
      throw ServerException();
    } catch (_) {
      throw NetworkException();
    }
  }
}
