import 'package:event_scheduler_project/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    void signOut() async {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Account Page")),
      body: Container(
          child: ElevatedButton(
        child: Text('Sign out'),
        onPressed: () => {signOut()},
      )),
    );
  }
}
