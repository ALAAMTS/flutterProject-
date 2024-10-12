import 'package:flutter/material.dart';
import 'package:khdamme_project/presentation/auth/pages/sign_in.dart';
import 'package:khdamme_project/presentation/auth/services/authentication.dart';
import 'package:khdamme_project/presentation/auth/widget/button.dart';

class HomeClientScreen extends StatefulWidget {
  const HomeClientScreen({super.key});

  @override
  State<HomeClientScreen> createState() => _HomeClientScreenState();
}

class _HomeClientScreenState extends State<HomeClientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "client Screen\nYou are client ofr MTS construction now ",
              style: TextStyle(fontSize: 24),
            ),
            MyButton(
                onTap: () async {
                  await AuthService().signOutUser();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LogInScreen(),
                    ),
                  );
                },
                text: "logOuT")
          ],
        ),
      ),
    );
  }
}
