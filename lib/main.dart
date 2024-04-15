import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  var inputController = TextEditingController();
  bool? isCorrectAnswer;
  late MathChallenge challenge;
  @override
  void initState() {
    challenge = MathChallenge.generateChallenge();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          margin: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Text(
                'هل أنت روبوت؟',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 30),
              const Text('ادخل الأجابة الصحيحة'),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  label: Center(child: Text(challenge.num1.toString())),
                ),
                enabled: false,
              ),
              const SizedBox(height: 15),
              Text(
                challenge.operator,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  label: Center(
                    child: Text(challenge.num2.toString()),
                  ),
                ),
                enabled: false,
              ),
              const SizedBox(height: 15),
              Text(
                '=',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: inputController,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(
                        () {
                          int? inputAnswer = int.tryParse(inputController.text);
                          if (inputAnswer != null) {
                            isCorrectAnswer =
                                challenge.checkAnswer(inputAnswer);
                            inputController.clear();
                            challenge = MathChallenge.generateChallenge();
                          } else {
                            isCorrectAnswer = null;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(milliseconds: 1500),
                                content: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text('قيمة غير صالحة'),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      child: const Text('أدخل'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              IconButton(
                onPressed: () => setState(() {
                  isCorrectAnswer = null;
                  challenge = MathChallenge.generateChallenge();
                }),
                icon: const Icon(Icons.refresh),
              ),
              const SizedBox(height: 30),
              AnswerImageBuilder(answer: isCorrectAnswer)
            ],
          ),
        ),
      ),
      bottomSheet: const Text('Yahia Smeism'),
    );
  }
}

// ======================================================
class MathChallenge {
  final int num1;
  final int num2;
  final String operator;
  MathChallenge({
    required this.num1,
    required this.num2,
    required this.operator,
  });

  int calculate() {
    switch (operator) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case 'x':
        return num1 * num2;
      default:
        return 0;
    }
  }

  factory MathChallenge.generateChallenge() {
    final random = Random();
    int num1 = random.nextInt(10) + 1;
    int num2 = random.nextInt(5) + 1;

    return MathChallenge(
      num1: num1,
      num2: num2,
      operator: ['+', '-', 'x'][random.nextInt(3)],
    );
  }

  bool? checkAnswer(int? answer) {
    int correctAnswer = calculate();
    if (answer != null) {
      if (correctAnswer == answer) {
        return true;
      } else {
        return false;
      }
    }
    return null;
  }
}

class AnswerImageBuilder extends StatelessWidget {
  const AnswerImageBuilder({super.key, this.answer});
  final bool? answer;
  @override
  Widget build(BuildContext context) {
    String correctImagePath =
        'https://img.freepik.com/premium-vector/green-correct-sign-vector-icon_547110-401.jpg';
    String wrongImagePath =
        'https://cdn-icons-png.freepik.com/256/14025/14025328.png';
    if (answer != null) {
      return SizedBox(
          width: 80,
          height: 80,
          child: Image.network(answer! ? correctImagePath : wrongImagePath));
    }
    return const SizedBox();
  }
}
