import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/core/collections/page.dart';

void main() {
  ListBuilder<String> items =
      BuiltList<String>(['one', 'two', 'three']).toBuilder();

  test('create', () {
    final tPage = Page<String>((p) => p
      ..pageNumber = 1
      ..isLastPage = false
      ..nextPageNumber = 2
      ..items = items);
    final tClone = tPage.rebuild((p0) => p0..items = items);
    expect(tPage, isA<Page>());
    expect(tClone, tPage);
  });
}
