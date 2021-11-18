import 'package:http/http.dart';

/// Helper functionality related with http requests and responses.
class HttpPaginationHelper {
  /// Check if there is a next page of data.
  static bool hasNextPage(Response response) {
    final header = _getLinkHeader(response);
    if (header != null) {
      return header.contains('rel=next');
    }
    return false;
  }

  /// Check if the response contains the last page of data.
  static bool isLastPage(Response response) => !hasNextPage(response);

  /// Get the page number for the response.
  static int pageNumber(Response response) {
    final headerLink = _getLinkHeader(response);
    if (headerLink != null) {
      List<String> rawLinks = headerLink.split(',');
      final url = rawLinks
          .singleWhere((link) => link.contains('rel=self'))
          .split(';')[0]
          .replaceAll(RegExp('[<>]'), '')
          .trim();
      final sections = url.split(RegExp(r'(\?|&)'));
      final String page = sections.singleWhere(
        (element) => element.contains(RegExp(r'^(?<!per-)page=')),
      );
      final pageNumber = page.replaceAll('page=', '');
      return int.tryParse(pageNumber) ?? -1;
    }
    return -1;
  }

  /// Return the number of the next page corresponding to this request.
  static int nextPageNumber(Response response) =>
      hasNextPage(response) ? pageNumber(response) + 1 : -1;

  /// Get the 'Link' header from a [Response] object.
  static String? _getLinkHeader(Response response) {
    final headers = response.headers;
    return headers['link'] ?? headers['Link'];
  }
}
