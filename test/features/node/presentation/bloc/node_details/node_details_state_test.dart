import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_details/node_details_bloc.dart';

main() {
  test('value equality should be working', () {
    expect(NodeDetailsInitial(), NodeDetailsInitial());
  });
}
