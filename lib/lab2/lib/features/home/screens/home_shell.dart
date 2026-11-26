import 'package:flutter/material.dart';
import 'package:trip_planner/features/countries/screens/countries_screen.dart';
import 'package:trip_planner/features/home/widgets/trips_badge_icon.dart';
import 'package:trip_planner/features/trips/screens/trips_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;

  void _go(int tab) => setState(() => _tab = tab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          const CountriesScreen(),
          TripsScreen(onFindCountry: () => _go(0)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: _go,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.public_outlined),
            selectedIcon: Icon(Icons.public),
            label: 'Countries',
          ),
          NavigationDestination(
            icon: TripsBadgeIcon(selected: false),
            selectedIcon: TripsBadgeIcon(selected: true),
            label: 'My trips',
          ),
        ],
      ),
    );
  }
}
