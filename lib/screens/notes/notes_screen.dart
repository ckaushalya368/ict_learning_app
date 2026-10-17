import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late int selectedTab;

  static const background = Color(0xFF090A13);
  static const cardColor = Color(0xFF191A2A);
  static const muted = Color(0xFF9295B1);
  static const purple = Color(0xFF8838EF);

  final units = const [
    (
      title: 'Computer Architecture',
      chapters: 6,
      progress: 78,
      color: Color(0xFF9146FF),
    ),
    (
      title: 'Data Structures & Algorithms',
      chapters: 8,
      progress: 55,
      color: Color(0xFF00CEE4),
    ),
    (
      title: 'Internet & Networking',
      chapters: 7,
      progress: 32,
      color: Color(0xFFFF5277),
    ),
    (
      title: 'Database Management',
      chapters: 5,
      progress: 60,
      color: Color(0xFFFFB522),
    ),
    (
      title: 'Software Engineering',
      chapters: 6,
      progress: 45,
      color: Color(0xFF00D887),
    ),
    (
      title: 'Sustainability & Smart Infrastructure',
      chapters: 8,
      progress: 0,
      color: Color(0xFF00CEE4),
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab == 1 ? 1 : 0;
  }

  void openDetails(String title, String message) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            title: Text(title),
            backgroundColor: cardColor,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: Colors.white,
        title: const Text('Study Material'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Module Notes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2A2B3C)),
                ),
                child: Row(
                  children: [
                    tabButton('📚 Units', 0),
                    tabButton('📋 Past Papers', 1),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (selectedTab == 0)
                ...units.map(
                  (unit) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => openDetails(
                          unit.title,
                          '${unit.title}\n\n'
                          '${unit.chapters} chapters\n\n'
                          'මේක sample unit page එකක්. '
                          'ඊළඟ පියවරේදී මේ unit එකට අදාළ '
                          'chapter list සහ notes එකතු කරමු.\n\n'
                          'දැනට පෙන්වන progress එක demo data.',
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: unit.color,
                                    size: 8,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      unit.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${unit.progress}%',
                                    style: TextStyle(
                                      color: unit.color,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: muted,
                                    size: 18,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 18,
                                  top: 5,
                                ),
                                child: Text(
                                  '${unit.chapters} chapters',
                                  style: const TextStyle(
                                    color: muted,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: unit.progress / 100,
                                  minHeight: 5,
                                  backgroundColor: const Color(0xFF2B2B3D),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    unit.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                ...[2023, 2022, 2021, 2020, 2019].map(
                  (year) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => openPaper(year),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF291C43),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$year',
                                  style: const TextStyle(
                                    color: Color(0xFFAE78FF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'A/L ICT $year',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Paper I & II',
                                      style: TextStyle(
                                        color: muted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: purple,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(48, 32),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                ),
                                onPressed: () => openPaper(year),
                                child: const Text(
                                  'Open',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabButton(String label, int index) {
    final selected = selectedTab == index;

    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: selected ? purple : Colors.transparent,
          foregroundColor: selected ? Colors.white : muted,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        onPressed: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void openPaper(int year) {
    openDetails(
      'A/L ICT $year',
      'මේ paper එකේ questions / PDF තවම එකතු කරලා නැහැ.\n\n'
          'ඊළඟට ඇත්ත paper content එක connect කරලා '
          'answer කිරීම සහ marks ගණනය කිරීම හදමු.',
    );
  }
}
