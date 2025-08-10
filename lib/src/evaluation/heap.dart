import 'instance.dart';

extension type InstanceId(int id) {
  // TODO: consider using a more complex ID generation strategy
  static final seed = InstanceId(0);

  InstanceId operator +(int value) => InstanceId(id + value);
}

class Heap {
  final Map<InstanceId, Instance> _instances = {};
  InstanceId _nextInstanceId = InstanceId.seed;

  InstanceId allocate(Instance instance) {
    final id = _nextInstanceId++;
    _instances[id] = instance;
    return id;
  }

  Instance? get(InstanceId id) => _instances[id];
}
