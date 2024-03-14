import 'package:contact_app/bloc/contact_bloc.dart';
import 'package:contact_app/pages/list_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactBloc(),
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: ListContactPage()),
    );
  }
}
