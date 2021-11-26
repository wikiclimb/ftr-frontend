import 'package:wikiclimb_flutter_frontend/features/image/data/models/image_model.dart';

final List<ImageModel> createMultiple201ResponseImageModels = [
  ImageModel((i) => i
    ..id = 1
    ..name = 'image-1'
    ..description = 'image-1-description'
    ..fileName = '03HEH5230D5230T.jpeg'
    ..validated = true
    ..createdBy = 'test-user-2'
    ..createdAt = 1636879203
    ..updatedBy = 'test-user-2'
    ..updatedAt = 1636899403),
  ImageModel((i) => i
    ..id = 2
    ..name = 'image-2'
    ..description = 'image-2-description'
    ..fileName = '13HEH5231D5230T.jpeg'
    ..validated = true
    ..createdBy = 'test-user-1'
    ..createdAt = 1636879303
    ..updatedBy = 'test-user-1'
    ..updatedAt = 1636879403),
];
