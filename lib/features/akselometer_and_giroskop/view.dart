import 'package:flutter/material.dart';
import 'package:raya_explore_feature/features/akselometer_and_giroskop/logic/sensor_repository.dart';
import 'package:raya_explore_feature/features/akselometer_and_giroskop/logic/sensor_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AkselometerAndGiroskop extends StatelessWidget {
  const AkselometerAndGiroskop({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SensorViewModel>.reactive(
      // In a real app with dependency injection (like get_it),
      // you would likely get the repository from a service locator.
      // For this refactor, we instantiate it here or pass it.
      viewModelBuilder: () => SensorViewModel(SensorRepository()),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Akselometer and Giroskop')),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSensorCard(
                'User Accelerometer',
                viewModel.userAccelerometerEvent != null
                    ? 'X: ${viewModel.userAccelerometerEvent!.x.toStringAsFixed(2)}\n'
                          'Y: ${viewModel.userAccelerometerEvent!.y.toStringAsFixed(2)}\n'
                          'Z: ${viewModel.userAccelerometerEvent!.z.toStringAsFixed(2)}'
                    : 'No data',
              ),
              _buildSensorCard(
                'Accelerometer',
                viewModel.accelerometerEvent != null
                    ? 'X: ${viewModel.accelerometerEvent!.x.toStringAsFixed(2)}\n'
                          'Y: ${viewModel.accelerometerEvent!.y.toStringAsFixed(2)}\n'
                          'Z: ${viewModel.accelerometerEvent!.z.toStringAsFixed(2)}'
                    : 'No data',
              ),
              _buildSensorCard(
                'Gyroscope',
                viewModel.gyroscopeEvent != null
                    ? 'X: ${viewModel.gyroscopeEvent!.x.toStringAsFixed(2)}\n'
                          'Y: ${viewModel.gyroscopeEvent!.y.toStringAsFixed(2)}\n'
                          'Z: ${viewModel.gyroscopeEvent!.z.toStringAsFixed(2)}'
                    : 'No data',
              ),
              _buildSensorCard(
                'Magnetometer',
                viewModel.magnetometerEvent != null
                    ? 'X: ${viewModel.magnetometerEvent!.x.toStringAsFixed(2)}\n'
                          'Y: ${viewModel.magnetometerEvent!.y.toStringAsFixed(2)}\n'
                          'Z: ${viewModel.magnetometerEvent!.z.toStringAsFixed(2)}'
                    : 'No data',
              ),
              _buildSensorCard(
                'Barometer',
                viewModel.barometerEvent != null
                    ? 'Pressure: ${viewModel.barometerEvent!.pressure.toStringAsFixed(2)} hPa'
                    : 'No data',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSensorCard(String title, String data) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(data, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
