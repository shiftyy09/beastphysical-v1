import 'package:flutter/material.dart';
import '../../szolgaltatasok/hitelesites_szolgaltatas.dart';

class BrutalHeader extends StatelessWidget {
  final String nev;
  final String? kepUrl;

  const BrutalHeader({super.key, required this.nev, this.kepUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HELLO,',
              style: TextStyle(
                color: theme.dividerColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              nev.toUpperCase(),
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => _showLogoutModal(context),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFF3B30), width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF3B30).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: theme.cardColor,
              backgroundImage: kepUrl != null ? NetworkImage(kepUrl!) : null,
              child: kepUrl == null
                  ? Icon(Icons.person, color: theme.textTheme.bodyLarge?.color, size: 28)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutModal(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    showModalBottomSheet(
      context: context,
      backgroundColor: isLight ? const Color(0xFF2A2A2A) : theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) =>
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isLight ? Colors.grey[600] : Colors.grey[800],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.exit_to_app,
                      color: Color(0xFFFF3B30), size: 28),
                  title: Text(
                    'KIJELENTKEZÉS',
                    style: TextStyle(
                      color: isLight ? Colors.white : Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  onTap: () {
                    HitelesitesSzolgaltatas().kijelentkezes();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}