import 'package:flutter/material.dart';

class UtolsoEdzesKartya extends StatelessWidget {
  final String nev;
  final int gyakorlatokSzama;
  final int osszSuly;
  final String idoElott;

  const UtolsoEdzesKartya({
    super.key,
    required this.nev,
    required this.gyakorlatokSzama,
    required this.osszSuly,
    required this.idoElott,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
        ],
      ),
      child: Column(
        children: [
          // Fejléc rész
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.08),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    nev.toUpperCase(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color(0xFFFF3B30).withOpacity(0.5),
                        width: 1.5),
                  ),
                  child: Text(
                    idoElott.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFFF3B30),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: theme.dividerColor.withOpacity(0.1)),
          // Statisztika rész
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildStatBox(context, Icons.fitness_center_rounded, const Color(0xFFFF9500),
                    gyakorlatokSzama.toString(), 'GYAKORLAT'),
                const SizedBox(width: 16),
                _buildStatBox(
                    context,
                    Icons.monitor_weight_outlined,
                    const Color(0xFF00D9FF),
                    (osszSuly / 1000).toStringAsFixed(1),
                    'TONNA'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, IconData icon, Color color, String value, String label) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.dividerColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}