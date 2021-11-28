import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/entities/image.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/add_node_images/add_node_images_bloc.dart';

void main() {
  final tFiles = BuiltList<XFile>([XFile('aa/bb'), XFile('/ooe/eou')]);
  final tImages = BuiltList<Image>();
  const tName = 'test-name';
  const tDescription = 'test-description';
  const tStatus = AddNodeImagesStatus.sending;
  final tState = AddNodeImagesState(
    files: tFiles,
    name: tName,
    description: tDescription,
    status: tStatus,
  );

  test('empty equality', () async {
    expect(AddNodeImagesState(), AddNodeImagesState());
  });

  test('default values', () async {
    final expected = AddNodeImagesState(
      files: BuiltList(),
      name: '',
      description: '',
      status: AddNodeImagesStatus.initial,
    );
    expect(AddNodeImagesState(), expected);
  });

  test('empty copy with', () async {
    final original = AddNodeImagesState();
    final copy = original.copyWith(
      description: tDescription,
      files: tFiles,
      name: tName,
      status: tStatus,
    );
    expect(copy, tState);
  });

  test('expected props', () {
    expect(tState.props,
        unorderedEquals([tFiles, tName, tDescription, tStatus, tImages]));
  });

  test('status getter', () {
    expect(tState.status, tStatus);
  });
}
