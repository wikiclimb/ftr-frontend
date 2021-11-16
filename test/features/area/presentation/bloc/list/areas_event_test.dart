import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/bloc/list/areas_bloc.dart';

import '../../../../../fixtures/area/area_pages.dart';

void main() {
  test('equality', () {
    final tPage = areaPages.first;
    expect(PageAdded(tPage), PageAdded(tPage));
    expect(FailureResponse().props, []);
  });
}
