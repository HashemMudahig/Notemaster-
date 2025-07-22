import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notemaster/firebase_options.dart';
import 'package:notemaster/views/login_view.dart';
import 'package:notemaster/views/register_view.dart';
import 'package:notemaster/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Homepage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print("Email is verified");
              } else {
                return VerifyEmailView();
              }
            } else {
              return LoginView();
            }

            return Text("Done");

          // final user = (FirebaseAuth.instance.currentUser);
          // if (user?.emailVerified ?? false) {
          //   return const Text("Done");
          // } else {
          //   return VerifyEmailView();

          //   /// this WidgetsBinding.instance.addPostFrameCallback is telling the flutter to to open Verfiy page after the build done the built
          // }

          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
