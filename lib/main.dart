import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/decrypt/decrypt_bloc.dart';
import 'package:hash_link/blocs/generate_key/generate_key_bloc.dart';
import 'package:hash_link/core/routes.dart';
import 'package:hash_link/helpers/zip_helper.dart';
import 'package:hash_link/views/generate_key/generate_key_view.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow();
    await windowManager.setTitle('Hash Link');
    await windowManager.setMinimumSize(const Size(1366, 768));
    await windowManager.setSize(const Size(1600, 900));
    await windowManager.center();
    await windowManager.show();
  }

  final filePicker = FilePicker.platform;
  final zipHelper = ZipHelper(filePicker: filePicker);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GenerateKeyBloc(
            filePicker: filePicker,
            zipHelper: zipHelper,
          ),
        ),
        BlocProvider(
          create: (_) => DecryptBloc(
            filePicker: filePicker,
            zipHelper: zipHelper,
          ),
        ),
      ],
      child: const MaterialApp(
        initialRoute: Routes.initialRoute,
        onGenerateRoute: Routes.onGenerateRoute,
        onGenerateInitialRoutes: Routes.onGenerateInitialRoutes,
      ),
    ),
  );
}
