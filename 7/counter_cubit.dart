import 'package:bloc/bloc.dart';
import 'package:statemanagementtest/task.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  increment() => emit(state + 1);

  decrement() => emit(state - 1);

// addTaskToList(){
//   state.add(Task('', ''));
//   emit(state);
// }

}
