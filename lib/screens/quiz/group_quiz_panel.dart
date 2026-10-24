import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/backend_service.dart';

class GroupQuizPanel extends StatefulWidget {
  const GroupQuizPanel({super.key, required this.roomCode});

  final String roomCode;

  @override
  State<GroupQuizPanel> createState() => _GroupQuizPanelState();
}

class _GroupQuizPanelState extends State<GroupQuizPanel> {
  final answers = <String, int>{};
  final clock = Stopwatch()..start();

  List<Map<String, dynamic>> questions = [];

  Timer? displayTimer;
  Timer? syncTimer;

  int endAtMilliseconds = 0;
  int? score;

  bool loaded = false;
  bool syncing = false;
  bool saving = false;
  bool submitting = false;
  bool submitted = false;
  bool unsaved = false;
  bool deadlineChecked = false;

  String? error;

  int get remainingMilliseconds =>
      (endAtMilliseconds - clock.elapsedMilliseconds).clamp(0, 180000).toInt();

  int get remainingSeconds => (remainingMilliseconds / 1000).ceil();

  bool get locked =>
      !loaded ||
      saving ||
      submitting ||
      submitted ||
      remainingMilliseconds == 0;

  @override
  void initState() {
    super.initState();

    sync();

    displayTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !loaded) return;

      setState(() {});

      if (remainingMilliseconds == 0 && !deadlineChecked) {
        deadlineChecked = true;
        sync();
      }
    });

    // Includes players who already submitted and are waiting.
    syncTimer = Timer.periodic(const Duration(seconds: 5), (_) => sync());
  }

  @override
  void dispose() {
    displayTimer?.cancel();
    syncTimer?.cancel();
    clock.stop();
    super.dispose();
  }

  void applyResponse(
    Map<String, dynamic> data,
    int requestStarted, {
    bool restoreAnswers = false,
  }) {
    final requestDuration = clock.elapsedMilliseconds - requestStarted;

    final serverRemaining = data['remainingMs'] as int;

    // Subtract request duration conservatively.
    final adjustedRemaining = (serverRemaining - requestDuration)
        .clamp(0, 180000)
        .toInt();

    endAtMilliseconds = clock.elapsedMilliseconds + adjustedRemaining;

    submitted = data['submitted'] == true;
    score = data['score'] as int?;

    if (restoreAnswers) {
      questions = (data['questions'] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      answers
        ..clear()
        ..addAll(Map<String, int>.from(data['answers'] as Map));
    }

    loaded = true;

    if (adjustedRemaining > 0) {
      deadlineChecked = false;
    }
  }

  Future<void> sync() async {
    if (!mounted || syncing || saving || submitting) return;

    syncing = true;
    final started = clock.elapsedMilliseconds;

    try {
      final data = await BackendService.getQuestions(widget.roomCode);

      if (!mounted) return;

      setState(() {
        applyResponse(data, started, restoreAnswers: !loaded);

        if (!unsaved) {
          error = null;
        }
      });
    } catch (exception) {
      if (mounted) {
        setState(() {
          error =
              'Could not sync. Check your connection and retry.\n'
              '$exception';
        });
      }
    } finally {
      syncing = false;
    }
  }

  Future<void> saveSelection() async {
    if (saving || submitting || submitted) return;

    setState(() {
      saving = true;
      error = null;
    });

    final started = clock.elapsedMilliseconds;

    try {
      final data = await BackendService.saveAnswers(
        widget.roomCode,
        Map<String, int>.from(answers),
      );

      if (!mounted) return;

      setState(() {
        applyResponse(data, started);
        unsaved = false;
      });
    } catch (exception) {
      if (mounted) {
        setState(() {
          unsaved = true;
          error =
              'Your latest selection was not saved. Retry saving.\n'
              '$exception';
        });
      }
    } finally {
      if (mounted) {
        setState(() => saving = false);
      }
    }
  }

  Future<void> submit() async {
    if (locked) return;

    setState(() {
      submitting = true;
      error = null;
    });

    final started = clock.elapsedMilliseconds;

    try {
      final data = await BackendService.submitAnswers(
        widget.roomCode,
        Map<String, int>.from(answers),
      );

      if (!mounted) return;

      setState(() {
        applyResponse(data, started);
        unsaved = false;
      });
    } catch (exception) {
      if (mounted) {
        setState(() => error = exception.toString());
      }
    } finally {
      if (mounted) {
        setState(() => submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      if (error == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          Text(error!, style: const TextStyle(color: Colors.orangeAccent)),
          TextButton(onPressed: sync, child: const Text('Retry')),
        ],
      );
    }

    final minutes = remainingSeconds ~/ 60;
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Time left: $minutes:$seconds',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: remainingSeconds <= 30
                ? Colors.orangeAccent
                : const Color(0xFFAE78FF),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        if (submitted) ...[
          const Icon(Icons.check_circle, size: 56, color: Colors.greenAccent),
          const SizedBox(height: 12),
          Text(
            'Answers submitted! Score: ${score ?? 0}/${questions.length}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 19),
          ),
          const SizedBox(height: 12),
          const Text(
            'Waiting for other players or the time limit...',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF9295B1)),
          ),
        ] else if (remainingMilliseconds == 0) ...[
          const Text(
            'Time is up. Finalizing saved answers...',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 19),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: sync, child: const Text('Refresh Results')),
        ] else ...[
          const Text(
            'Your Challenge',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${answers.length}/${questions.length} answered'
            ' · ${saving
                ? 'Saving...'
                : unsaved
                ? 'Not saved'
                : 'Saved'}',
            style: const TextStyle(color: Color(0xFF9295B1)),
          ),
          const SizedBox(height: 16),
          for (var index = 0; index < questions.length; index++)
            questionCard(questions[index], index + 1),
          if (unsaved)
            TextButton(
              onPressed: saving || submitting ? null : saveSelection,
              child: const Text('Retry Saving'),
            ),
          ElevatedButton(
            onPressed: locked ? null : submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8838EF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            child: Text(submitting ? 'Submitting...' : 'Submit Answers'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Saved answers are finalized automatically when time expires. '
            'Unanswered questions receive 0 marks.',
            style: TextStyle(color: Color(0xFF9295B1)),
          ),
        ],
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(error!, style: const TextStyle(color: Colors.orangeAccent)),
        ],
      ],
    );
  }

  Widget questionCard(Map<String, dynamic> question, int number) {
    final id = question['id'] as String;
    final options = List<String>.from(question['options'] as List);

    return Card(
      color: const Color(0xFF191A2A),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$number. ${question['question']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < options.length; index++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: locked
                      ? null
                      : () {
                          setState(() {
                            answers[id] = index;
                            unsaved = true;
                          });
                          saveSelection();
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: answers[id] == index
                        ? const Color(0xFF8838EF)
                        : Colors.transparent,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(14),
                  ),
                  child: Text(options[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
