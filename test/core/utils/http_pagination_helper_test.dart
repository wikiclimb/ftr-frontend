import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:wikiclimb_flutter_frontend/core/utils/http_pagination_helper.dart';

void main() {
  late http.Response tResponse1;
  late http.Response tResponse2;
  late http.Response tResponse3;

  setUp(() {
    tResponse1 = http.Response('[]', 200, headers: {
      'Link': '<https://api.wikiclimb.org/nodes?q=some&page=45>; rel=self, '
          '<https://api.wikiclimb.org/nodes?q=some&page=1>; rel=first, '
          '<https://api.wikiclimb.org/nodes?q=some&page=46>; rel=next, '
          '<https://api.wikiclimb.org/nodes?q=some&page=102>; rel=last'
    });
    tResponse2 = http.Response('[]', 200, headers: {
      'Link': '<https://api.wikiclimb.org/nodes?q=some&page=102>; rel=self, '
          '<https://api.wikiclimb.org/nodes?q=some&page=1>; rel=first, '
          '<https://api.wikiclimb.org/nodes?q=some&page=102>; rel=last'
    });
    tResponse3 = http.Response('[]', 200, headers: {
      'Links': '<https://api.wikiclimb.org/nodes?q=some&page=45>; rel=self, '
          '<https://api.wikiclimb.org/nodes?q=some&page=1>; rel=first, '
          '<https://api.wikiclimb.org/nodes?q=some&page=error>; rel=next, '
          '<https://api.wikiclimb.org/nodes?q=some&page=102>; rel=last'
    });
  });

  test('has next page', () {
    expect(HttpPaginationHelper.hasNextPage(tResponse1), true);
    expect(HttpPaginationHelper.hasNextPage(tResponse2), false);
  });

  test('is last page', () {
    expect(HttpPaginationHelper.isLastPage(tResponse1), false);
    expect(HttpPaginationHelper.isLastPage(tResponse2), true);
  });

  test('page number', () {
    expect(HttpPaginationHelper.pageNumber(tResponse1), 45);
    expect(HttpPaginationHelper.pageNumber(tResponse2), 102);
    expect(HttpPaginationHelper.pageNumber(tResponse3), -1);
  });

  test('next page number', () {
    expect(HttpPaginationHelper.nextPageNumber(tResponse1), 46);
    expect(HttpPaginationHelper.nextPageNumber(tResponse2), -1);
  });

  test('next page number error', () {
    expect(HttpPaginationHelper.nextPageNumber(tResponse3), -1);
  });
}
