// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:bloc_lens_macros/bloc_lens_macros.dart';

void main() {
  print('\n=== MyRecordStateCubit ===');
  final myRecordStateCubit = MyRecordStateCubit();
  print(myRecordStateCubit.state);
  print(myRecordStateCubit.anEnum.values);
  print(
    (
      min: myRecordStateCubit.anInt.min,
      max: myRecordStateCubit.anInt.max,
      step: myRecordStateCubit.anInt.step,
    ),
  );
  myRecordStateCubit.anInt.set(42);
  myRecordStateCubit.anInt.increment();
  myRecordStateCubit.aDouble.set(3.2);
  myRecordStateCubit.aDouble.increment();
  myRecordStateCubit.aBool.toggle();
  myRecordStateCubit.aList.set([1, 2, 3, 4, 5, 6]);
  myRecordStateCubit.aList[2]?.set(69);
  myRecordStateCubit.aMap.set({'foo': 1, 'bar': 2, 'baz': 3});
  myRecordStateCubit.aMap['qux'].set(42);
  myRecordStateCubit.anEnum.set(MyEnum.b);
  myRecordStateCubit.anEnum.next();
  print(myRecordStateCubit.state);

  print('\n=== MyNamedStateCubit ===');
  final myNamedStateCubit = MyNamedStateCubit();
  print(myNamedStateCubit.state);
  print(myNamedStateCubit.anEnum.values);
  print(
    (
      min: myNamedStateCubit.anInt.min,
      max: myNamedStateCubit.anInt.max,
      step: myNamedStateCubit.anInt.step,
    ),
  );
  myNamedStateCubit.anInt.set(42);
  myNamedStateCubit.anInt.increment();
  myNamedStateCubit.aDouble.set(3.2);
  myNamedStateCubit.aDouble.increment();
  myNamedStateCubit.aBool.toggle();
  myNamedStateCubit.aList.set([1, 2, 3, 4, 5, 6]);
  myNamedStateCubit.aList[2]?.set(69);
  myNamedStateCubit.aMap.set({'foo': 1, 'bar': 2, 'baz': 3});
  myNamedStateCubit.aMap['qux'].set(42);
  myNamedStateCubit.anEnum.set(MyEnum.b);
  myNamedStateCubit.anEnum.next();
  print(myNamedStateCubit.state);
}

@MakeLenses()
class MyNamedStateCubit extends Cubit<MyNamedState> {
  MyNamedStateCubit()
      : super(
          MyNamedState(
            anInt: 0,
            aDouble: 0,
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
            aDouble: 0.0,
            aBool: false,
            aList: [],
            aMap: {},
            anEnum: MyEnum.a,
          ),
        );
}

enum MyEnum { a, b, c }

class MyNamedState {
  MyNamedState({
    required this.anInt,
    required this.aDouble,
    required this.aBool,
    required this.aList,
    required this.aMap,
    required this.anEnum,
  });

  @NumberOptions(min: -5, max: 15, step: 2)
  final int anInt;
  @NumberOptions(min: -12.5, max: 12.5, step: 0.5)
  final double aDouble;
  final bool aBool;
  final List<int> aList;
  final Map<String, int> aMap;
  final MyEnum anEnum;

  @override
  String toString() {
    return 'MyNamedState(anInt: $anInt, aDouble: $aDouble, aBool: $aBool, aList: $aList, aMap: $aMap, anEnum: $anEnum)';
  }
}

typedef MyNamedRecordState = MyNamedRecordState2;

typedef MyNamedRecordState2 = ({
  int anInt,
  double aDouble,
  bool aBool,
  List<int> aList,
  Map<String, int> aMap,
  MyEnum anEnum,
});
