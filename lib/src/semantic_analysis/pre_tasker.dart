import 'dart:io';

import '../abstract_syntax_tree/ast.dart';
import 'symbol_table.dart';

class PreTasker {
  const PreTasker._();

  static void preTask() {
    // TODO: do not use global variables for the repeatability of tests
    globalSymbolTable.dropAll();
    currentSymbolTable = globalSymbolTable;

    declareBuiltInFunctions();
    declareBuiltInOperators();
  }

  static void declareBuiltInFunctions() {
    globalSymbolTable["print"] = SymbolTableEntry(
      const FunctionType([DynamicType()], VoidType()),
      print,
    );
    globalSymbolTable["readLine"] = SymbolTableEntry(
      const FunctionType([], StringType()),
      stdin.readLineSync,
    );
  }

  static void _declareOperator(
    String type,
    String op,
    FunctionType signature,
    Function func, {
    bool isUnary = false,
  }) {
    final id = type + (isUnary ? "::unary::" : "::") + op;
    globalSymbolTable[id] = SymbolTableEntry(signature, func);
  }

  // TODO: deprecate this when "class", "operator" and "inheritance" system is implemented
  static void declareBuiltInOperators() {
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

    // TODO: temporary operators (remove these when node replacer is implemented)
    const not = FunctionType([BoolType()], BoolType());
    _declareOperator("bool", "!", not, (bool a) => !a, isUnary: true);
    _declareOperator("int", "!=", relational, (int a, int b) => a != b);
    _declareOperator("String", "!=", strEq, (String a, String b) => a != b);
    _declareOperator("bool", "!=", boolEq, (bool a, bool b) => a != b);
  }
}
