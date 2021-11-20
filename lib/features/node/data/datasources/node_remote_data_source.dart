import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;

import '../../../../core/collections/page.dart';
import '../../../../core/environment/environment_config.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/network/request_handler.dart';
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
class NodeRemoteDataSourceImpl extends NodeRemoteDataSource
    with RequestHandler {
  NodeRemoteDataSourceImpl({required this.client});

  final http.Client client;
  final endpoint = 'nodes';

  @override
  Future<Page<NodeModel>> fetchAll(Map<String, dynamic>? params) async {
    final uri = Uri.https(EnvironmentConfig.apiUrl, endpoint, params);
    final response = await handleRequest(client: client, uri: uri);
    try {
      final jsonMap = jsonDecode(response.body);
      return Page<NodeModel>((p) => p
        ..items = ListBuilder(jsonMap.map(
          (n) => NodeModel.fromJson(jsonEncode(n)),
        ))
        ..pageNumber = HttpPaginationHelper.pageNumber(response)
        ..nextPageNumber = HttpPaginationHelper.nextPageNumber(response)
        ..isLastPage = HttpPaginationHelper.isLastPage(response));
    } catch (e) {
      throw ApplicationException();
    }
  }
}
