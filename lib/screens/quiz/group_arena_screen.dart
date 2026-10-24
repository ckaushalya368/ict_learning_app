import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/backend_service.dart';
import 'group_quiz_panel.dart';

const _background = Color(0xFF090A13);
const _surface = Color(0xFF191A2A);
const _purple = Color(0xFF8838EF);
const _muted = Color(0xFF9295B1);

class GroupArenaScreen extends StatefulWidget {
  const GroupArenaScreen({super.key});

  @override
  State<GroupArenaScreen> createState() => _GroupArenaScreenState();
}

class _GroupArenaScreenState extends State<GroupArenaScreen> {
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool joining = false;
  bool busy = false;

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    super.dispose();
  }

  Future<String> createRoom(String uid, String name) async {
    final db = FirebaseFirestore.instance;

    for (var attempt = 0; attempt < 5; attempt++) {
      final code = (100000 + Random.secure().nextInt(900000)).toString();
      final room = db.collection('rooms').doc(code);

      final created = await db.runTransaction<bool>((transaction) async {
        final snapshot = await transaction.get(room);

        if (snapshot.exists) return false;

        transaction.set(room, {
          'hostId': uid,
          'status': 'waiting',
          'createdAt': FieldValue.serverTimestamp(),
        });

        transaction.set(room.collection('players').doc(uid), {
          'name': name,
          'joinedAt': FieldValue.serverTimestamp(),
        });

        return true;
      });

      if (created) return code;
    }

    throw Exception('Could not generate a room code. Please try again.');
  }

  Future<void> joinRoom(String code, String uid, String name) async {
    final room = FirebaseFirestore.instance.collection('rooms').doc(code);
    final player = room.collection('players').doc(uid);

    await FirebaseFirestore.instance.runTransaction<void>((transaction) async {
      final roomSnapshot = await transaction.get(room);
      final playerSnapshot = await transaction.get(player);

      if (!roomSnapshot.exists) {
        throw Exception('Room not found. Check your code.');
      }

      if (roomSnapshot.data()?['status'] != 'waiting') {
        throw Exception('This room is closed.');
      }

      // Existing membership එකක් තිබුණොත් නැවත create කරන්නේ නැහැ.
      if (!playerSnapshot.exists) {
        transaction.set(player, {
          'name': name,
          'joinedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Future<void> openLobby() async {
    if (busy || !formKey.currentState!.validate()) return;

    final isHost = !joining;
    final name = nameController.text.trim();
    final enteredCode = codeController.text.trim();

    setState(() => busy = true);

    try {
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser ?? (await auth.signInAnonymously()).user;

      if (user == null) {
        throw Exception('Sign-in failed. Please try again.');
      }

      await BackendService.verifyCurrentPlayer();
      debugPrint('Backend player verification successful');

      final String code;

      if (isHost) {
        code = await createRoom(user.uid, name);
      } else {
        await joinRoom(enteredCode, user.uid, name);
        code = enteredCode;
      }

      if (!mounted) return;

      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => _GroupLobby(roomCode: code, uid: user.uid),
        ),
      );

      // Quiz එක පටන්ගත් පසු participant records තබාගන්නවා.
      final db = FirebaseFirestore.instance;
      final room = db.collection('rooms').doc(code);

      try {
        await db.runTransaction<void>((transaction) async {
          final snapshot = await transaction.get(room);

          if (snapshot.data()?['status'] != 'waiting') return;

          transaction.delete(room.collection('players').doc(user.uid));

          if (isHost) {
            transaction.update(room, {'status': 'closed'});
          }
        });
      } catch (_) {
        if (mounted) {
          showMessage('Could not leave the room. Check your connection.');
        }
      }
    } on FirebaseException catch (error) {
      if (mounted) {
        showMessage('${error.code}: ${error.message ?? 'Please try again.'}');
      }
    } catch (error) {
      if (mounted) {
        showMessage(error.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => busy = false);
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _muted),
      counterStyle: const TextStyle(color: _muted),
      filled: true,
      fillColor: _surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('Group Arena'),
        backgroundColor: _surface,
        foregroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.groups_rounded,
                    size: 64,
                    color: Color(0xFFAE78FF),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Become the Legend',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Create a group or join your friends.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted),
                  ),
                  const SizedBox(height: 28),
                  SegmentedButton<bool>(
                    style: SegmentedButton.styleFrom(
                      foregroundColor: _muted,
                      selectedForegroundColor: Colors.white,
                      selectedBackgroundColor: _purple,
                    ),
                    segments: const [
                      ButtonSegment(value: false, label: Text('Create Group')),
                      ButtonSegment(value: true, label: Text('Join Group')),
                    ],
                    selected: {joining},
                    onSelectionChanged: busy
                        ? null
                        : (selection) {
                            setState(() => joining = selection.first);
                            formKey.currentState?.reset();
                          },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: nameController,
                    enabled: !busy,
                    style: const TextStyle(color: Colors.white),
                    maxLength: 24,
                    decoration: fieldDecoration('Your name'),
                    validator: (value) {
                      final name = value?.trim() ?? '';
                      if (name.isEmpty) return 'Enter your name';
                      if (name.length > 24) {
                        return 'Use 24 characters or fewer';
                      }
                      return null;
                    },
                  ),
                  if (joining) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: codeController,
                      enabled: !busy,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 6,
                      decoration: fieldDecoration('6-digit room code'),
                      validator: (value) {
                        if (!RegExp(r'^\d{6}$').hasMatch(value?.trim() ?? '')) {
                          return 'Enter a 6-digit code';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: busy ? null : openLobby,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(joining ? 'Join Group' : 'Create Group'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupLobby extends StatefulWidget {
  const _GroupLobby({required this.roomCode, required this.uid});

  final String roomCode;
  final String uid;

  @override
  State<_GroupLobby> createState() => _GroupLobbyState();
}

class _GroupLobbyState extends State<_GroupLobby> {
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> roomStream;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> playersStream;

  Future<Map<String, dynamic>>? leaderboardFuture;

  bool starting = false;
  String? startError;

  @override
  void initState() {
    super.initState();

    final room = FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomCode);

    roomStream = room.snapshots();
    playersStream = room.collection('players').snapshots();
  }

  Future<void> startQuiz() async {
    setState(() {
      starting = true;
      startError = null;
    });

    try {
      await BackendService.startQuiz(widget.roomCode);
    } catch (error) {
      if (mounted) {
        setState(() => startError = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => starting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A13),
      appBar: AppBar(
        title: const Text('Group Arena'),
        backgroundColor: const Color(0xFF191A2A),
        foregroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: roomStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Could not load the room.',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final room = snapshot.data!.data();
              final status = room?['status'];
              final isHost = room?['hostId'] == widget.uid;

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'ROOM ${widget.roomCode}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFAE78FF),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (status == 'waiting')
                    waitingLobby(isHost)
                  else if (status == 'playing')
                    GroupQuizPanel(
                      key: ValueKey(widget.roomCode),
                      roomCode: widget.roomCode,
                    )
                  else if (status == 'finished')
                    leaderboard()
                  else
                    const Text(
                      'This room is closed.',
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      isHost && status == 'waiting'
                          ? 'Close Room & Leave'
                          : 'Back to Group Arena',
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget waitingLobby(bool isHost) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: playersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            'Could not load players. Check Firestore Rules.',
            style: TextStyle(color: Colors.orangeAccent),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final players = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Players · ${players.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            for (final player in players)
              Card(
                color: const Color(0xFF191A2A),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFFAE78FF)),
                  title: Text(
                    player.data()['name'] as String,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    player.id == widget.uid ? 'You' : 'Player',
                    style: const TextStyle(color: Color(0xFF9295B1)),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (startError != null)
              Text(
                startError!,
                style: const TextStyle(color: Colors.orangeAccent),
              ),
            if (isHost)
              ElevatedButton(
                onPressed: starting || players.length < 2 ? null : startQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8838EF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
                child: Text(starting ? 'Starting...' : 'Start Quiz'),
              )
            else
              const Text(
                'Waiting for the host to start...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF9295B1)),
              ),
            if (players.length < 2)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'At least two players are required.',
                  style: TextStyle(color: Color(0xFF9295B1)),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget leaderboard() {
    leaderboardFuture ??= BackendService.getLeaderboard(widget.roomCode);

    return FutureBuilder<Map<String, dynamic>>(
      future: leaderboardFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Column(
            children: [
              Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.orangeAccent),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    leaderboardFuture = BackendService.getLeaderboard(
                      widget.roomCode,
                    );
                  });
                },
                child: const Text('Retry'),
              ),
            ],
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final players = (data['players'] as List)
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            const SizedBox(height: 12),
            const Text(
              'Legend Leaderboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            for (final player in players)
              Card(
                color: const Color(0xFF191A2A),
                child: ListTile(
                  leading: Icon(
                    player['isLegend'] == true
                        ? Icons.emoji_events
                        : Icons.person,
                    color: player['isLegend'] == true
                        ? Colors.amber
                        : const Color(0xFFAE78FF),
                  ),
                  title: Text(
                    '${player['name']}'
                    '${player['uid'] == widget.uid ? ' · You' : ''}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    player['isLegend'] == true ? 'Legend' : 'Completed',
                    style: const TextStyle(color: Color(0xFF9295B1)),
                  ),
                  trailing: Text(
                    '${player['score']}/${data['total']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
