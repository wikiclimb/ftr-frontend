library page;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'page.g.dart';

/// Collection of paginated items.
///
/// This class represents a page of similar items and metadata
/// that allows work with paginated collections.
abstract class Page<Type> implements Built<Page<Type>, PageBuilder<Type>> {
  factory Page([void Function(PageBuilder<Type>) updates]) = _$Page<Type>;

  Page._();

  // Fields
  /// The page number of this item's page.
  int get pageNumber;

  /// Whether this page is the last page of items.
  bool get isLastPage;

  /// The page number for the next page of items, -1 when there is no next page.
  int get nextPageNumber;

  /// The list of items that this page holds.
  BuiltList<Type> get items;
}
