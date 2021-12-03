import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/map/presentation/bloc/map_view/map_view_bloc.dart';

import '../../../../../fixtures/area/area_pages.dart';

void main() {
  test('equality', () {
    final tPage = areaPages.first;
    expect(PageAdded(tPage), PageAdded(tPage));
    expect(FailureResponse().props, []);
  });
}
