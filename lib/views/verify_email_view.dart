import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify Email")),
      body: Column(
        children: [
          Text("Please Verfiy your email address "),
          TextButton(
            onPressed: () async {
              try {
                final user = FirebaseAuth.instance.currentUser;
                print(user);
                if (user != null && !user.emailVerified) {
                  await user.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Verfication email sent to your email address",
                      ),
                    ),
                  );
                  print("Verfication eamil sent to ${user.email}");
                } else {
                  print("user is null or already verified ");
                }
              } catch (e) {
                print("Failed to send verification email : $e");
              }
            },
            child: Text("Send eamil verficiations "),
          ),
        ],
      ),
    );
  }
}
