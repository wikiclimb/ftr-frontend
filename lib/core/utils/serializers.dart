import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import '../../features/image/data/models/image_model.dart';
import '../../features/node/data/models/node_model.dart';
import '../../features/registration/domain/entities/sign_up_params.dart';
import '../entities/response.dart';

part 'serializers.g.dart';

@SerializersFor([
  NodeModel,
  ImageModel,
  Response,
  SignUpParams,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
