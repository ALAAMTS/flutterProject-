import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khdamme_project/presentation/auth/pages/sign_in.dart';
import 'package:khdamme_project/presentation/auth/services/authentication.dart';
import 'package:khdamme_project/presentation/auth/widget/snack_bar.dart';
import 'package:khdamme_project/presentation/home/home_client_screen.dart';
import 'package:khdamme_project/presentation/home/home_worker_screen.dart';

import '../../../core/configs/asset/app_vector.dart';
import '../widget/button.dart';
import '../widget/dot_button.dart';
import '../widget/text_sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  bool isWorker = false; // Toggle between Worker and Client
  bool isLoading = false; // Toggle between loading states
  String selectedWorkType = "Electrical"; // Default work type
  void despose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signUp() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    String res;
    if (isWorker) {
      res = await AuthService().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        city: cityController.text,
        dob: dobController.text,
        workType: selectedWorkType,
        isWorker: true,
      );
    } else {
      res = await AuthService().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        isWorker: false,
      );
    }

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              isWorker ? HomeWorkerScreen() : HomeClientScreen(),
        ),
      );
    } else {
      showSnackBar(context, res);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SVG Logo
                SizedBox(
                  width: double.infinity,
                  height: height / 2.7,
                  child: SvgPicture.asset(LogoVector.appLogo),
                ),

                // Toggle Button for Worker/Client
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isWorker = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isWorker ? Colors.orange : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Center(
                            child: Text(
                              "Client",
                              style: TextStyle(
                                color: !isWorker ? Colors.white : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isWorker = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isWorker ? Colors.orange : Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Center(
                            child: Text(
                              "Worker",
                              style: TextStyle(
                                color: isWorker ? Colors.white : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Input Forms
                isWorker
                    ? Column(
                        children: [
                          // Worker Sign Up Form
                          TextFieldInput(
                            textEditingController: nameController,
                            hintText: "Enter your Full Name",
                            icon: Icons.person,
                          ),
                          TextFieldInput(
                            textEditingController: emailController,
                            hintText: "Enter your email address",
                            icon: Icons.email,
                          ),
                          TextFieldInput(
                            textEditingController: passwordController,
                            hintText: "Enter your password",
                            icon: Icons.lock,
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: TextFieldInput(
                                  textEditingController: cityController,
                                  hintText: "Enter your city",
                                  icon: Icons.location_city,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 1,
                                child: DateOfBirthButton(
                                  dobController: dobController,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              value: selectedWorkType,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.work,
                                    color: Colors.black45),
                                filled: true,
                                fillColor: const Color(0xffedf0f8),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors
                                    .black, // Set the selected item text color to black
                                fontSize: 16, // Optionally, set the font size
                              ),
                              dropdownColor: Colors.white,
                              items: <String>[
                                'Electrical',
                                'Mechanic',
                                'Plumbing',
                                'Carpentry'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedWorkType = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          // Client Sign Up Form
                          TextFieldInput(
                            textEditingController: nameController,
                            hintText: "Enter your name",
                            icon: Icons.person,
                          ),
                          TextFieldInput(
                            textEditingController: emailController,
                            hintText: "Enter your email address",
                            icon: Icons.email,
                          ),
                          TextFieldInput(
                            isPass: true,
                            textEditingController: passwordController,
                            hintText: "Enter your password",
                            icon: Icons.lock,
                          ),
                        ],
                      ),

                // Sign Up Button
                MyButton(
                  onTap: signUp,
                  text: isLoading ? "Signing Up" : "SignUp",
                ),

                // Already have an account?
                SizedBox(height: height / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?  ",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogInScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "LogIn",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color.fromARGB(255, 21, 101, 192),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
