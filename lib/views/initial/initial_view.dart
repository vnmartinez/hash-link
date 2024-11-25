import 'package:flutter/material.dart';
import 'package:hash_link/views/decrypt/decrypt_view.dart';
import 'package:hash_link/views/generate_key/generate_key_view.dart';

class InitialView extends StatelessWidget {
  const InitialView({super.key});

  static const route = '/initial';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hash Link'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, GenerateKeyView.route);
              },
              child: const Text('Criptografar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, DecryptView.route);
              },
              child: const Text('Descriptografar'),
            ),
          ],
        ),
      ),
    );
  }
}
