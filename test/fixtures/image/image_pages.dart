import 'package:built_collection/built_collection.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/entities/image.dart';

final List<Page<Image>> imagePages = <Page<Image>>[
  Page((p) => p
    ..items = ListBuilder([
      Image((i) => i
        ..id = 1
        ..name = 'image-1'
        ..description = 'image-1-description'
        ..fileName = '03HEH5230D5230T.jpeg'
        ..validated = true
        ..createdBy = 'test-user-2'
        ..createdAt = 1636879203
        ..updatedBy = 'test-user-2'
        ..updatedAt = 1636899403),
      Image((i) => i
        ..id = 2
        ..name = 'image-2'
        ..description = 'image-2-description'
        ..fileName = '03HEH5231D5230T.jpeg'
        ..validated = true
        ..createdBy = 'test-user-1'
        ..createdAt = 1636879203
        ..updatedBy = 'test-user-1'
        ..updatedAt = 1636899403),
    ])
    ..pageNumber = 1
    ..nextPageNumber = 2
    ..isLastPage = false),
  Page((p) => p
    ..items = ListBuilder([])
    ..pageNumber = 2
    ..nextPageNumber = 3
    ..isLastPage = false),
];
