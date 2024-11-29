import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState(); //manggil itstate bawaan
    // nentuin durasi splash screen
    Future.delayed(const Duration(seconds: 2), () { //ini kayak kalo udh 3 detik bakal ke halaman berikutnya
      Navigator.pushReplacementNamed( //na ini, bakal di replace ke sini
        // ignore: use_build_context_synchronously
        context, '/scanner'); // Navigasi ke halaman utama
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF5B7769),
      body: Center(
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner_outlined, color: Colors.white, size: 140,)
          ],
        ),
      ),
    );
  }
}