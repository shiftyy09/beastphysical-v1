import 'package:flutter/material.dart';

class ProfilKepernyo extends StatelessWidget {
  const ProfilKepernyo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Profil Képernyő',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
