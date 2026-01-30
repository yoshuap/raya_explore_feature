import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:raya_explore_feature/features/battery_and_charging_status/logic/battery_repository.dart';
import 'package:raya_explore_feature/features/battery_and_charging_status/logic/battery_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BatteryAndChargingStatus extends StatelessWidget {
  const BatteryAndChargingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BatteryViewModel>.reactive(
      viewModelBuilder: () => BatteryViewModel(BatteryRepository()),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Battery and Charging Status')),
          body: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildBatteryCard(viewModel),
                      const SizedBox(height: 24),
                      _buildDetailsCard(context, viewModel),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildBatteryCard(BatteryViewModel viewModel) {
    final state = viewModel.batteryState;
    final level = viewModel.batteryLevel;

    IconData iconData;
    Color iconColor;

    switch (state) {
      case BatteryState.charging:
        iconData = Icons.battery_charging_full;
        iconColor = Colors.green;
        break;
      case BatteryState.full:
        iconData = Icons.battery_full;
        iconColor = Colors.green;
        break;
      case BatteryState.discharging:
        if (level <= 20) {
          iconData = Icons.battery_alert;
          iconColor = Colors.red;
        } else {
          iconData = Icons.battery_std;
          iconColor = Colors.blue;
        }
        break;
      default:
        iconData = Icons.battery_unknown;
        iconColor = Colors.grey;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        width: double.infinity,
        child: Column(
          children: [
            Icon(iconData, size: 80, color: iconColor),
            const SizedBox(height: 16),
            Text(
              '$level%',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getBatteryStateString(state),
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, BatteryViewModel viewModel) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow(
              'Battery Save Mode',
              viewModel.isBatterySaveMode ? 'On' : 'Off',
              viewModel.isBatterySaveMode ? Icons.bolt : Icons.bolt_outlined,
              viewModel.isBatterySaveMode ? Colors.orange : Colors.grey,
            ),
            const Divider(),
            _buildDetailRow(
              'Last Updated',
              TimeOfDay.now().format(context),
              Icons.update,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  // Note: Added a custom helper for the "Last Updated" text since it's a bit tricky in Stateless.
  // In a real app, the viewModel might provide the timestamp.

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  String _getBatteryStateString(BatteryState? state) {
    if (state == null) return 'Unknown';
    switch (state) {
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.discharging:
        return 'Discharging';
      case BatteryState.full:
        return 'Full';
      case BatteryState.unknown:
        return 'Unknown';
      case BatteryState.connectedNotCharging:
        return 'Plugged in, not charging';
    }
  }
}
