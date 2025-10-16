import 'dart:io';

import '../abstract_syntax_tree/ast.dart';
import 'symbol_table.dart';

class PreTasker {
  const PreTasker._();

  static void preTask(SymbolTableContext symbolTableContext) {
    symbolTableContext.declareBuiltIns();
  }
}

extension BuiltInDeclarationExtension on SymbolTableContext {
  void declareBuiltIns() {
    declareBuiltInFunctions();
    declareBuiltInOperators();
  }

  void declareBuiltInFunctions() {
    global["print"] = SymbolTableEntry(
      const FunctionType([DynamicType()], VoidType()),
      print,
    );
    global["readLine"] = SymbolTableEntry(
      const FunctionType([], StringType()),
      stdin.readLineSync,
    );
  }

  void _declareOperator(
    String type,
    String op,
    FunctionType signature,
    Function func, {
    bool isUnary = false,
  }) {
    final id = type + (isUnary ? ".unary" : ".") + op;
    global[id] = SymbolTableEntry(signature, func);
  }

  // TODO: deprecate this when "class", "operator" and "inheritance" system is implemented
  void declareBuiltInOperators() {
    const arithmetic = FunctionType([IntType(), IntType()], IntType());
    _declareOperator("int", "+", arithmetic, (int a, int b) => a + b);
    _declareOperator("int", "-", arithmetic, (int a, int b) => a - b);
    _declareOperator("int", "*", arithmetic, (int a, int b) => a * b);
    _declareOperator("int", "~/", arithmetic, (int a, int b) => a ~/ b);
    _declareOperator("int", "%", arithmetic, (int a, int b) => a % b);

    const relational = FunctionType([IntType(), IntType()], BoolType());
    _declareOperator("int", ">=", relational, (int a, int b) => a >= b);
    _declareOperator("int", ">", relational, (int a, int b) => a > b);
    _declareOperator("int", "<=", relational, (int a, int b) => a <= b);
    _declareOperator("int", "<", relational, (int a, int b) => a < b);
    _declareOperator("int", "==", relational, (int a, int b) => a == b);

    const intMinus = FunctionType([IntType()], IntType());
    _declareOperator("int", "-", intMinus, (int a) => -a, isUnary: true);

    const strConcat = FunctionType([StringType(), StringType()], StringType());
    _declareOperator("String", "+", strConcat, (String a, String b) => a + b);

    const strRepeat = FunctionType([StringType(), IntType()], StringType());
    _declareOperator("String", "*", strRepeat, (String a, int b) => a * b);

    const strEq = FunctionType([StringType(), StringType()], BoolType());
    _declareOperator("String", "==", strEq, (String a, String b) => a == b);

    const boolEq = FunctionType([BoolType(), BoolType()], BoolType());
    _declareOperator("bool", "==", boolEq, (bool a, bool b) => a == b);
  }
}
