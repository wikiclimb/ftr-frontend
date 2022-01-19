// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:wikiclimb_flutter_frontend/features/image/presentation/screens/add_node_image_screen.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/add_node_images/add_node_images_bloc.dart';

import '../../../../fixtures/image/images.dart';
import '../../../../fixtures/node/nodes.dart';

class MockAddNodeImagesBloc
    extends MockBloc<AddNodeImagesEvent, AddNodeImagesState>
    implements AddNodeImagesBloc {}

extension on WidgetTester {
  Future<void> pumpIt() {
    return mockNetworkImagesFor(
      () async => pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AddNodeImageScreen(nodes.elementAt(1)),
          ),
        ),
      ),
    );
  }
}

void main() {
  late final AddNodeImagesBloc mockBloc;
  late final GetIt sl;

  setUpAll(() {
    mockBloc = MockAddNodeImagesBloc();
    when(() => mockBloc.state).thenAnswer((_) => AddNodeImagesState());
    sl = GetIt.instance;
    sl.registerFactory<AddNodeImagesBloc>(() => mockBloc);
  });

  testWidgets('widget renders', (tester) async {
    await tester.pumpIt();
    expect(find.byType(AddNodeImageScreen), findsOneWidget);
    expect(
      find.byKey(Key('addNodeImageScreen_selectFromCamera_iconButton')),
      findsOneWidget,
    );
    expect(
      find.byKey(Key('addNodeImageScreen_selectFromCamera_iconButton')),
      findsOneWidget,
    );
  });

  group('error', () {
    setUpAll(() {});

    testWidgets('should display snackbar', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable(
          [
            AddNodeImagesState(),
            AddNodeImagesState(status: AddNodeImagesStatus.error),
          ],
        ),
      );
      when(() => mockBloc.state).thenReturn(
        AddNodeImagesState(
          status: AddNodeImagesStatus.error,
        ),
      );
      await tester.pumpIt();
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('An error happened'), findsOneWidget);
    });
  });

  group('actions', () {
    testWidgets('add from camera', (tester) async {
      await tester.pumpIt();
      final finder = find.byKey(
        Key('addNodeImageScreen_selectFromCamera_iconButton'),
      );
      expect(
        finder,
        findsOneWidget,
      );
      await tester.tap(finder);
    });

    testWidgets('add from gallery', (tester) async {
      await tester.pumpIt();
      final finder = find.byKey(
        Key('addNodeImageScreen_selectFromGallery_iconButton'),
      );
      expect(
        finder,
        findsOneWidget,
      );
      await tester.tap(finder);
    });
  });

  group('loaded', () {
    testWidgets('with images', (tester) async {
      when(() => mockBloc.state).thenReturn(
        AddNodeImagesState(
          status: AddNodeImagesStatus.success,
          images: BuiltList(images),
        ),
      );
      await tester.pumpIt();
      expect(
        find.byKey(Key('addNodeImageScreen_previewUploaded_gridView')),
        findsOneWidget,
      );
    });
  });
}
