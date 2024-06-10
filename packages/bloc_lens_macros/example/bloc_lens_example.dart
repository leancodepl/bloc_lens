// ignore_for_file: avoid_print

import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:bloc_lens_macros/bloc_lens_macros.dart';

void main() {
  print('\n=== MyRecordStateCubit ===');
  final myRecordStateCubit = MyRecordStateCubit();
  print(myRecordStateCubit.state);
  myRecordStateCubit.anInt.set(42);
  myRecordStateCubit.anInt.increment();
  myRecordStateCubit.aBool.toggle();
  myRecordStateCubit.aList.set([1, 2, 3, 4, 5, 6]);
  myRecordStateCubit.aList.at(2).set(69);
  myRecordStateCubit.aMap.set({'foo': 1, 'bar': 2, 'baz': 3});
  myRecordStateCubit.aMap['qux'].set(42);
  myRecordStateCubit.anEnum.set(MyEnum.b);
  myRecordStateCubit.anEnum.next();
  print(myRecordStateCubit.state);
  print(myRecordStateCubit.anEnum.values);
  print(
    (
      min: myRecordStateCubit.anInt.min,
      max: myRecordStateCubit.anInt.max,
      step: myRecordStateCubit.anInt.step,
    ),
  );

  print('\n=== MyNamedStateCubit ===');
  final myNamedStateCubit = MyNamedStateCubit();
  print(myNamedStateCubit.state);
  myNamedStateCubit.anInt.set(42);
  myNamedStateCubit.anInt.increment();
  myNamedStateCubit.aBool.toggle();
  myNamedStateCubit.aList.set([1, 2, 3, 4, 5, 6]);
  myNamedStateCubit.aList.at(2).set(69);
  myNamedStateCubit.aMap.set({'foo': 1, 'bar': 2, 'baz': 3});
  myNamedStateCubit.aMap['qux'].set(42);
  myNamedStateCubit.anEnum.set(MyEnum.b);
  myNamedStateCubit.anEnum.next();
  print(myNamedStateCubit.state);
  print(myNamedStateCubit.anEnum.values);
  print(
    (
      min: myNamedStateCubit.anInt.min,
      max: myNamedStateCubit.anInt.max,
      step: myNamedStateCubit.anInt.step,
    ),
  );

  print('\n=== MyAliasedStateCubit ===');
  final myAliasedStateCubit = MyAliasedStateCubit();
  print(myAliasedStateCubit.state);
  myAliasedStateCubit.anInt.set(42);
  myAliasedStateCubit.anInt.increment();
  myAliasedStateCubit.aBool.toggle();
  myAliasedStateCubit.aList.set([1, 2, 3, 4, 5, 6]);
  myAliasedStateCubit.aList.at(2).set(69);
  myAliasedStateCubit.aMap.set({'foo': 1, 'bar': 2, 'baz': 3});
  myAliasedStateCubit.aMap['qux'].set(42);
  myAliasedStateCubit.anEnum.set(MyEnum.b);
  myAliasedStateCubit.anEnum.next();
  print(myAliasedStateCubit.state);
  print(myAliasedStateCubit.anEnum.values);
  print(
    (
      min: myAliasedStateCubit.anInt.min,
      max: myAliasedStateCubit.anInt.max,
      step: myAliasedStateCubit.anInt.step,
    ),
  );
}

// throws: not a bloc
// @MakeLenses()
class NB extends ListBase<int> {
  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

// throws: int is not an appropriate state type
// @MakeLenses()
class IntCubit extends Cubit<int> {
  IntCubit() : super(0);
}

@MakeLenses()
class MyNamedStateCubit extends Cubit<MyNamedState> {
  MyNamedStateCubit()
      : super(
          MyNamedState(
            anInt: 0,
            aBool: false,
            aList: [],
            aMap: {},
            anEnum: MyEnum.a,
          ),
        );
}

@MakeLenses()
class MyAliasedStateCubit extends Cubit<MyAlias> {
  MyAliasedStateCubit()
      : super(
          MyAlias(
            anInt: 0,
            aBool: false,
            aList: [],
            aMap: {},
            anEnum: MyEnum.a,
          ),
        );
}

// throws: no unnamed constructor
// @MakeLenses()
class MyAliasedAltStateCubit extends Cubit<MyAliasAlt> {
  MyAliasedAltStateCubit()
      : super(
          MyAliasAlt.foobar(
            anInt: 0,
            aBool: false,
            aList: [],
            aMap: {},
            anEnum: MyEnum.a,
          ),
        );
}

@MakeLenses()
class MyRecordStateCubit extends Cubit<MyNamedRecordState> {
  MyRecordStateCubit()
      : super(
          (
            anInt: 0,
            aBool: false,
            aList: [],
            aMap: {},
            anEnum: MyEnum.a,
          ),
        );
}

// throws: has positional fields
// @MakeLenses()
class MyInlineRecordStateCubit
    extends Cubit<(int anInt, String, {bool aBool})> {
  MyInlineRecordStateCubit() : super((0, 'foo', aBool: false));
}

enum MyEnum { a, b, c }

class MyNamedState {
  MyNamedState({
    required this.anInt,
    required this.aBool,
    required this.aList,
    required this.aMap,
    required this.anEnum,
  });

  @NumberOptions(min: -5, max: 15, step: 2)
  final int anInt;
  final bool aBool;
  final List<int> aList;
  final Map<String, int> aMap;
  final MyEnum anEnum;

  @override
  String toString() {
    return 'MyNamedState(anInt: $anInt, aBool: $aBool, aList: $aList, aMap: $aMap, anEnum: $anEnum)';
  }
}

class MyNamedStateAlt {
  MyNamedStateAlt.foobar({
    required this.anInt,
    required this.aBool,
    required this.aList,
    required this.aMap,
    required this.anEnum,
  });

  final int anInt;
  final bool aBool;
  final List<int> aList;
  final Map<String, int> aMap;
  final MyEnum anEnum;
}

typedef MyAlias = MyNamedState;

typedef MyAliasAlt = MyNamedStateAlt;

typedef MyNamedRecordState = MyNamedRecordState2;

typedef MyNamedRecordState2 = ({
  int anInt,
  bool aBool,
  List<int> aList,
  Map<String, int> aMap,
  MyEnum anEnum,
});
