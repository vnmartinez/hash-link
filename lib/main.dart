import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/generate_key/generate_key_bloc.dart';
import 'package:hash_link/views/generate_key/generate_key_view.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => GenerateKeyBloc(),
      child: const MaterialApp(
        home: GenerateKeyView(),
      ),
    ),
  );
}
