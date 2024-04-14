import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'build/parsing_table_builder.dart';
import 'build/production_builder.dart';

Builder ruleBuilder(BuilderOptions options) => SharedPartBuilder(
      [ProductionBuilder(), ParsingTableBuilder()],
      "rule",
    );
