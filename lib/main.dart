import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/generate_key/generate_key_bloc.dart';
import 'package:hash_link/views/generate_key/generate_key_view.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow();
    await windowManager.setTitle('Hash Link');
    await windowManager.setMinimumSize(const Size(1366, 768));
    await windowManager.setSize(const Size(1920, 1080));
    await windowManager.center();
    await windowManager.show();
  }

  runApp(
    BlocProvider(
      create: (_) => GenerateKeyBloc(filePicker: FilePicker.platform),
      child: const MaterialApp(
        home: GenerateKeyView(),
      ),
    ),
  );
}
