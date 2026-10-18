import 'package:flutter/material.dart';

import '../notes/notes_screen.dart';
import '../quiz/quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const background = Color(0xFF090A13);
  static const surface = Color(0xFF191A2A);
  static const muted = Color(0xFF9295B1);
  static const purple = Color(0xFF8B46FF);
  static const cyan = Color(0xFF00CEE4);
  static const outline = Color(0xFF2A2B3C);

  void _onTap(BuildContext context, String name) {
    if (name == 'Start Quiz' || name == 'Arena') {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const QuizScreen()));
      return;
    }

    final opensNotes = [
      'Notes',
      'Past Papers',
      'Database Management',
      '2023 A/L ICT Paper',
      'Computer Architecture',
      'Data Structures',
      'Internet & Networks',
    ].contains(name);

    if (opensNotes) {
      final showPapers = name == 'Past Papers' || name == '2023 A/L ICT Paper';

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => NotesScreen(initialTab: showPapers ? 1 : 0),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$name screen coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 0.7,
                colors: [Color(0xFF281249), background],
                stops: [0, 0.65],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good morning, ☀️',
                            style: TextStyle(color: muted, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Kavindi Perera',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'A/L ICT — Grade 12 · Colombo',
                            style: TextStyle(color: muted, fontSize: 12),
                          ),
                          const SizedBox(height: 24),
                          _stats(),
                          const SizedBox(height: 30),
                          _heading('Quick Actions'),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _action(
                                  context,
                                  '⚡',
                                  'Start Quiz',
                                  'Random practice',
                                  featured: true,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _action(
                                  context,
                                  '📋',
                                  'Past Papers',
                                  '2019 – 2023',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _action(
                                  context,
                                  '🎯',
                                  'My Weaknesses',
                                  '3 areas flagged',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _action(
                                  context,
                                  '👥',
                                  'Group Arena',
                                  '4 players online',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          Row(
                            children: [
                              Expanded(child: _heading('✦ AI Recommendations')),
                              const SizedBox(width: 8),
                              const Text(
                                'FOR YOU',
                                style: TextStyle(
                                  color: purple,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _recommendation(
                            context,
                            emoji: '🌐',
                            tag: 'Weak Area',
                            type: 'Quiz',
                            title: 'Network Protocols',
                            description:
                                'OSI Model & TCP/IP — you scored 42% last time',
                            color: const Color(0xFFFF4E75),
                          ),
                          const SizedBox(height: 10),
                          _recommendation(
                            context,
                            emoji: '🗄️',
                            tag: 'Recommended',
                            type: 'Notes',
                            title: 'Database Management',
                            description:
                                'SQL normalization — not studied in 8 days',
                            color: cyan,
                          ),
                          const SizedBox(height: 10),
                          _recommendation(
                            context,
                            emoji: '📝',
                            tag: 'Past Paper',
                            type: 'Practice',
                            title: '2023 A/L ICT Paper',
                            description: 'Section B — Essay questions',
                            color: const Color(0xFFFFB522),
                          ),
                          const SizedBox(height: 26),
                          _heading('Continue Learning'),
                          const SizedBox(height: 14),
                          _learning(
                            context,
                            'Computer Architecture',
                            0.78,
                            purple,
                          ),
                          const SizedBox(height: 10),
                          _learning(context, 'Data Structures', 0.55, cyan),
                          const SizedBox(height: 10),
                          _learning(
                            context,
                            'Internet & Networks',
                            0.32,
                            const Color(0xFFFF4E75),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _navigation(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heading(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(color: muted, fontSize: 10, letterSpacing: 0.7),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: outline),
    );
  }

  Widget _stats() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A102D),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF542396)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('TOTAL XP'),
                  const SizedBox(height: 10),
                  const Text(
                    '4,280',
                    style: TextStyle(
                      color: Color(0xFF9D72FF),
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _progress(0.72, cyan),
                  const SizedBox(height: 8),
                  const Text(
                    '720 XP to Level 6',
                    style: TextStyle(color: muted, fontSize: 9),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: _decoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('STREAK'),
                  const SizedBox(height: 10),
                  const Text(
                    '5 🔥',
                    style: TextStyle(
                      color: Color(0xFFFFAE28),
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(7, (index) {
                      const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.5),
                          child: Column(
                            children: [
                              Container(
                                height: 17,
                                decoration: BoxDecoration(
                                  color: index < 5
                                      ? null
                                      : const Color(0xFF292A3B),
                                  gradient: index < 5
                                      ? const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFFFAE42),
                                            Color(0xFFFF586B),
                                          ],
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                days[index],
                                style: const TextStyle(
                                  color: muted,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _action(
    BuildContext context,
    String emoji,
    String title,
    String subtitle, {
    bool featured = false,
  }) {
    return Container(
      decoration: featured
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8235EF), Color(0xFF5920B5)],
              ),
            )
          : _decoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _onTap(context, title),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: featured ? const Color(0xFFCFB4FF) : muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _recommendation(
    BuildContext context, {
    required String emoji,
    required String tag,
    required String type,
    required String title,
    required String description,
    required Color color,
  }) {
    // Uniform border keeps rounded corners valid.
    // The colored left stripe is drawn separately.
    return Container(
      decoration: _decoration(),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(width: 3, color: color),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onTap(context, title),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color.withAlpha(22),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withAlpha(25),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                type,
                                style: const TextStyle(
                                  color: muted,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: const TextStyle(
                              color: muted,
                              fontSize: 10,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right, color: muted, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progress(double value, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 5,
        backgroundColor: const Color(0xFF2B2B3D),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _learning(
    BuildContext context,
    String title,
    double value,
    Color color,
  ) {
    return Container(
      decoration: _decoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _onTap(context, title),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(value * 100).round()}%',
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _progress(value, color),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navigation(BuildContext context) {
    const labels = ['Home', 'Notes', 'Arena', 'Insights', 'Profile'];

    const icons = [
      Icons.home_outlined,
      Icons.menu_book_rounded,
      Icons.bolt_rounded,
      Icons.track_changes_rounded,
      Icons.account_circle_outlined,
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF10111D),
        border: Border(top: BorderSide(color: outline)),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = index == 0;

          return Expanded(
            child: InkWell(
              onTap: () {
                if (!selected) {
                  _onTap(context, labels[index]);
                }
              },
              child: Container(
                padding: const EdgeInsets.only(top: 13, bottom: 12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: selected ? cyan : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icons[index],
                      size: 21,
                      color: selected
                          ? purple
                          : index == 2
                          ? const Color(0xFFFF9855)
                          : const Color(0xFFBFC5E4),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      labels[index],
                      style: TextStyle(
                        color: selected ? purple : muted,
                        fontSize: 9,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
