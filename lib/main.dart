import 'package:flutter/material.dart';

void main() {
  runApp(const IslamicQuizApp());
}

class IslamicQuizApp extends StatelessWidget {
  const IslamicQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مسابقة إسلامية',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Cairo', // يمكنك استخدام أي خط متوفر
      ),
      home: const QuizHomePage(),
    );
  }
}

class QuizHomePage extends StatelessWidget {
  const QuizHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المسابقة الإسلامية'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.menu_book, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  'اختبر معلوماتك الدينية',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'سأسألك عدة أسئلة في السيرة والقرآن والفقه',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizScreen()),
                    );
                  },
                  child: const Text('ابدأ المسابقة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final int correctIndex;

  Question(this.questionText, this.options, this.correctIndex);
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  int? selectedChoice;

  // قائمة الأسئلة الإسلامية
  final List<Question> questions = [
    Question(
      'كم عدد سور القرآن الكريم؟',
      ['112', '114', '120', '110'],
      1,
    ),
    Question(
      'من هو أول من أسلم من الرجال؟',
      ['عمر بن الخطاب', 'علي بن أبي طالب', 'أبو بكر الصديق', 'عثمان بن عفان'],
      2,
    ),
    Question(
      'في أي غزوة استشهد حمزة بن عبد المطلب عم النبي؟',
      ['بدر', 'أحد', 'الخندق', 'تبوك'],
      1,
    ),
  ];

  void checkAnswer(int index) {
    if (isAnswered) return;

    setState(() {
      isAnswered = true;
      selectedChoice = index;
      if (index == questions[currentQuestionIndex].correctIndex) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isAnswered = false;
        selectedChoice = null;
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
        } else {
          // الانتقال لشاشة النتيجة النهائية
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(score: score, total: questions.length),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('السؤال ${currentQuestionIndex + 1} من ${questions.length}'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQ.questionText,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...List.generate(currentQ.options.length, (index) {
              Color buttonColor = Colors.teal.shade50;
              if (isAnswered) {
                if (index == currentQ.correctIndex) {
                  buttonColor = Colors.green.shade200; // الإجابة الصحيحة
                } else if (index == selectedChoice) {
                  buttonColor = Colors.red.shade200; // اختيار المستخدم الخاطئ
                }
              }

              return Container(
                margin: const المنخفضة ?? const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.all(15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () => checkAnswer(index),
                  child: Text(currentQ.options[index]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نتيجة المسابقة'),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              const SizedBox(height: 20),
              const Text(
                'انتهت المسابقة!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'لقد أجبت بشكل صحيح على $score من أصل $total أسئلة',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizHomePage()),
                    (route) => false,
                  );
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}