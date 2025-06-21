// // First, add to pubspec.yaml:
// // dependencies:
// //   formz: ^0.6.1
// //   flutter_bloc: ^8.1.3

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:formz/formz.dart';

// // Step 1: Define input validation classes
// enum EmailValidationError { empty, invalid }

// class Email extends FormzInput<String, EmailValidationError> {
//   const Email.pure() : super.pure('');
//   const Email.dirty([super.value = '']) : super.dirty();

//   @override
//   EmailValidationError? validator(String value) {
//     if (value.isEmpty) return EmailValidationError.empty;
//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//       return EmailValidationError.invalid;
//     }
//     return null;
//   }

//   String? get errorMessage {
//     switch (displayError) {
//       case EmailValidationError.empty:
//         return 'Email is required';
//       case EmailValidationError.invalid:
//         return 'Please enter a valid email';
//       default:
//         return null;
//     }
//   }
// }

// enum PasswordValidationError { empty, tooShort }

// class Password extends FormzInput<String, PasswordValidationError> {
//   const Password.pure() : super.pure('');
//   const Password.dirty([super.value = '']) : super.dirty();

//   @override
//   PasswordValidationError? validator(String value) {
//     if (value.isEmpty) return PasswordValidationError.empty;
//     if (value.length < 6) return PasswordValidationError.tooShort;
//     return null;
//   }

//   String? get errorMessage {
//     switch (displayError) {
//       case PasswordValidationError.empty:
//         return 'Password is required';
//       case PasswordValidationError.tooShort:
//         return 'Password must be at least 6 characters';
//       default:
//         return null;
//     }
//   }
// }

// enum NameValidationError { empty, tooShort }

// class Name extends FormzInput<String, NameValidationError> {
//   const Name.pure() : super.pure('');
//   const Name.dirty([super.value = '']) : super.dirty();

//   @override
//   NameValidationError? validator(String value) {
//     if (value.isEmpty) return NameValidationError.empty;
//     if (value.length < 2) return NameValidationError.tooShort;
//     return null;
//   }

//   String? get errorMessage {
//     switch (displayError) {
//       case NameValidationError.empty:
//         return 'Name is required';
//       case NameValidationError.tooShort:
//         return 'Name must be at least 2 characters';
//       default:
//         return null;
//     }
//   }
// }

// // Step 2: Define form events
// abstract class LoginEvent {}

// class EmailChanged extends LoginEvent {
//   final String email;
//   EmailChanged(this.email);
// }

// class PasswordChanged extends LoginEvent {
//   final String password;
//   PasswordChanged(this.password);
// }

// class NameChanged extends LoginEvent {
//   final String name;
//   NameChanged(this.name);
// }

// class FormSubmitted extends LoginEvent {}

// // Step 3: Define form state
// class LoginState {
//   final Email email;
//   final Password password;
//   final Name name;
//   final FormzSubmissionStatus status;

//   const LoginState({
//     this.email = const Email.pure(),
//     this.password = const Password.pure(),
//     this.name = const Name.pure(),
//     this.status = FormzSubmissionStatus.initial,
//   });

//   // Check if the entire form is valid
//   bool get isValid => Formz.validate([email, password, name]);

//   LoginState copyWith({
//     Email? email,
//     Password? password,
//     Name? name,
//     FormzSubmissionStatus? status,
//   }) {
//     return LoginState(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       name: name ?? this.name,
//       status: status ?? this.status,
//     );
//   }
// }

// // Step 4: Define BLoC
// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   LoginBloc() : super(const LoginState()) {
//     on<EmailChanged>(_onEmailChanged);
//     on<PasswordChanged>(_onPasswordChanged);
//     on<NameChanged>(_onNameChanged);
//     on<FormSubmitted>(_onFormSubmitted);
//   }

//   void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
//     final email = Email.dirty(event.email);
//     emit(state.copyWith(
//       email: email,
//       status: FormzSubmissionStatus.initial,
//     ));
//   }

//   void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
//     final password = Password.dirty(event.password);
//     emit(state.copyWith(
//       password: password,
//       status: FormzSubmissionStatus.initial,
//     ));
//   }

//   void _onNameChanged(NameChanged event, Emitter<LoginState> emit) {
//     final name = Name.dirty(event.name);
//     emit(state.copyWith(
//       name: name,
//       status: FormzSubmissionStatus.initial,
//     ));
//   }

