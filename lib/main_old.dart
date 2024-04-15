import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      theme: myTheme(),
    );
  }
}

ThemeData myTheme() {
  return ThemeData(
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 22),
      bodyLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final inputController = TextEditingController();
  int num1 = 0;
  int num2 = 0;
  String operator = '';
  int result = 0;
  bool? answer;
  void generateNumbers() {
    setState(() {
      num1 = Random().nextInt(10) + 1; // Generate numbers between 0 and 99
      num2 = Random().nextInt(5) + 1;
      operator = randomOperator();
      result = calculate(num1, num2, operator);
    });
  }

  String randomOperator() {
    final operations = ['+', '-', 'x'];
    return operations[Random().nextInt(operations.length)];
  }

  int calculate(int a, int b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case 'x':
        return a * b;
      default:
        return 0;
    }
  }

  bool checkAnswer(int userInput) {
    int correctAnswer = calculate(num1, num2, operator);
    if (userInput == correctAnswer) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double spacerHeightForm = 20;
    generateNumbers();
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          margin: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: <Widget>[
              Text('هل أنت روبوت؟',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 30),
              const Text('ادخل الأجابة الصحيحة'),
              const SizedBox(height: 20),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: Center(child: Text(num1.toString())),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: spacerHeightForm),
                    Center(
                      child: Text(operator,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    const SizedBox(height: spacerHeightForm),
                    TextFormField(
                      decoration: InputDecoration(
                          label: Center(
                        child: Text(num2.toString()),
                      )),
                      enabled: false,
                    ),
                    const SizedBox(height: spacerHeightForm),
                    Center(
                        child: Text('=',
                            style: Theme.of(context).textTheme.bodyLarge)),
                    const SizedBox(height: spacerHeightForm),
                    TextFormField(
                      controller: inputController,
                    ),
                    const SizedBox(height: spacerHeightForm * 2),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          int? userInput = int.tryParse(inputController.text);
                          if (userInput != null) {
                            answer = checkAnswer(userInput);
                          } else {
                            answer = null;
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('قيمة غير صالحة')));
                          }
                          inputController.clear();
                        });
                      },
                      child: const Text('أدخل'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              AnswerImageBuilder(finalAnswer: answer)
            ],
          ),
        ),
      ),
      bottomSheet: const Text('Yahia Smeism'),
    );
  }
}

class AnswerImageBuilder extends StatelessWidget {
  const AnswerImageBuilder({super.key, this.finalAnswer});
  final bool? finalAnswer;
  @override
  Widget build(BuildContext context) {
    if (finalAnswer != null) {
      String greenImage =
          'https://img.freepik.com/premium-vector/green-correct-sign-vector-icon_547110-401.jpg';
      String redImage =
          'https://cdn-icons-png.freepik.com/256/14025/14025328.png';
      String answerImageSrc = finalAnswer! ? greenImage : redImage;
      return Image.network(
        answerImageSrc,
        width: 100,
        height: 100,
      );
    } else {
      return const SizedBox();
    }
  }
}
