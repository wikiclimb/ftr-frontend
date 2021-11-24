import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wikiclimb_flutter_frontend/features/image/data/models/image_model.dart';
import 'package:wikiclimb_flutter_frontend/features/image/domain/entities/image.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../fixtures/image/image_models.dart';
import '../../../../fixtures/image/images.dart';

void main() {
  group('from json', () {
    test('should return a valid model', () {
      final actual = ImageModel.fromJson(fixture('image/image_model.json'));
      expect(actual, isA<ImageModel>());
      expect(actual, imageModels.first);
    });
  });

  group('to json', () {
    test('returns expected', () {
      final imageModel = imageModels.first;
      final expectedJson = fixture('image/image_model.json');
      // Need to decode to test as Map<String, dynamic>
      expect(jsonDecode(imageModel.toJson()), jsonDecode(expectedJson));
    });
  });

  group('to json and back to dart', () {
    test('model converted to json and back is equal', () {
      final ImageModel imageModel = imageModels.first;
      expect(ImageModel.fromJson(imageModel.toJson()), imageModel);
    });
  });

  group('to image', () {
    test('convert to image', () {
      final Image expected = images.first;
      final actual = imageModels.first;
      expect(
        actual.toImage(),
        expected,
        reason: 'conversion to [Image] should work',
      );
    });
  });

  group('from image', () {
    test('image model from image', () {
      final image = images.elementAt(0);
      final imageModel = imageModels.elementAt(0);
      expect(
        ImageModel.fromImage(image),
        imageModel,
        reason: 'factory from [Image] should work',
      );
    });
  });
}
