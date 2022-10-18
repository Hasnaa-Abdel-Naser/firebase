import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statemanagementtest/counter_cubit.dart';

main() {
  runApp(MaterialApp(
    home: BlocProvider(
      create: (_) => CounterCubit(),
      child: Counter(),
    ),
  ));
}

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      context.read<CounterCubit>().decrement();
                    },
                    icon: Icon(
                      Icons.remove_circle,
                      size: 40,
                      color: Colors.red,
                    )),
                BlocBuilder<CounterCubit, int>(
                  buildWhen: (pstate, state) {
                    // if(state - pstate > 5){
                    //   return true;
                    // }
                    // return false;
                    return true;
                  },
                  builder: (_, counter) => Text(
                    '${counter}',
                    style: TextStyle(
                      fontSize: 56,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context.read<CounterCubit>().increment();
                    },
                    icon: Icon(
                      Icons.add_circle,
                      size: 40,
                      color: Colors.green,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocSelector<CounterCubit, int, String>(
                  selector: (state) {
                    if (state < 0) {
                      return 'Stage 1';
                    } else if (state <= 5) {
                      return 'Stage 2';
                    } else if (state <= 10) {
                      return 'Stage 3';
                    } else {
                      return 'Final Stage';
                    }
                  },
                  builder: (_, counter) => Text(
                    '${counter}',
                    style: TextStyle(
                      fontSize: 56,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
