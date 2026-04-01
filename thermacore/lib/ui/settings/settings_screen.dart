import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amoledMode = ref.watch(amoledModeProvider);
    final tempUnit = ref.watch(tempUnitProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionHeader('APPEARANCE'),
          SwitchListTile(
            title: const Text('AMOLED True Black', style: TextStyle(fontFamily: 'SpaceMono')),
            subtitle: const Text('Pitch black background for OLED screens', style: TextStyle(color: AppColors.muted, fontSize: 12)),
            value: amoledMode,
            onChanged: (val) => ref.read(amoledModeProvider.notifier).state = val,
            activeColor: AppColors.primary,
          ),
          
          const SizedBox(height: 24),
          _SectionHeader('PREFERENCES'),
          ListTile(
            title: const Text('Temperature Unit', style: TextStyle(fontFamily: 'SpaceMono')),
            trailing: SegmentedButton<TempUnit>(
              segments: const [
                ButtonSegment(value: TempUnit.celsius, label: Text('°C')),
                ButtonSegment(value: TempUnit.fahrenheit, label: Text('°F')),
                ButtonSegment(value: TempUnit.kelvin, label: Text('K')),
              ],
              selected: {tempUnit},
              onSelectionChanged: (set) => ref.read(tempUnitProvider.notifier).state = set.first,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) => 
                  states.contains(WidgetState.selected) ? AppColors.primary.withOpacity(0.2) : Colors.transparent),
                foregroundColor: WidgetStateProperty.resolveWith((states) => 
                  states.contains(WidgetState.selected) ? AppColors.primary : AppColors.muted),
                side: const WidgetStatePropertyAll(BorderSide(color: AppColors.border)),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'ThermaCore v1.0.0\nOpen Source / GPL-3.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5),
            ),
          )
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Orbitron',
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
