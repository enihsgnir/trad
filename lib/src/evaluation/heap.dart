import 'instance.dart';

extension type InstanceId(int value) {}

class Heap {
  final Map<InstanceId, Instance> _instances = {};
  InstanceId _nextInstanceId = InstanceId(0);

  InstanceId _allocateInstanceId() {
    final id = _nextInstanceId;
    _nextInstanceId = InstanceId(id.value + 1);
    return id;
  }

  InstanceId allocate(Instance instance) {
    final id = _allocateInstanceId();
    _instances[id] = instance;
    return id;
  }

  Instance? get(InstanceId id) => _instances[id];
}
