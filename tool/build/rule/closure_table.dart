import 'package:collection/collection.dart';
import 'package:trad/src/syntactic_analysis/rule_symbol.dart';

import 'grammar.dart';
import 'production.dart';

class Item {
  final Production rule;
  final int dotIndex;
  final Set<Terminal> lookAheads;

  Item(
    this.rule,
    this.dotIndex, [
    Set<Terminal>? lookAheads,
  ]) : lookAheads = lookAheads ?? {};

  bool get isComplete => dotIndex == rule.rhs.length;
  RuleSymbol get symbolAfterDot => rule.rhs[dotIndex];

  Set<Item> derive() {
    if (isComplete) {
      return {};
    }

    final firstSet = grammar.collectFirsts(rule.rhs.sublist(dotIndex + 1));

    final newLookAheads = <Terminal>{};
    newLookAheads.addAll(firstSet.where((e) => e != epsilon));
    if (firstSet.contains(epsilon)) {
      newLookAheads.addAll(lookAheads);
    }

    final items = productions
        .where((production) => production.lhs == symbolAfterDot)
        .map((production) => Item(production, 0))
        .toSet();

    for (final item in items) {
      item.lookAheads.addAll(newLookAheads);
    }

    return items;
  }

  Item? afterShift() {
    if (isComplete) {
      return null;
    }
    return Item(rule, dotIndex + 1, lookAheads);
  }

  bool mergeInto(Set<Item> items) {
    final item = items.lookup(this);
    if (item != null) {
      return item.lookAheads.insertAll(lookAheads);
    }
    return items.add(this);
  }

  @override
  bool operator ==(Object other) {
    return other is Item && rule == other.rule && dotIndex == other.dotIndex;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, rule, dotIndex);
  }
}

class Kernel {
  final Set<Item> items;
  final Set<Item> closure;
  final Map<RuleSymbol, int> gotos = {};

  Kernel(this.items) : closure = {...items};

  @override
  bool operator ==(Object other) {
    return other is Kernel &&
        const SetEquality<Item>().equals(items, other.items);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, const SetEquality<Item>().hash(items));
  }
}

class ClosureTable {
  final List<Kernel> kernels = [];

  ClosureTable() {
    initKernels();
    initClosure();
  }

  void initKernels() {
    final item = Item(productions.first, 0, {eof});
    final kernel = Kernel({item});
    kernels.add(kernel);
  }

  void initClosure() {
    bool changed;

    do {
      changed = false;

      for (int i = 0; i < kernels.length; i++) {
        updateClosure(kernels[i].closure);
        changed |= addGotos(kernels[i]);
      }
    } while (changed);
  }

  void updateClosure(Set<Item> closure) {
    bool changed;

    do {
      changed = false;

      for (int i = 0; i < closure.length; i++) {
        final items = closure.elementAt(i).derive();
        for (final item in items) {
          changed |= item.mergeInto(closure);
        }
      }
    } while (changed);
  }

  bool addGotos(Kernel kernel) {
    bool changed = false;

    final newKernels = <RuleSymbol, Set<Item>>{};
    for (final item in kernel.closure) {
      final newItem = item.afterShift();
      if (newItem == null) {
        continue;
      }

      final newKernel = newKernels.putIfAbsent(item.symbolAfterDot, () => {});
      newItem.mergeInto(newKernel);
    }

    for (final MapEntry(:key, :value) in newKernels.entries) {
      final newKernel = Kernel(value);

      final targetIndex = kernels.indexOf(newKernel);
      if (targetIndex == -1) {
        kernel.gotos[key] = kernels.length;
        kernels.add(newKernel);
        continue;
      }

      final items = kernels[targetIndex].items;
      for (final item in newKernel.items) {
        changed |= item.mergeInto(items);
      }
      kernel.gotos[key] = targetIndex;
    }

    return changed;
  }
}
