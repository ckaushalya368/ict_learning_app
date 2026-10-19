import 'package:flutter/material.dart';

class UnitOneScreen extends StatelessWidget {
  const UnitOneScreen({super.key});

  static const background = Color(0xFF090A13);
  static const surface = Color(0xFF191A2A);
  static const purple = Color(0xFFAE78FF);
  static const muted = Color(0xFF9295B1);

  static const lessons = [
    (
      title: 'සාම්ප්‍රදායික ක්‍රමවල ගැටලු',
      content: '''
දත්ත හා තොරතුරු විශාල ප්‍රමාණයක් සාම්ප්‍රදායික ක්‍රමවලින් හසුරුවන විට ගැටලු ඇති විය හැකිය.

ප්‍රධාන ගැටලු

• මන්දගාමී බව — Slowness
දත්ත එකතු කිරීම, සැකසීම සහ ප්‍රතිඵල නිකුත් කිරීම සඳහා වැඩි කාලයක් ගත වේ.

• විශ්වසනීයත්වය අඩුවීම — Unreliability
දත්ත රැස් කිරීම සහ සැකසීම අතර කාලය තුළ සැබෑ තත්ත්වය වෙනස් විය හැකිය.

• නිවැරදි බව අඩුවීම — Inaccuracy
අතින් දත්ත ලිවීමේදී සහ නැවත ඇතුළත් කිරීමේදී වැරදි ඇති විය හැකිය.

උදාහරණය: ජන සංගණනය

නිවෙස්වලින් කඩදාසි පත්‍රවලට තොරතුරු එකතු කර පසුව පරිගණකයට ඇතුළත් කිරීම සඳහා කාලය සහ මිනිස් ශ්‍රමය අවශ්‍ය වේ.

ප්‍රතිඵල නිකුත් කරන විට මුලින් එකතු කළ තොරතුරු වෙනස් වී තිබිය හැකිය.

මතක තබාගන්න

සාම්ප්‍රදායික ක්‍රමවල ගැටලු තේරුම් ගැනීමෙන් දත්ත කළමනාකරණයට තාක්ෂණය අවශ්‍ය වන්නේ ඇයි දැයි පැහැදිලි කළ හැකිය.
''',
    ),
    (
      title: 'තොරතුරු තාක්ෂණයේ බිහිවීම',
      content: '''
සාම්ප්‍රදායික දත්ත සැකසීමේ ගැටලු අඩු කර ගැනීමට යන්ත්‍ර සහ පරිගණක භාවිතයට පැමිණියේය.

පරිගණකවල දායකත්වය

• විශාල දත්ත ප්‍රමාණයක් ඉක්මනින් සැකසීම.
• දත්ත ගබඩා කිරීම සහ නැවත ලබා ගැනීම.
• නැවත නැවත සිදු කරන කාර්යයන් ස්වයංක්‍රීය කිරීම.
• විවිධ ක්ෂේත්‍රවල තොරතුරු හසුරුවීමට සහාය වීම.

වැදගත් කරුණ

පරිගණක භාවිත කළ පමණින් සියලු තොරතුරු නිවැරදි වන්නේ නැත. ඇතුළත් කරන දත්ත සහ භාවිත කරන ක්‍රියාවලියත් නිවැරදි විය යුතුය.
''',
    ),
    (
      title: 'තොරතුරු හා සන්නිවේදන තාක්ෂණයේ එකතුව',
      content: '''
පරිගණකවල තොරතුරු සැකසීමේ හැකියාව සහ සන්නිවේදන තාක්ෂණයේ දත්ත හුවමාරු කිරීමේ හැකියාව එක්වීම ICT සංවර්ධනයට දායක විය.

පරිගණක ජාල

පරිගණක එකිනෙකට සම්බන්ධ කිරීමෙන් දත්ත සහ සම්පත් හුවමාරු කරගත හැකිය.

අන්තර්ජාලය

අන්තර්ජාලය යනු ලොව පුරා ඇති ජාල එකිනෙකට සම්බන්ධ වූ පද්ධතියකි. ඒ හරහා සන්නිවේදනය සඳහා TCP/IP ප්‍රොටෝකෝල කට්ටලය භාවිත වේ.

Packet Switching

දත්ත කුඩා පැකට් ලෙස ජාලය හරහා යැවීම සිදු කරයි.

අන්තර්ජාල සේවා

• විශ්ව ව්‍යාප්ත වියමන — World Wide Web
• විද්‍යුත් තැපෑල — Email
• තොරතුරු සෙවීම සඳහා සෙවුම් යන්ත්‍ර

ජංගම ප්‍රවේශය

ජංගම දුරකථන, ලැප්ටොප් සහ ටැබ්ලට් වැනි උපකරණ මගින් විවිධ ස්ථානවල සිට තොරතුරු ලබා ගැනීමට හැකියාව ලැබේ.

මතක තබාගන්න

Internet සහ WWW එකම දෙයක් නොවේ. WWW යනු අන්තර්ජාලය හරහා ලබාගන්නා සේවාවකි.
''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Unit 1: Concept of ICT'),
        backgroundColor: surface,
        foregroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                '1.2 තාක්ෂණයේ අවශ්‍යතාව',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'දත්ත හා තොරතුරු නිර්මාණය, බෙදාහැරීම සහ '
                'කළමනාකරණය සඳහා තාක්ෂණයේ අවශ්‍යතාව',
                style: TextStyle(color: muted, fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 12),
              const Text(
                'එවූ PDF එක ඇසුරෙන් සකස් කළ සාරාංශ පාඩම්',
                style: TextStyle(color: purple, fontSize: 12),
              ),
              const SizedBox(height: 24),
              ...List.generate(lessons.length, (index) {
                final lesson = lessons[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: surface,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF291C43),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: purple),
                        ),
                      ),
                      title: Text(
                        lesson.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: muted),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => _LessonReader(
                              title: lesson.title,
                              content: lesson.content,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonReader extends StatelessWidget {
  const _LessonReader({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A13),
      appBar: AppBar(
        title: const Text('Unit 1 · Lesson 1.2'),
        backgroundColor: const Color(0xFF191A2A),
        foregroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFAE78FF),
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                SelectableText(
                  content.trim(),
                  style: const TextStyle(
                    color: Color(0xFFD5D7E6),
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
