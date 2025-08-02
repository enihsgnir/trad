import 'instance.dart';

class Heap {
  final Map<int, Instance> _instances = {};
  // TODO: use `InstanceId` instead of `int` for better type safety
  int _nextInstanceId = 0;

  int allocate(Instance instance) {
    final id = _nextInstanceId++;
    _instances[id] = instance;
    return id;
  }

  Instance? get(int id) => _instances[id];
}
