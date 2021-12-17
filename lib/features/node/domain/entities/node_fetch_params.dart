library node_fetch_params;

import 'package:built_value/built_value.dart';

part 'node_fetch_params.g.dart';

/// This class defines the parameters that can be used when fetching [Node].
abstract class NodeFetchParams
    implements Built<NodeFetchParams, NodeFetchParamsBuilder> {
  factory NodeFetchParams([void Function(NodeFetchParamsBuilder) updates]) =
      _$NodeFetchParams;

  NodeFetchParams._();

  // Fields

  int get page;

  @BuiltValueField(wireName: 'per-page')
  int get perPage;

  int? get type;

  @BuiltValueField(wireName: 'parent-id')
  int? get parentId;

  @BuiltValueField(wireName: 'q')
  String? get query;

  Map<String, String> toMap() {
    final params = {
      'page': page.toString(),
      'per-page': perPage.toString(),
    };
    if (query != null) {
      params.addAll({'q': query!});
    }
    if (parentId != null) {
      params.addAll({'parent-id': parentId.toString()});
    }
    if (type != null) {
      params.addAll({'type': type.toString()});
    }
    return params;
  }
}
