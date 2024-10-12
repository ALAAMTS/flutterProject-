import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:khdamme_project/core/configs/theme/app_theme.dart';
import 'package:khdamme_project/presentation/auth/pages/sign_in.dart';
import 'package:khdamme_project/presentation/home/home_worker_screen.dart';
import 'presentation/home/home_client_screen.dart';
import 'presentation/splash/bloc/splash_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create: (context) => SplashBloc()..appStarted(),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.appTheme,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // User is logged in
            if (snapshot.hasData) {
              // Get the current user's ID
              String userId = snapshot.data!.uid;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while fetching user data
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    // Get user data
                    Map<String, dynamic>? userData = userSnapshot.data!.data() as Map<String, dynamic>?;

                    // Check if the user is a worker or a client
                    if (userData != null && userData['isWorker'] == true) {
                      // Navigate to WorkerHomeScreen
                      return const HomeWorkerScreen();
                    } else {
                      // Navigate to ClientHomeScreen
                      return const HomeClientScreen();
                    }
                  } else {
                    // If user data does not exist, redirect to sign-in
                    return const LogInScreen();
                  }
                },
              );
            } else {
              // User is not logged in, show the login screen
              return const LogInScreen();
            }
          },
        ),
      ),
    );
  }
}
