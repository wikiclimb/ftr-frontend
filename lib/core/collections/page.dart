/// Collection of paginated items.
///
/// This class represents a page of similar items and metadata
/// that allows work with paginated collections.
class Page<Type> {
  Page({
    required this.items,
    required this.pageNumber,
    required this.isLastPage,
  });

  /// The page number of this item's page.
  int pageNumber;

  /// Whether this page is the last page of items.
  bool isLastPage;

  /// The list of items that this page holds.
  List<Type> items;
}
