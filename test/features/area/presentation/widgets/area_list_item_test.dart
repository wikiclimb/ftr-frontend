import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/area_details_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_list_item.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';

import '../../../../fixtures/area/area_nodes.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  late final AuthenticationBloc mockAuthBloc;

  setUpAll(() async {
    mockAuthBloc = MockAuthenticationBloc();
  });

  testWidgets(
    'Test displaying list of screens',
    (tester) async {
      when(() => mockAuthBloc.state).thenAnswer(
        (_) => AuthenticationUnauthenticated(),
      );
      Node tArea = areaNodes.first;
      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          BlocProvider<AuthenticationBloc>(
            create: (context) => mockAuthBloc,
            child: MaterialApp(
              home: Scaffold(
                body: AreaListItem(
                  area: tArea,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text(tArea.name), findsOneWidget);
      expect(find.text(tArea.description!), findsOneWidget);
      expect(find.text(tArea.breadcrumbs![1]), findsOneWidget);
      await tester.tap(find.byType(InkWell).first);
      await mockNetworkImagesFor(() => tester.pumpAndSettle());
      expect(find.byType(AreaDetailsScreen), findsOneWidget);
    },
  );
}
