import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/routes.dart';
// import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';
import 'package:notes/views/notes/notes_view.dart';
import 'package:notes/views/notes/new_note_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: "Notes App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      // named routes
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNoteView(),
      }));
}

// homepage is stateful because we need text controller to listen for state changes as we increment or decrement counter
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Counter"),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            // everytime we make an action like + or -, textcontroller will be cleared
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalidValue : '';
            return Column(
              children: [
                Text("Current Value = ${state.value}"),
                // conditionally display the invalid value dialog - only if it is invalid number
                Visibility(
                  visible: state is CounterStateInvalidNumber,
                  child: Text('Invalid value: $invalidValue'),
                ),
                TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: "Enter the value here"),
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(IncrementEvent(_controller.text));
                        },
                        child: const Text('+')),
                    TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(DecrementEvent(_controller.text));
                        },
                        child: const Text('-')),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

// this class represents a valid parameter beint provided - an integer that can be added or subtracted to our value
class CounterStateValid extends CounterState {
  const CounterStateValid(super.value);
}

// invalid inputs like string - cannot be used with integer - so we handle them here
class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue); // call the valid constructor with prev valid value
}

abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

// create the bloc

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // let's consider 0 is the default state
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event
          .value); // get the integer and try parse -> try parse will parse if possible else return  null
      if (integer == null) {
        // emit sends a state outside
        emit(CounterStateInvalidNumber(
          invalidValue: event.value, // the passed value available in our event
          previousValue: state
              .value, // previous valid value available in our state(current value)
        ));
      } else {
        emit(CounterStateValid(state.value + integer)); // perform operation
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context){
//     return FutureBuilder(
//         future: AuthService.firebase().startService(),
//         builder: (context, snapshot){
//               switch(snapshot.connectionState){
//                 case ConnectionState.done:
//                   final user = AuthService.firebase().currentUser;
//                   if(user!=null){
//                     if(user.isEmailVerified){
//                          return const NotesView();
//                     }
//                     else{
//                          return const VerifyEmailView();
//                     }
//                   }
//                   else{
//                     return const LoginView();
//                   }
//                 default:
//                   // return const Text("Please wait, loading.");
//                   return const CircularProgressIndicator(); // loading animation
//               }
//           }
//       );
//     }
// }

Future<bool> logOut(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text("You really want to log out?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Log Out")),
        ],
      );
    },
  ).then((value) =>
      value ??
      false); // since this is an optional future we make sure to return a future by checking for the null value return
}
