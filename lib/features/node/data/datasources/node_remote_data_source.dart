import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node_fetch_params.dart';

import '../../../../core/authentication/authentication_provider.dart';
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
  Future<Page<NodeModel>> fetchAll(NodeFetchParams params);

  /// Calls the node POST endpoint with the given parameters.
  ///
  /// Throws a [ServerException] for server response codes.
  /// Throws a [NetworkException] for network errors.
  Future<NodeModel> create(NodeModel nodeModel);

  /// Calls the node PATCH endpoint with the given parameters.
  ///
  /// Throws a [ServerException] for server response codes.
  /// Throws a [NetworkException] for network errors.
  Future<NodeModel> update(NodeModel nodeModel);
}

/// Provides implementations to the methods exposed on [NodeRemoteDataSource].
class NodeRemoteDataSourceImpl extends NodeRemoteDataSource
    with RequestHandler {
  NodeRemoteDataSourceImpl({
    required this.client,
    required this.authenticationProvider,
  });

  final AuthenticationProvider authenticationProvider;
  final http.Client client;
  final endpoint = 'nodes';

  @override
  Future<NodeModel> create(NodeModel nodeModel) async {
    final uri = Uri.https(EnvironmentConfig.apiUrl, endpoint);
    final response = await handleRequest(
      client: client,
      uri: uri,
      method: 'post',
      headers: {
        'Content-Type': 'Application/json',
        'Authorization':
            'Bearer ' + (authenticationProvider.authenticationData?.token ?? '')
      },
      body: nodeModel.toJson(),
    );
    try {
      return NodeModel.fromJson(response.body)!;
    } catch (_) {
      throw const ApplicationException();
    }
  }

  @override
  Future<Page<NodeModel>> fetchAll(NodeFetchParams params) async {
    final uri = Uri.https(EnvironmentConfig.apiUrl, endpoint, params.toMap());
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
    } catch (_) {
      throw const ApplicationException();
    }
  }

  @override
  Future<NodeModel> update(NodeModel nodeModel) async {
    final uri =
        Uri.https(EnvironmentConfig.apiUrl, '$endpoint/${nodeModel.id}');
    final response = await handleRequest(
      client: client,
      uri: uri,
      method: 'patch',
      headers: {
        'Content-Type': 'Application/json',
        'Authorization':
            'Bearer ' + (authenticationProvider.authenticationData?.token ?? '')
      },
      body: nodeModel.toJson(),
    );
    try {
      return NodeModel.fromJson(response.body)!;
    } catch (_) {
      throw const ApplicationException();
    }
  }
}
