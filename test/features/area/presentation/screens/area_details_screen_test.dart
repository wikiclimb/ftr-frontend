// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:wikiclimb_flutter_frontend/core/widgets/decoration/photo_sliver_app_bar.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/screens/area_details_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/area/presentation/widgets/area_details_list.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/domain/entities/authentication_data.dart';
import 'package:wikiclimb_flutter_frontend/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/widgets/node_sliver_image_list.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/entities/node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/domain/usecases/edit_node.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/screens/edit_node_screen.dart';

import '../../../../fixtures/area/area_nodes.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockEditNode extends Mock implements EditNode {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

extension on WidgetTester {
  Future<void> pumpDetailsScreen({
    required Node area,
    required AuthenticationBloc mockAuthBloc,
  }) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockAuthBloc,
          child: Scaffold(
            body: AreaDetailsScreen(area: area),
          ),
        ),
      ),
    );
  }
}

void main() {
  late final MockAuthenticationBloc mockAuthBloc;
  const tAuthData = AuthenticationData(
    token: 'token',
    id: 123,
    username: 'test-username',
  );

  setUpAll(() async {
    final sl = GetIt.instance;
    sl.registerLazySingleton<NodeEditBloc>(() => NodeEditBloc(MockEditNode()));
    registerFallbackValue(FakeAuthenticationState());
    mockAuthBloc = MockAuthenticationBloc();
    when(() => mockAuthBloc.state)
        .thenAnswer((_) => AuthenticationAuthenticated(tAuthData));
  });

  testWidgets('screen renders', (tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpDetailsScreen(
        area: areaNodes.first,
        mockAuthBloc: mockAuthBloc,
      ),
    );
    expect(find.byType(AreaDetailsScreen), findsOneWidget);
  });

  testWidgets('app bar renders using parameter data', (tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpDetailsScreen(
        area: areaNodes.elementAt(5),
        mockAuthBloc: mockAuthBloc,
      ),
    );
    expect(find.byType(PhotoSliverAppBar), findsOneWidget);
    expect(find.byType(AreaDetailsList), findsOneWidget);
    expect(find.byIcon(Icons.star), findsNWidgets(3));
    expect(find.byIcon(Icons.star_half), findsNothing);
  });

  group('edit fab', () {
    testWidgets('displays for authenticated users', (tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpDetailsScreen(
          area: areaNodes.elementAt(5),
          mockAuthBloc: mockAuthBloc,
        ),
      );
      expect(find.byKey(Key('areaDetailsScreen_editArea_fab')), findsOneWidget);
    });

    testWidgets('does not display for guest users', (tester) async {
      when(() => mockAuthBloc.state)
          .thenAnswer((_) => AuthenticationUnauthenticated());
      await mockNetworkImagesFor(
        () => tester.pumpDetailsScreen(
          area: areaNodes.elementAt(5),
          mockAuthBloc: mockAuthBloc,
        ),
      );
      expect(find.byKey(Key('areaDetailsScreen_editArea_fab')), findsNothing);
    });

    testWidgets('navigates to edit page on tap', (tester) async {
      when(() => mockAuthBloc.state)
          .thenAnswer((_) => AuthenticationAuthenticated(tAuthData));
      await mockNetworkImagesFor(
        () => tester.pumpDetailsScreen(
          area: areaNodes.first,
          mockAuthBloc: mockAuthBloc,
        ),
      );
      final fabFinder = find.byKey(Key('areaDetailsScreen_editArea_fab'));
      expect(fabFinder, findsOneWidget);
      await tester.tap(fabFinder);
      await tester.pumpAndSettle();
      expect(find.byType(EditNodeScreen), findsOneWidget);
    });

    testWidgets('renders node images', (tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpDetailsScreen(
          area: areaNodes.first,
          mockAuthBloc: mockAuthBloc,
        ),
      );
      expect(find.byType(NodeSliverImageList), findsOneWidget);
    });
  });
}
