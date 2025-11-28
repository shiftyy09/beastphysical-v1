import 'package:flutter/material.dart';
import '../szolgaltatasok/firestore_szolgaltatas.dart';

class HetiCelKartyaUj extends StatelessWidget {
  final int hetiCel;
  final int hetiEdzesek;
  final Function(int) onCelBeallitas;

  const HetiCelKartyaUj({
    super.key,
    required this.hetiCel,
    required this.hetiEdzesek,
    required this.onCelBeallitas,
  });

  Future<void> _hetiCelBeallitasDialog(BuildContext context) async {
    final theme = Theme.of(context);
    int? ujCel = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'HETI CÉL',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hány edzést szeretnél hetente?',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [3, 4, 5, 6, 7].map((szam) {
                  final selected = szam == hetiCel;
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pop(szam),
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(
                                colors: [Color(0xFF00D9FF), Color(0xFF0EA5E9)],
                              )
                            : null,
                        color: selected ? null : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF00D9FF)
                              : theme.dividerColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$szam',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('MÉGSE', style: TextStyle(color: theme.dividerColor)),
            ),
          ],
        );
      },
    );

    if (ujCel != null && ujCel != hetiCel) {
      onCelBeallitas(ujCel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = hetiCel > 0 ? (hetiEdzesek / hetiCel).clamp(0.0, 1.0) : 0.0;
    final elert = hetiEdzesek >= hetiCel;

    return GestureDetector(
      onTap: () => _hetiCelBeallitasDialog(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: elert ? const Color(0xFF10B981) : theme.dividerColor.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
            if (elert)
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D9FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: elert
                          ? const Color(0xFF10B981).withOpacity(0.3)
                          : const Color(0xFF00D9FF).withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    elert ? Icons.check_circle_rounded : Icons.track_changes,
                    color: elert ? const Color(0xFF10B981) : const Color(0xFF00D9FF),
                    size: 24,
                  ),
                ),
                Icon(
                  Icons.edit,
                  color: theme.dividerColor.withOpacity(0.5),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '$hetiEdzesek/$hetiCel',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: elert ? const Color(0xFF10B981) : theme.textTheme.headlineSmall?.color,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'HETI CÉL',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.dividerColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.dividerColor.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  elert ? const Color(0xFF10B981) : const Color(0xFF00D9FF),
                ),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
