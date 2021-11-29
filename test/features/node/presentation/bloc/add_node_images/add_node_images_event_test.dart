import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wikiclimb_flutter_frontend/features/node/presentation/bloc/add_node_images/add_node_images_bloc.dart';

import '../../../../../fixtures/image/xfiles.dart';
import '../../../../../fixtures/node/nodes.dart';

void main() {
  final tFile = xFiles.first;
  final tFiles = BuiltList<XFile>([tFile]);
  final tNode = nodes.first;
  test('value comparisons', () {
    expect(
      ImagesSelected(files: tFiles, node: tNode),
      ImagesSelected(files: tFiles, node: tNode),
    );
  });

  test('props', () {
    expect(
      ImagesSelected(files: tFiles, node: tNode).props,
      unorderedEquals([tNode, tFiles]),
    );
  });
}
