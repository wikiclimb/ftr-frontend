import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/image.dart';
import '../repository/image_repository.dart';

/// This use case lets users add [Image]s to an existing [Node].
class AddImagesToNode extends UseCase<BuiltList<Image>, Params> {
  AddImagesToNode(ImageRepository repository) : _repository = repository;

  final ImageRepository _repository;

  @override
  Future<Either<Failure, BuiltList<Image>>> call(params) {
    return _repository.create(params);
  }
}

class Params extends Equatable {
  const Params({
    required this.filePaths,
    required this.nodeId,
    this.description,
    this.name,
  });

  final String? description;
  final List<String> filePaths;
  final String? name;
  final int nodeId;

  @override
  List<Object?> get props => [
        description,
        name,
        nodeId,
        filePaths,
      ];
}
