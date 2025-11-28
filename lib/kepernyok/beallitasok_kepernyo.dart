import 'package:flutter/material.dart';

class BeallitasokKepernyo extends StatefulWidget {
  final Function? atvaltoTema;
  final bool vilagTema;

  const BeallitasokKepernyo({
    super.key,
    this.atvaltoTema,
    this.vilagTema = false,
  });

  @override
  State<BeallitasokKepernyo> createState() => _BeallitasokKepernyoState();
}

class _BeallitasokKepernyoState extends State<BeallitasokKepernyo> {
  late bool _localVilagTema;

  @override
  void initState() {
    super.initState();
    _localVilagTema = widget.vilagTema;
  }

  @override
  void didUpdateWidget(BeallitasokKepernyo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vilagTema != widget.vilagTema) {
      _localVilagTema = widget.vilagTema;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _localVilagTema ? Colors.white : const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: _localVilagTema ? const Color(0xFFE65100) : const Color(0xFF1A1A1A),
        title: const Text(
          'Beállítások',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Téma beállítás
          Container(
            decoration: BoxDecoration(
              color: _localVilagTema ? Colors.grey[100] : const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _localVilagTema ? Colors.grey[300]! : Colors.grey[700]!,
              ),
            ),
            child: ListTile(
              leading: Icon(
                _localVilagTema ? Icons.light_mode : Icons.dark_mode,
                color: const Color(0xFFE65100),
                size: 28,
              ),
              title: Text(
                'Téma',
                style: TextStyle(
                  color: _localVilagTema ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _localVilagTema ? 'Világos téma' : 'Sötét téma',
                style: TextStyle(
                  color: _localVilagTema ? Colors.grey[700] : Colors.grey[400],
                ),
              ),
              trailing: Switch(
                value: _localVilagTema,
                onChanged: (value) {
                  setState(() {
                    _localVilagTema = value;
                  });
                  widget.atvaltoTema?.call();
                },
                activeColor: const Color(0xFFE65100),
                inactiveThumbColor: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // További beállítások placeholder-ek
          Container(
            decoration: BoxDecoration(
              color: _localVilagTema ? Colors.grey[100] : const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _localVilagTema ? Colors.grey[300]! : Colors.grey[700]!,
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.notifications,
                color: Color(0xFFE65100),
                size: 28,
              ),
              title: Text(
                'Értesítések',
                style: TextStyle(
                  color: _localVilagTema ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Hamarosan elérhető',
                style: TextStyle(
                  color: _localVilagTema ? Colors.grey[700] : Colors.grey[400],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: _localVilagTema ? Colors.grey[100] : const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _localVilagTema ? Colors.grey[300]! : Colors.grey[700]!,
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.privacy_tip,
                color: Color(0xFFE65100),
                size: 28,
              ),
              title: Text(
                'Adatvédelem',
                style: TextStyle(
                  color: _localVilagTema ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Hamarosan elérhető',
                style: TextStyle(
                  color: _localVilagTema ? Colors.grey[700] : Colors.grey[400],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: _localVilagTema ? Colors.grey[100] : const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _localVilagTema ? Colors.grey[300]! : Colors.grey[700]!,
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.info,
                color: Color(0xFFE65100),
                size: 28,
              ),
              title: Text(
                'Rólunk',
                style: TextStyle(
                  color: _localVilagTema ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Verzió 1.0.0',
                style: TextStyle(
                  color: _localVilagTema ? Colors.grey[700] : Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
