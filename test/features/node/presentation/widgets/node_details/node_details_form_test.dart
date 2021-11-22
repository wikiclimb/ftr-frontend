// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/node_edit/node_edit_bloc.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/widgets/node_details/node_details_form.dart';

extension on WidgetTester {
  Future<void> pumpForm(NodeEditBloc bloc) {
    return pumpWidget(MaterialApp(
      home: Scaffold(
        body: BlocProvider.value(
          value: bloc,
          child: NodeDetailsForm(),
        ),
      ),
    ));
  }
}

class MockNodeEditBloc extends MockBloc<NodeEditEvent, NodeEditState>
    implements NodeEditBloc {}

main() {
  late NodeEditBloc mockBloc;

  setUp(() {
    mockBloc = MockNodeEditBloc();
    when(() => mockBloc.state).thenAnswer((_) => NodeEditState());
  });

  testWidgets('creates the widget', (WidgetTester tester) async {
    await tester.pumpForm(mockBloc);
    expect(find.byType(NodeDetailsForm), findsOneWidget);
  });

  group('form submission', () {
    testWidgets('displays loading indicator', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          const NodeEditState(status: FormzStatus.submissionInProgress),
          const NodeEditState(status: FormzStatus.submissionSuccess),
        ]),
      );
      when(() => mockBloc.state).thenReturn(
        const NodeEditState(status: FormzStatus.submissionInProgress),
      );
      await tester.pumpForm(mockBloc);
      // If we wait more frames the success state arrives and hides the loader.
      // await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('failure triggers snackbar', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          const NodeEditState(status: FormzStatus.submissionInProgress),
          const NodeEditState(status: FormzStatus.submissionFailure),
        ]),
      );
      when(() => mockBloc.state).thenReturn(
        const NodeEditState(status: FormzStatus.submissionFailure),
      );
      await tester.pumpForm(mockBloc);
      // Wait for the snackbar animations to complete.
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expectLater(find.text('Submission failure'), findsOneWidget);
    });

    testWidgets('success triggers snackbar', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          const NodeEditState(status: FormzStatus.submissionInProgress),
          const NodeEditState(status: FormzStatus.submissionSuccess),
        ]),
      );
      when(() => mockBloc.state).thenReturn(
        const NodeEditState(status: FormzStatus.submissionSuccess),
      );
      await tester.pumpForm(mockBloc);
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expectLater(find.text('Submission success'), findsOneWidget);
    });
  });

  group('input', () {
    testWidgets('name input triggers event', (tester) async {
      const tName = 'gibberish';
      final nameInput = find.byKey(Key('nodeEditForm_nodeNameInput_textField'));
      await tester.pumpForm(mockBloc);
      expect(nameInput, findsOneWidget);
      await tester.enterText(nameInput, tName);
      verify(() => mockBloc.add(NodeNameChanged(tName)));
    });

    testWidgets('description input triggers event', (tester) async {
      const tDescription = 'gibberish';
      final textInput = find.byKey(
        Key('nodeEditForm_nodeDescriptionInput_textField'),
      );
      await tester.pumpForm(mockBloc);
      expect(textInput, findsOneWidget);
      await tester.enterText(textInput, tDescription);
      verify(() => mockBloc.add(NodeDescriptionChanged(tDescription)));
    });
  });

  group('submission', () {
    testWidgets('does not trigger event if form is invalid', (tester) async {
      await tester.pumpForm(mockBloc);
      await tester.tap(find.byKey(
        Key('nodeEditForm_submitButton_elevatedButton'),
      ));
      verifyNever(() => mockBloc.add(NodeSubmissionRequested()));
    });

    testWidgets('if form i valid it does not trigger event', (tester) async {
      when(() => mockBloc.state).thenAnswer(
        (_) => NodeEditState(status: FormzStatus.valid),
      );
      await tester.pumpForm(mockBloc);
      await tester.tap(find.byKey(
        Key('nodeEditForm_submitButton_elevatedButton'),
      ));
      verify(() => mockBloc.add(NodeSubmissionRequested())).called(1);
    });
  });
}
