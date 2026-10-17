import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  int selectedTab = 0;

  static const background = Color(0xFF090A13);
  static const surface = Color(0xFF191A2A);
  static const muted = Color(0xFF9295B1);
  static const purple = Color(0xFF8838EF);
  static const outline = Color(0xFF2A2B3C);

  final List<String> units = const [
    'Concept of ICT',
    'Evolution of Computers',
    'Data Representation',
    'Digital Circuits',
    'Computer Operating Systems',
    'Data Communication and Networking',
    'System Analysis and Design',
    'Database Management Systems',
    'Programming',
    'Web Development',
    'Internet of Things (IoT) and Embedded Systems',
    'ICT in Business',
    'New Trends and Future ICT',
  ];

  final List<Color> unitColors = const [
    Color(0xFF9146FF),
    Color(0xFF00CEE4),
    Color(0xFFFF5277),
    Color(0xFFFFB522),
    Color(0xFF00D887),
  ];

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab == 1 ? 1 : 0;
  }

  void _openDetails(String title, String message) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: surface,
            foregroundColor: Colors.white,
            title: Text(title, style: const TextStyle(fontSize: 17)),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.7,
                  ),
                ),
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
        title: const Text(
          'Study Material',
          style: TextStyle(color: muted, fontSize: 14),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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

              // Units / Past Papers tabs
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: outline),
                ),
                child: Row(
                  children: [
                    _tabButton('Units', Icons.menu_book_rounded, 0),
                    _tabButton('Past Papers', Icons.description_outlined, 1),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (selectedTab == 0)
                ...List.generate(units.length, (index) => _unitCard(index))
              else
                ...[
                  2023,
                  2022,
                  2021,
                  2020,
                  2019,
                ].map((year) => _paperCard(year)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String label, IconData icon, int index) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _unitCard(int index) {
    final title = units[index];
    final color = unitColors[index % unitColors.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _openDetails(
                'Unit ${index + 1}: $title',
                'Chapters and notes for this unit '
                    'have not been added yet.',
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UNIT ${index + 1}',
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '0%',
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, color: muted, size: 18),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Notes coming soon',
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 0,
                      minHeight: 5,
                      backgroundColor: const Color(0xFF2B2B3D),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _paperCard(int year) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openPaper(year),
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
                          style: TextStyle(color: muted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: () => _openPaper(year),
                    child: const Text('Open', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openPaper(int year) {
    _openDetails(
      'A/L ICT $year',
      'Questions and PDF content for this paper '
          'have not been added yet.',
    );
  }
}
