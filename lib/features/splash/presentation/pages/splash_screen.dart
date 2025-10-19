import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qemma_task/core/ui/assets_manager/assets_manager.dart';
import 'package:qemma_task/features/home/presentation/pages/home_screen.dart';
import 'package:qemma_task/features/splash/presentation/cubit/splash_cubit.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..startSplash(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.isFinished) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Image.asset(
                AssetsManager.logo,
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
