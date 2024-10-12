import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khdamme_project/presentation/auth/widget/snack_bar.dart';

class Forgetpasswrod extends StatefulWidget {
  const Forgetpasswrod({super.key});

  @override
  State<Forgetpasswrod> createState() => _ForgetpasswrodState();
}

class _ForgetpasswrodState extends State<Forgetpasswrod> {
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                MyDialogBox(context);
              },
              child: Text("forget Password ? ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue)),
            )));
  }


void MyDialogBox(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(
                        "Forget Your Password",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                   TextField(
                    controller: emailController ,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter the emai",
                      hintText: "eg abc@gmail.com",
                      labelStyle: const TextStyle(
                      color: Colors.black, // Set the label text color to black
                      backgroundColor: Color.fromRGBO(224, 178, 98, 1), // Label background white
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    fillColor: Color.fromRGBO(224, 178, 98, 1), // Ensure input field background is white
                    filled: true, // Ensures the background color is applied
                  ),
                ),
                const SizedBox(height: 20),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange) ,
                      onPressed: () async{
                        await auth.sendPasswordResetEmail(email: emailController.text).then((value){
                        showSnackBar(context, "we have send you a reset link to your email address");
                        }).onError((error,StackTrace){
                          showSnackBar(context, error.toString());
                        });
                        Navigator.pop(context);
                        emailController.clear();
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ))
                ],
              ),
            ));
      });
}
}