import 'package:ease_neura/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ease_neura',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 255, 255)),
          useMaterial3: true,
        ),
        // TEMPORÁRIO: login desconectado, abrindo direto na Home pra você
        // avaliar a situação. StartedScreen/SigninScreen continuam intactas
        // no código — é só trocar esta linha de volta quando quiser
        // reativar o fluxo de login.
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false);
  }
}
