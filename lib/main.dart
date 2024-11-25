import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hash_link/blocs/decrypt/decrypt_bloc.dart';
import 'package:hash_link/blocs/encrypt/encrypt_bloc.dart';
import 'package:hash_link/blocs/theme/theme_bloc.dart';
import 'package:hash_link/core/routes.dart';
import 'package:hash_link/helpers/zip_helper.dart';
import 'package:hash_link/theme/app_theme.dart';
import 'package:window_manager/window_manager.dart';

import 'blocs/theme/theme_state.dart';

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
        BlocProvider(create: (_) => ThemeBloc()),
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
      child: const AppWidget(),
    ),
  );
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          initialRoute: Routes.initialRoute,
          onGenerateRoute: Routes.onGenerateRoute,
          onGenerateInitialRoutes: Routes.onGenerateInitialRoutes,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.themeMode,
        );
      },
    );
  }
}
