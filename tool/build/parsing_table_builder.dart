import 'dart:async';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:trad/src/syntactic_analysis/action.dart';
import 'package:trad/src/syntactic_analysis/rule_symbol.dart';

import 'rule/closure_table.dart';
import 'rule/parsing_table.dart';

class ParsingTableBuilder extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    final parsingTable = ParsingTable(ClosureTable());

    final buffer = StringBuffer();

    buffer.writeln("const _\$parsingTable = [");

    for (final state in parsingTable.states) {
      buffer.writeln("  {");

      for (final MapEntry(:key, :value) in state.entries) {
        buffer.write("    ");

        if (key == eof) {
          buffer.write("'\\\$'");
        } else {
          buffer.write("'${key.name}'");
        }

        buffer.write(": ");

        if (value == Action.accept) {
          buffer.write("Action.accept");
        } else {
          buffer.write("Action.${value.type.name}(${value.value})");
        }

        buffer.writeln(",");
      }

      buffer.writeln("  },");
    }

    buffer.writeln("];");

    return buffer.toString();
  }
}
