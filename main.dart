import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HendiConnectApp());
}

class HendiConnectApp extends StatefulWidget {
  const HendiConnectApp({super.key});

  @override
  State<HendiConnectApp> createState() => _HendiConnectAppState();
}

class _HendiConnectAppState extends State<HendiConnectApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _seed = const Color(0xFF16865B);

  void _setTheme(Color color, ThemeMode mode) {
    setState(() {
      _seed = color;
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hendi Connect',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
      ),
      home: WelcomeGate(
        onThemeChanged: _setTheme,
      ),
    );
  }
}

class WelcomeGate extends StatefulWidget {
  const WelcomeGate({super.key, required this.onThemeChanged});
  final void Function(Color, ThemeMode) onThemeChanged;

  @override
  State<WelcomeGate> createState() => _WelcomeGateState();
}

class _WelcomeGateState extends State<WelcomeGate> {
  bool _showLogin = false;

  @override
  Widget build(BuildContext context) {
    if (_showLogin) {
      return AuthPage(
        onAuthenticated: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => IntroPage(
                onContinue: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => HomePage(
                        onThemeChanged: widget.onThemeChanged,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF071D17), Color(0xFF0F6547), Color(0xFF102A24)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Container(
                  height: 76,
                  width: 76,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(Icons.forum_rounded,
                      color: Colors.white, size: 38),
                ),
                const SizedBox(height: 24),
                const Text(
                  'HENDI\nCONNECT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Connect, communicate, and build communities.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFB9F3D6),
                      foregroundColor: const Color(0xFF073B29),
                      padding: const EdgeInsets.symmetric(vertical: 17),
                    ),
                    onPressed: () => setState(() => _showLogin = true),
                    child: const Text('Mulai Sekarang',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Hendi Connect • Foundation Build 1.0',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.onAuthenticated});
  final VoidCallback onAuthenticated;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _pin = TextEditingController();
  bool _register = true;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _pin.dispose();
    super.dispose();
  }

  void _continue() {
    if (_email.text.trim().isEmpty ||
        _password.text.isEmpty ||
        _pin.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi email, password, dan PIN minimal 4 angka.'),
        ),
      );
      return;
    }
    widget.onAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Akun Hendi Connect')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.lock_person_rounded, size: 54, color: colors.primary),
          const SizedBox(height: 16),
          Text(
            _register ? 'Buat akun baru' : 'Selamat datang kembali',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Foundation Build menggunakan formulir demo. '
            'Autentikasi server belum dihubungkan.',
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _password,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.key_rounded),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _pin,
            keyboardType: TextInputType.number,
            maxLength: 6,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'PIN keamanan (4–6 angka)',
              prefixIcon: Icon(Icons.pin_rounded),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _continue,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(_register ? 'Buat Akun (Demo)' : 'Login (Demo)'),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _register = !_register),
            child: Text(_register
                ? 'Sudah punya akun? Login'
                : 'Belum punya akun? Daftar'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Jangan gunakan password atau PIN asli pada build demo ini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  const IntroPage({super.key, required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF08271D), Color(0xFF16865B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.waving_hand_rounded,
                    color: Colors.white, size: 68),
                const SizedBox(height: 24),
                const Text(
                  'WELCOME TO\nHENDI CONNECT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Satu tempat untuk chat, komunitas, panggilan, dan AI.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onContinue,
                    child: const Text('Lewati Intro & Masuk'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onThemeChanged});
  final void Function(Color, ThemeMode) onThemeChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  static const _tabs = [
    _TabInfo('Chat', Icons.chat_bubble_outline_rounded),
    _TabInfo('Status', Icons.circle_outlined),
    _TabInfo('Community', Icons.groups_outlined),
    _TabInfo('Calls', Icons.call_outlined),
    _TabInfo('Settings', Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hendi Connect',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Cari',
            onPressed: () => _notice('Pencarian akan dihubungkan pada fase chat.'),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'QR',
            onPressed: () => _notice('QR profile akan tersedia pada fase berikutnya.'),
            icon: const Icon(Icons.qr_code_rounded),
          ),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          const ChatTab(),
          const FeatureTab(
            icon: Icons.auto_awesome_motion,
            title: 'Status',
            description: 'Bagikan foto, video, atau teks kepada kontak.',
            features: ['Status foto', 'Status video', 'Penonton status', 'Privasi status'],
          ),
          const FeatureTab(
            icon: Icons.groups_rounded,
            title: 'Community',
            description: 'Bangun komunitas dan kelola beberapa grup.',
            features: ['Buat komunitas', 'Grup komunitas', 'Undangan anggota'],
          ),
          const FeatureTab(
            icon: Icons.video_call_rounded,
            title: 'Calls',
            description: 'Voice call, video call, dan panggilan grup.',
            features: ['Voice call', 'Video call', 'Group call', 'Screen sharing'],
          ),
          SettingsTab(
            onThemeChanged: widget.onThemeChanged,
            onNotice: _notice,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => setState(() => _tab = value),
        destinations: [
          for (final item in _tabs)
            NavigationDestination(
              icon: Icon(item.icon),
              label: item.label,
            ),
        ],
      ),
    );
  }

  void _notice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _TabInfo {
  const _TabInfo(this.label, this.icon);
  final String label;
  final IconData icon;
}

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('AI Chat Biasa', 'Asisten AI siap membantu', Icons.smart_toy_outlined),
      ('AI Ejen', 'Asisten dengan karakter khusus', Icons.psychology_outlined),
      ('Chat Owner', 'Hubungi pemilik aplikasi', Icons.verified_user_outlined),
      ('Chat Admin', 'Pusat bantuan pengguna', Icons.support_agent_outlined),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Cari chat atau pengguna',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF0D6848), Color(0xFF123D30)],
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.forum_rounded, color: Colors.white, size: 34),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your conversations',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text('Mulai percakapan baru di Hendi Connect.',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        for (final item in items)
          Card(
            elevation: 0,
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(item.$3),
              ),
              title: Text(item.$1),
              subtitle: Text(item.$2),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.$1} akan diaktifkan pada fase berikutnya.')),
              ),
            ),
          ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Belum ada percakapan. Backend chat belum dihubungkan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class FeatureTab extends StatelessWidget {
  const FeatureTab({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
  });

  final IconData icon;
  final String title;
  final String description;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Icon(icon, size: 54, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 14),
        Text(title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        const SizedBox(height: 8),
        Text(description),
        const SizedBox(height: 22),
        for (final feature in features)
          Card(
            elevation: 0,
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(feature),
              trailing: const Icon(Icons.lock_clock, size: 18),
            ),
          ),
        const SizedBox(height: 12),
        const Text(
          'Modul ini merupakan rancangan UI. Integrasi server dan fitur realtime dikerjakan pada fase berikutnya.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class SettingsTab extends StatefulWidget {
  const SettingsTab({
    super.key,
    required this.onThemeChanged,
    required this.onNotice,
  });

  final void Function(Color, ThemeMode) onThemeChanged;
  final void Function(String) onNotice;

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _business = false;
  bool _strict = false;
  bool _autoReply = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Pengaturan',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        const SizedBox(height: 16),
        _section('Mode aplikasi'),
        SwitchListTile(
          title: const Text('Mode Bisnis'),
          subtitle: const Text('Profil dan fitur bisnis'),
          value: _business,
          onChanged: (v) => setState(() => _business = v),
        ),
        SwitchListTile(
          title: const Text('Mode Ketat'),
          subtitle: const Text('Kontrol privasi dan filter pesan'),
          value: _strict,
          onChanged: (v) => setState(() => _strict = v),
        ),
        SwitchListTile(
          title: const Text('Auto Reply'),
          subtitle: const Text('Balasan otomatis (demo)'),
          value: _autoReply,
          onChanged: (v) => setState(() => _autoReply = v),
        ),
        const Divider(height: 28),
        _section('Tema aplikasi'),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _themeButton('Hijau', const Color(0xFF16865B), ThemeMode.dark),
            _themeButton('Merah', const Color(0xFFB8324A), ThemeMode.dark),
            _themeButton('Biru', const Color(0xFF5A91C9), ThemeMode.light),
            _themeButton('Ungu', const Color(0xFF8055B5), ThemeMode.dark),
            _themeButton('Gold', const Color(0xFFB18A35), ThemeMode.dark),
          ],
        ),
        const Divider(height: 28),
        _section('Lainnya'),
        ListTile(
          leading: const Icon(Icons.qr_code),
          title: const Text('QR Profile'),
          onTap: () => widget.onNotice('QR akan tersedia pada fase berikutnya.'),
        ),
        ListTile(
          leading: const Icon(Icons.volunteer_activism_outlined),
          title: const Text('Donasi Owner'),
          onTap: () => widget.onNotice('Informasi donasi akan ditambahkan kemudian.'),
        ),
        ListTile(
          leading: const Icon(Icons.admin_panel_settings_outlined),
          title: const Text('Owner / Admin Center'),
          subtitle: const Text('Panel contoh — akses backend belum aktif'),
          onTap: () => widget.onNotice('Panel admin memerlukan autentikasi dan permission backend.'),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Tentang Hendi Connect'),
          subtitle: const Text('Foundation Build 1.0'),
        ),
      ],
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      );

  Widget _themeButton(String label, Color color, ThemeMode mode) {
    return OutlinedButton.icon(
      onPressed: () => widget.onThemeChanged(color, mode),
      icon: CircleAvatar(radius: 7, backgroundColor: color),
      label: Text(label),
    );
  }
}
