import 'package:equatable/equatable.dart';

class RouteModel extends Equatable {
  final String path;
  final RouteModel? parent;
  const RouteModel({
    required this.path,
    this.parent,
  });

  @override
  List<Object?> get props => [path, parent];

  String get fullPath {
    if (parent == null) {
      return path;
    }
    final lastParentChar = parent?.fullPath[parent!.fullPath.length - 1];
    final firstPathChar = path[0];
    if (lastParentChar == '/' || firstPathChar == '/') {
      return '${parent?.fullPath}$path';
    } else {
      return '${parent?.fullPath}/$path';
    }
  }
}
