import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const background = Color(0xFF090A13);
  static const surface = Color(0xFF191A2A);
  static const purple = Color(0xFF9146FF);
  static const muted = Color(0xFF9295B1);

  final questions = const [
    (
      question: 'සාම්ප්‍රදායික දත්ත සැකසීමේ ගැටලුවක් වන්නේ කුමක්ද?',
      options: [
        'ඉතා වේගවත් වීම',
        'වැඩි කාලයක් ගත වීම',
        'සියලු දත්ත ස්වයංක්‍රීයව නිවැරදි වීම',
        'මිනිස් ශ්‍රමය අවශ්‍ය නොවීම',
      ],
      answer: 1,
      explanation:
          'අතින් දත්ත එකතු කිරීම සහ සැකසීම සඳහා වැඩි කාලයක් ගත විය හැකිය.',
    ),
    (
      question: 'දත්ත එකතු කර ප්‍රතිඵල නිකුත් කිරීමට දිගු කාලයක් ගත වීමේ ගැටලුව කුමක්ද?',
      options: [
        'මුල් දත්ත අදාළ තත්ත්වය වෙනස් වී තිබිය හැකිය',
        'දත්ත සැමවිටම වඩාත් නිවැරදි වේ',
        'දත්ත ප්‍රමාණය අනිවාර්යයෙන් අඩු වේ',
        'දත්ත ගබඩා කළ නොහැකිය',
      ],
      answer: 0,
      explanation:
          'ප්‍රතිඵල නිකුත් කරන විට මුලින් දත්ත රැස් කළ අවස්ථාවේ තත්ත්වය '
          'වෙනස් වී තිබිය හැකිය.',
    ),
    (
      question: 'පරිගණක ජාලයක් භාවිත කිරීමේ ප්‍රයෝජනයක් කුමක්ද?',
      options: [
        'සියලු පරිගණකවල දත්ත මකා දැමීම',
        'සන්නිවේදනය වළක්වා ගැනීම',
        'දත්ත සහ සම්පත් හුවමාරු කිරීම',
        'සියලු උපකරණ අන්තර්ජාලයෙන් වෙන් කිරීම',
      ],
      answer: 2,
      explanation:
          'ජාලයක් හරහා සම්බන්ධ උපකරණ අතර දත්ත සහ සම්පත් හුවමාරු කළ හැකිය.',
    ),
    (
      question: 'අන්තර්ජාල සන්නිවේදනය සඳහා භාවිත වන ප්‍රොටෝකෝල කට්ටලය කුමක්ද?',
      options: ['HTML', 'USB', 'PDF', 'TCP/IP'],
      answer: 3,
      explanation:
          'TCP/IP යනු අන්තර්ජාල සන්නිවේදනයට භාවිත වන ප්‍රොටෝකෝල කට්ටලයකි.',
    ),
    (
      question: 'Internet සහ WWW අතර සම්බන්ධය නිවැරදිව දැක්වෙන්නේ කෙසේද?',
      options: [
        'ඒ දෙකම සම්පූර්ණයෙන් එකම දෙයකි',
        'WWW යනු අන්තර්ජාලය හරහා ලබාගන්නා සේවාවකි',
        'Internet යනු වෙබ් පිටුවකි',
        'WWW භාවිතයට කිසිදු ජාලයක් අවශ්‍ය නැත',
      ],
      answer: 1,
      explanation:
          'Internet යනු ජාල එකතුවකි. WWW යනු ඒ හරහා ප්‍රවේශ වන සේවාවකි.',
    ),
  ];

  int currentQuestion = 0;
  bool completed = false;

  final List<int?> answers = List<int?>.filled(5, null);

  int get score {
    int total = 0;

    for (int i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i].answer) {
        total++;
      }
    }

    return total;
  }

  void _next() {
    if (answers[currentQuestion] == null) return;

    setState(() {
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
      } else {
        completed = true;
      }
    });
  }

  void _restart() {
    setState(() {
      currentQuestion = 0;
      completed = false;
      answers.fillRange(0, answers.length, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Unit 1 · Practice Quiz'),
        backgroundColor: surface,
        foregroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: completed ? _results() : _question(),
        ),
      ),
    );
  }

  Widget _question() {
    final question = questions[currentQuestion];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Question ${currentQuestion + 1} of ${questions.length}',
          style: const TextStyle(color: muted, fontSize: 14),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (currentQuestion + 1) / questions.length,
            minHeight: 6,
            backgroundColor: surface,
            valueColor: const AlwaysStoppedAnimation<Color>(purple),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          question.question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(question.options.length, (index) {
          final selected = answers[currentQuestion] == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: selected ? const Color(0xFF30204B) : surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: selected ? purple : const Color(0xFF2A2B3C),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  setState(() {
                    answers[currentQuestion] = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: selected ? purple : muted,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          question.options[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Row(
          children: [
            if (currentQuestion > 0) ...[
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    currentQuestion--;
                  });
                },
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                child: const Text('Previous'),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: answers[currentQuestion] == null ? null : _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: surface,
                  disabledForegroundColor: muted,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  currentQuestion == questions.length - 1
                      ? 'Finish Quiz'
                      : 'Next Question',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _results() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Icon(
          Icons.emoji_events_rounded,
          color: Color(0xFFFFB522),
          size: 64,
        ),
        const SizedBox(height: 16),
        const Text(
          'Quiz Completed!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '$score / ${questions.length}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: purple,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${(score / questions.length * 100).round()}%',
          textAlign: TextAlign.center,
          style: const TextStyle(color: muted, fontSize: 18),
        ),
        const SizedBox(height: 24),
        const Text(
          'Review Answers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(questions.length, (index) {
          final question = questions[index];
          final selectedAnswer = answers[index];
          final correct = selectedAnswer == question.answer;

          return Card(
            color: surface,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    correct ? Icons.check_circle : Icons.cancel,
                    color: correct
                        ? const Color(0xFF00D887)
                        : const Color(0xFFFF5277),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${index + 1}. ${question.question}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your answer: ${selectedAnswer == null ? "Not answered" : question.options[selectedAnswer]}',
                    style: const TextStyle(color: muted, height: 1.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Correct answer: ${question.options[question.answer]}',
                    style: const TextStyle(
                      color: Color(0xFF00D887),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    question.explanation,
                    style: const TextStyle(color: Colors.white, height: 1.6),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _restart,
          style: ElevatedButton.styleFrom(
            backgroundColor: purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Try Again'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back', style: TextStyle(color: muted)),
        ),
      ],
    );
  }
}
