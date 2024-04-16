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
  var inputController = TextEditingController();
  bool? isCorrectAnswer;
  late MathChallenge challenge;
  @override
  void initState() {
    // Initialize the random challenge value
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
                          // extract number from inputFeild
                          int? inputAnswer = int.tryParse(inputController.text);

                          // Check the value if it is not null (valid)
                          if (inputAnswer != null) {
                            // Get the answer result
                            isCorrectAnswer =
                                challenge.checkAnswer(inputAnswer);

                            // Empty the input field
                            inputController.clear();

                            // update the numbers
                            challenge = MathChallenge.generateChallenge();
                          } else {
                            isCorrectAnswer = null;

                            // If the data is invalid, show the snack bar
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
                      ), //setState
                      child: const Text('أدخل'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              IconButton(
                onPressed: () => setState(() {
                  isCorrectAnswer = null;
                  // If you click Refresh, we update the numbers
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
  // calculate the correct result of the math challenge
  int calculate() {
    switch (operator) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case 'x':
        return num1 * num2;
      // Return default value zero if no valid arithmetic operation is found
      default:
        return 0;
    }
  }

  // Generate a random math challenge
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

  // Check if the given answer is correct
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

/// Enter an answer to a random math challenge and verify the answer.
/// If the answer is correct, a correct image appears, otherwise an incorrect image appears
class AnswerImageBuilder extends StatelessWidget {
  const AnswerImageBuilder({super.key, this.answer});
  final bool? answer;
  @override
  Widget build(BuildContext context) {
    const String correctImagePath =
        'https://img.freepik.com/premium-vector/green-correct-sign-vector-icon_547110-401.jpg';
    const String wrongImagePath =
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
