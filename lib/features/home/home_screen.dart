import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('OxVPN'),
      ),
      body: const Center(
        child: Text('OxVPN — build works!',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 20)),
      ),
    );
  }
}