//   Future<void> _onFormSubmitted(
//       FormSubmitted event, Emitter<LoginState> emit) async {
//     if (state.isValid) {
//       emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

//       try {
//         // Simulate API call
//         await Future.delayed(const Duration(seconds: 2));

//         // Simulate success/failure
//         if (state.email.value == "test@example.com") {
//           emit(state.copyWith(status: FormzSubmissionStatus.success));
//         } else {
//           emit(state.copyWith(status: FormzSubmissionStatus.failure));
//         }
//       } catch (_) {
//         emit(state.copyWith(status: FormzSubmissionStatus.failure));
//       }
//     }
//   }
// }

// // Step 5: UI Widget
// // class FormzLoginPage extends StatelessWidget {
// //   const FormzLoginPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Formz Login Example')),
// //       body: BlocProvider(
// //         create: (_) => LoginBloc(),
// //         child: const LoginForm(),
// //       ),
// //     );
// //   }
// // }

// // class LoginForm extends StatelessWidget {
// //   const LoginForm({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocListener<LoginBloc, LoginState>(
// //       listener: (context, state) {
// //         if (state.status.isSuccess) {
// //           ScaffoldMessenger.of(context)
// //             ..hideCurrentSnackBar()
// //             ..showSnackBar(
// //               const SnackBar(
// //                 content: Text('Login Successful!'),
// //                 backgroundColor: Colors.green,
// //               ),
// //             );
// //         } else if (state.status.isFailure) {
// //           ScaffoldMessenger.of(context)
// //             ..hideCurrentSnackBar()
// //             ..showSnackBar(
// //               const SnackBar(
// //                 content: Text('Login Failed!'),
// //                 backgroundColor: Colors.red,
// //               ),
// //             );
// //         }
// //       },
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             const _NameInput(),
// //             const SizedBox(height: 16),
// //             const _EmailInput(),
// //             const SizedBox(height: 16),
// //             const _PasswordInput(),
// //             const SizedBox(height: 24),
// //             const _SubmitButton(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// class _NameInput extends StatelessWidget {
//   const _NameInput();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.name != current.name,
//       builder: (context, state) {
//         return TextFormField(
//           onChanged: (name) => context.read<LoginBloc>().add(NameChanged(name)),
//           decoration: InputDecoration(
//             labelText: 'Name',
//             prefixIcon: const Icon(Icons.person),
//             border: const OutlineInputBorder(),
//             errorText: state.name.errorMessage,
//           ),
//           textInputAction: TextInputAction.next,
//         );
//       },
//     );
//   }
// }

// class _EmailInput extends StatelessWidget {
//   const _EmailInput();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.email != current.email,
//       builder: (context, state) {
//         return TextFormField(
//           onChanged: (email) =>
//               context.read<LoginBloc>().add(EmailChanged(email)),
//           decoration: InputDecoration(
//             labelText: 'Email',
//             prefixIcon: const Icon(Icons.email),
//             border: const OutlineInputBorder(),
//             errorText: state.email.errorMessage,
//             helperText: 'Try "test@example.com" for success',
//           ),
//           keyboardType: TextInputType.emailAddress,
//           textInputAction: TextInputAction.next,
//         );
//       },
//     );
//   }
// }

// class _PasswordInput extends StatelessWidget {
//   const _PasswordInput();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.password != current.password,
//       builder: (context, state) {
//         return TextFormField(
//           onChanged: (password) =>
//               context.read<LoginBloc>().add(PasswordChanged(password)),
//           decoration: InputDecoration(
//             labelText: 'Password',
//             prefixIcon: const Icon(Icons.lock),
//             border: const OutlineInputBorder(),
//             errorText: state.password.errorMessage,
//           ),
//           obscureText: true,
//           textInputAction: TextInputAction.done,
//           onFieldSubmitted: (_) =>
//               context.read<LoginBloc>().add(FormSubmitted()),
//         );
//       },
//     );
//   }
// }

// class _SubmitButton extends StatelessWidget {
//   const _SubmitButton();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       builder: (context, state) {
//         return ElevatedButton(
//           onPressed: state.isValid && !state.status.isInProgress
//               ? () => context.read<LoginBloc>().add(FormSubmitted())
//               : null,
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//           ),
//           child: state.status.isInProgress
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text('Login', style: TextStyle(fontSize: 16)),
//         );
//       },
//     );
//   }
// }

// // Usage in your app:
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Formz Example',
// //       home: FormzLoginPage(),
// //     );
// //   }
// // }
