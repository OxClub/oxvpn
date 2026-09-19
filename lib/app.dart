import 'package:flutter/material.dart';

class OxVpnApp extends StatelessWidget {
  const OxVpnApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OxVPN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF14151F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD24034),
          brightness: Brightness.dark,
        ),
      ),
      home: const _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('OxVPN'),
      ),
      body: const Center(
        child: Text(
          'OxVPN — build works!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
