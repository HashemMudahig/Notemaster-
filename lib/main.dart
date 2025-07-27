import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notemaster/firebase_options.dart';
import 'package:notemaster/views/login_view.dart';
import 'package:notemaster/views/register_view.dart';
import 'package:notemaster/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;
import 'constants/routes.dart';

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
        AppRoutes.login: (context) => const LoginView(),
        AppRoutes.register: (context) => const RegisterView(),
        AppRoutes.notes: (context) => const NotesView(),
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
                return NotesView();
              } else {
                return VerifyEmailView();
              }
            } else {
              return LoginView();
            }

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

enum MenueAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main UI"),
        actions: [
          PopupMenuButton<MenueAction>(
            onSelected: (value) async {
              switch (value) {
                case MenueAction.logout:
                  final shouldLogout = await ShowLogOutDiolg(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(AppRoutes.login, (__) => false);
                  }
                  devtools.log(shouldLogout.toString());
              } // print the selected value
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenueAction>(
                  value: MenueAction.logout,
                  child: Text("Log out "),
                ),
              ];
            },
          ),
        ],
      ),
      body: Text("Hello Text"),
    );
  }
}

Future<bool> ShowLogOutDiolg(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Log out"),
        content: Text("Are you sure you want to log out"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Log out "),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
