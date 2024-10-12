import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khdamme_project/presentation/auth/forgetPassword/forgetPasswrod.dart';
import 'package:khdamme_project/presentation/auth/pages/sign_up.dart';
import 'package:khdamme_project/presentation/auth/services/authentication.dart';
import 'package:khdamme_project/presentation/auth/widget/button.dart';
import 'package:khdamme_project/presentation/auth/widget/snack_bar.dart';
import 'package:khdamme_project/presentation/auth/widget/text_sign_in.dart';

import '../../../core/configs/asset/app_vector.dart';
import '../../home/home_client_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  @override 
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signInUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthService().signInUser(
      email: emailController.text,
      password: passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (res == "worker") {
      // Navigate to WorkerScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeClientScreen()),
      );
    } else if (res == "client") {
      // Navigate to ClientScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeClientScreen()),
      );
    } else {
      // Show error message
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,  // Ensures the screen adjusts when the keyboard appears
      body: SafeArea(
        child: SingleChildScrollView(  // Wrap the content with SingleChildScrollView
          child: SizedBox(
            height: height,  // Set the height of the view
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height / 3,
                  child: SvgPicture.asset(
                    LogoVector.appLogo,
                  ),
                ),
                TextFieldInput(
                    textEditingController: emailController,
                    hintText: "Enter your email address",
                    icon: Icons.email),
                TextFieldInput(
                  isPass: true,
                    textEditingController: passwordController,
                    hintText: "Enter your password",
                    icon: Icons.lock),
                const Forgetpasswrod(),
                MyButton(onTap: signInUser, text: isLoading ? "Signing In" : "Sign In",),
                SizedBox(height: height / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't HAVE AN ACCOUNT?  ",
                      style: TextStyle(color: Colors.grey[700], fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        " SignUp   ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color.fromARGB(255, 21, 101, 192),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
