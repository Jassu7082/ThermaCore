import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/file_exporter.dart';
import '../../data/models/thermal_reading.dart';
import '../../providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Export'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.primary),
            onPressed: () => _exportData(context, ref),
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.analytics_outlined, size: 80, color: AppColors.muted),
              SizedBox(height: 20),
              Text(
                'HISTORY BUFFER',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Recent temperature data is held in an in-memory ring buffer (last 60 points per zone).\n\nTap the share icon above to export the current buffer as a CSV file.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final historyMap = ref.read(historyProvider);
    final allReadings = historyMap.values.expand((element) => element).toList();
    
    if (allReadings.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data to export yet.')),
      );
      return;
    }

    final exporter = FileExporter();
    final session = DateTime.now().millisecondsSinceEpoch.toString();
    
    try {
      await exporter.exportCsv(allReadings, session);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e', style: const TextStyle(color: AppColors.critical))),
      );
    }
  }
}
