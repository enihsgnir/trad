import 'dart:async';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'rule/production.dart';

class ProductionBuilder extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    final buffer = StringBuffer();

    buffer.writeln("const _\$productions = [");

    for (final production in productions) {
      buffer.write("  ");
      buffer.write("(Nonterminal('${production.lhs}'), ");
      buffer.writeln("${production.rhs.length}),");
    }

    buffer.writeln("];");

    return buffer.toString();
  }
}
