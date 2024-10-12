import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khdamme_project/presentation/auth/pages/sign_in.dart';
import 'package:khdamme_project/presentation/splash/bloc/splash_bloc.dart';
import '../../../core/configs/asset/app_vector.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Animation duration
    );

    // Define animation for resizing the SVG
    _sizeAnimation = Tween<double>(begin: 50, end: 80).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
    Future.delayed(const Duration(seconds: 1), );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc,SplashState>(
      listener: (context , state){
        if (state is Unauthenticated){
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>const LogInScreen()));
        }else if (state is Authenticated){
          Navigator.of(context).pushReplacementNamed('/sign_in');
        }
      },

    child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 243),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated container for resizing the SVG picture
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SvgPicture.asset(
                  AppVector.appLogo,
                  width: _sizeAnimation.value, // Animate the width
                  height: _sizeAnimation.value, // Animate the height
                );
              },
            ),      
          ],
        ),
      ),
    )
    );
  }
}

