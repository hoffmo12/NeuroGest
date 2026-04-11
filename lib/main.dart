import 'package:flutter/material.dart';
import 'models/aluno.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const NeuroGestApp());
}

class NeuroGestApp extends StatelessWidget {
  const NeuroGestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final alunosIniciais = [
      Aluno(
        nome: 'Aluno Y',
        idade: '10',
        dataNascimento: '12/04/2015',
      ),
      Aluno(
        nome: 'Maria Souza',
        idade: '12',
        dataNascimento: '08/01/2013',
      ),
      Aluno(
        nome: 'João Pedro',
        idade: '9',
        dataNascimento: '21/09/2016',
      ),
      Aluno(
        nome: 'Ana Clara',
        idade: '11',
        dataNascimento: '30/06/2014',
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NeuroGest',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: LoginScreen(alunos: alunosIniciais),
    );
  }
}