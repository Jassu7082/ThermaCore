import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'providers.dart';
import 'ui/dashboard/dashboard_screen.dart';
import 'ui/zone_detail/zone_detail_screen.dart';
import 'ui/history/history_screen.dart';
import 'ui/settings/settings_screen.dart';

class ThermaCoreApp extends ConsumerWidget {
  const ThermaCoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAmoled = ref.watch(amoledModeProvider);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const _MainScaffold(),
        ),
        GoRoute(
          path: '/zone_detail',
          builder: (context, state) => const ZoneDetailScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'ThermaCore',
      debugShowCheckedModeBanner: false,
      theme: isAmoled ? AppTheme.amoled : AppTheme.dark,
      routerConfig: router,
    );
  }
}

class _MainScaffold extends ConsumerStatefulWidget {
  const _MainScaffold();

  @override
  ConsumerState<_MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<_MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    HistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Start listening for notifications/alerts instantly.
    ref.read(alertListenerProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
