import 'package:flutter/material.dart';
import 'dart:math'; // Véletlenszám generáláshoz
import '../../konstansok/beast_idezetek.dart'; // Idézetek importálása

class BrutalBanner extends StatelessWidget {
  const BrutalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final random = Random();
    final idezet = BeastIdezetek.lista[random.nextInt(BeastIdezetek.lista.length)];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFFFF3B30).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MY BEAST',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.dividerColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  idezet.toUpperCase(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Color(0xFFFF3B30),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
