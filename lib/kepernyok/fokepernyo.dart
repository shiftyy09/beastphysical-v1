import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';

// Widget importok
import '../widgetek/heti_cel_kartya_uj.dart';
import '../widgetek/fokepernyo_elemek/brutal_header.dart';
import '../widgetek/fokepernyo_elemek/brutal_banner.dart';
import '../widgetek/fokepernyo_elemek/streak_card.dart';
import '../widgetek/fokepernyo_elemek/utolso_edzes_kartya.dart';
import '../widgetek/fokepernyo_elemek/stat_card.dart';
import '../widgetek/fokepernyo_elemek/kovetkezo_edzes_kartya.dart';
import '../widgetek/fokepernyo_elemek/section_title.dart';

// Szolgáltatások
import '../szolgaltatasok/firestore_szolgaltatas.dart';
import '../modellek/edzes.dart';
import 'aktiv_edzes_kepernyo.dart';

class FoKepernyo extends StatefulWidget {
  const FoKepernyo({super.key});

  @override
  State<FoKepernyo> createState() => _FoKepernyoState();
}

class _FoKepernyoState extends State<FoKepernyo> {
  final FirestoreSzolgaltatas _firestoreSzolgaltatas = FirestoreSzolgaltatas();
  late Stream<StepCount> _stepCountStream;
  String _lepesek = '0';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() => _lepesek = event.steps.toString());
  }

  void onStepCountError(error) {
    print('Hiba a lépésszámlálóban: $error');
    setState(() => _lepesek = 'N/A');
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  // Heti cél beállítása callback a HetiCelKartyaUj-ból
  Future<void> _setWeeklyGoal(int newGoal) async {
    await _firestoreSzolgaltatas.hetiCelMentes(newGoal);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final nev = user?.displayName?.split(' ')[0] ?? 'Bajnok';
    final kepUrl = user?.photoURL;

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrutalHeader(nev: nev, kepUrl: kepUrl),
              const SizedBox(height: 32),

              const BrutalBanner(),
              const SizedBox(height: 24),

              // Streak és Heti Cél kártyák StreamBuilderrel
              StreamBuilder<int>(
                stream: _firestoreSzolgaltatas.napiStreakLekeres(),
                builder: (context, streakSnapshot) {
                  final streakDays = streakSnapshot.data ?? 0;
                  return StreamBuilder<int>(
                    stream: _firestoreSzolgaltatas.hetiCelLekeres(),
                    builder: (context, celSnapshot) {
                      final hetiCel = celSnapshot.data ?? 5;
                      return StreamBuilder<int>(
                        stream: _firestoreSzolgaltatas.hetiEdzesekSzama(),
                        builder: (context, edzesekSnapshot) {
                          final hetiEdzesek = edzesekSnapshot.data ?? 0;
                          return Row(
                            children: [
                              Expanded(child: StreakCard(streakDays: streakDays)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: HetiCelKartyaUj(
                                  hetiCel: hetiCel,
                                  hetiEdzesek: hetiEdzesek,
                                  onCelBeallitas: _setWeeklyGoal,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 28),

              const SectionTitle(title: 'UTOLSÓ CSATA'),
              const SizedBox(height: 12),
              _buildUtolsoEdzesLoader(),
              const SizedBox(height: 28),

              const SectionTitle(title: 'TELJESÍTMÉNY'),
              const SizedBox(height: 12),
              _buildStatisztikaGrid(), // Ezt is módosítani fogjuk
              const SizedBox(height: 28),

              const SectionTitle(title: 'KÖVETKEZŐ KÜLDETÉS'),
              const SizedBox(height: 12),
              const KovetkezoEdzesKartya(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildBrutalFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildUtolsoEdzesLoader() {
    return FutureBuilder<Edzes?>(
      future: _firestoreSzolgaltatas.utolsoEdzesLekeres(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard();
        }

        if (snapshot.hasData && snapshot.data != null) {
          final edzes = snapshot.data!;
          final osszSuly = edzes.gyakorlatok.fold<int>(
              0, (sum, gy) => sum + gy.szettek.fold<int>(
              0, (s, sz) => s + (sz.suly * sz.ismetlesek).toInt()));

          return UtolsoEdzesKartya(
            nev: edzes.nev,
            gyakorlatokSzama: edzes.gyakorlatok.length,
            osszSuly: osszSuly,
            idoElott: _getTimeAgo(edzes.datum.toDate()),
          );
        }
        return _buildNoWorkoutCard();
      },
    );
  }

  Widget _buildStatisztikaGrid() {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _firestoreSzolgaltatas.teljesStatisztikaStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [_buildLoadingCard(), _buildLoadingCard(), _buildLoadingCard(), _buildLoadingCard()],
          ); // Vagy egy placeholder
        }

        if (snapshot.hasError) {
          return Text('Hiba: ${snapshot.error}', style: TextStyle(color: Colors.red));
        }

        final stats = snapshot.data ?? {};
        final osszEdzes = stats['osszEdzes']?.toString() ?? '0';
        final osszEmeltSuly = stats['osszEmeltSuly']?.toStringAsFixed(1) ?? '0.0'; // Egy tizedesjegy
        final osszPr = stats['osszPr']?.toString() ?? '0';
        final osszEdzesIdo = stats['osszEdzesIdo']?.toString() ?? '0';

        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            StatCard(
              title: 'EDZÉSEK',
              value: osszEdzes,
              unit: 'db',
              icon: Icons.fitness_center_rounded,
              accentColor: const Color(0xFFFF3B30),
            ),
            StatCard(
              title: 'EMELT SÚLY',
              value: osszEmeltSuly,
              unit: 'tonna',
              icon: Icons.monitor_weight_outlined,
              accentColor: const Color(0xFFFF9500),
            ),
            StatCard(
              title: 'PR-EK',
              value: osszPr,
              unit: 'rekord',
              icon: Icons.workspace_premium_rounded,
              accentColor: const Color(0xFFFFD700),
            ),
            StatCard(
              title: 'EDZÉSIDŐ',
              value: osszEdzesIdo,
              unit: 'óra',
              icon: Icons.timer_outlined,
              accentColor: const Color(0xFF00D9FF),
            ),
          ],
        );
      },
    );
  }

  // Ezek a kis segédek maradhatnak itt, vagy ezeket is kiszervezheted egy 'common_widgets.dart'-ba
  Widget _buildLoadingCard() {
    final theme = Theme.of(context);
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary)),
    );
  }

  Widget _buildNoWorkoutCard() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.fitness_center_rounded, color: theme.dividerColor.withOpacity(0.5), size: 32),
            const SizedBox(height: 16),
            Text('MÉG NINCS EDZÉS', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBrutalFAB(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFE65100),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE65100).withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const AktivEdzesKepernyo())),
          borderRadius: BorderRadius.circular(32),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow_rounded, color: Colors.black, size: 32),
                SizedBox(width: 12),
                Text('EDZÉS INDÍTÁSA',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'most';
  }
}
