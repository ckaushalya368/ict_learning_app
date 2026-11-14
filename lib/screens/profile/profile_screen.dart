import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final photo = user?.photoURL?.trim() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF090A13),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF191A2A),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              foregroundImage: photo.isEmpty ? null : NetworkImage(photo),
              child: const Icon(Icons.person_outline, size: 42),
            ),
          ),
          const SizedBox(height: 20),
          _detail('Student name', user?.displayName),
          _detail('Email', user?.email),
          _detail('Phone number', user?.phoneNumber),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.receipt_long, color: Colors.white70),
            title: const Text(
              'Payment History',
              style: TextStyle(color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white70),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Payment History')),
                  body: const Center(
                    child: Text('Payment history is coming soon.'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail(String label, String? value) {
    final text = value?.trim() ?? '';

    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white70)),
      subtitle: Text(
        text.isEmpty ? 'Not added' : text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
