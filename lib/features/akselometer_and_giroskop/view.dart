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
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSensorCard(
                  context,
                  title: 'User Accelerometer',
                  data: viewModel.userAccelerometerEvent != null
                      ? 'X: ${viewModel.userAccelerometerEvent!.x.toStringAsFixed(2)}\n'
                            'Y: ${viewModel.userAccelerometerEvent!.y.toStringAsFixed(2)}\n'
                            'Z: ${viewModel.userAccelerometerEvent!.z.toStringAsFixed(2)}'
                      : 'No data',
                  isAvailable: viewModel.isUserAccelerometerAvailable,
                  textGuide:
                      'Hold the device still and move it around to see the values change.',
                ),
                _buildSensorCard(
                  context,
                  title: 'Accelerometer',
                  data: viewModel.accelerometerEvent != null
                      ? 'X: ${viewModel.accelerometerEvent!.x.toStringAsFixed(2)}\n'
                            'Y: ${viewModel.accelerometerEvent!.y.toStringAsFixed(2)}\n'
                            'Z: ${viewModel.accelerometerEvent!.z.toStringAsFixed(2)}'
                      : 'No data',
                  isAvailable: viewModel.isAccelerometerAvailable,
                  textGuide:
                      'Hold the device still and move it around to see the values change.',
                ),
                _buildSensorCard(
                  context,
                  title: 'Gyroscope',
                  data: viewModel.gyroscopeEvent != null
                      ? 'X: ${viewModel.gyroscopeEvent!.x.toStringAsFixed(2)}\n'
                            'Y: ${viewModel.gyroscopeEvent!.y.toStringAsFixed(2)}\n'
                            'Z: ${viewModel.gyroscopeEvent!.z.toStringAsFixed(2)}'
                      : 'No data',
                  isAvailable: viewModel.isGyroscopeAvailable,
                  textGuide:
                      'Hold the device still and move it around to see the values change.',
                ),
                _buildSensorCard(
                  context,
                  title: 'Magnetometer',
                  data: viewModel.magnetometerEvent != null
                      ? 'X: ${viewModel.magnetometerEvent!.x.toStringAsFixed(2)}\n'
                            'Y: ${viewModel.magnetometerEvent!.y.toStringAsFixed(2)}\n'
                            'Z: ${viewModel.magnetometerEvent!.z.toStringAsFixed(2)}'
                      : 'No data',
                  isAvailable: viewModel.isMagnetometerAvailable,
                  textGuide:
                      'Hold the device still and move it around to see the values change.',
                ),
                _buildSensorCard(
                  context,
                  title: 'Barometer',
                  data: viewModel.barometerEvent != null
                      ? 'Pressure: ${viewModel.barometerEvent!.pressure.toStringAsFixed(2)} hPa'
                      : 'No data',
                  isAvailable: viewModel.isBarometerAvailable,
                  textGuide:
                      'Hold the device still and move it around to see the values change.',
                ),
                _buildSensorCard(
                  context,
                  title: 'Ambient Temperature',
                  data: viewModel.temperatureEvent != null
                      ? '${viewModel.temperatureEvent!.toStringAsFixed(2)} °C'
                      : 'No data',
                  isAvailable: viewModel.isTemperatureAvailable,
                  textGuide:
                      'Hold the device still and move it around to see the values change.',
                ),
                _buildSensorCard(
                  context,
                  title: 'Proximity',
                  data: viewModel.proximityEvent != null
                      ? viewModel.proximityEvent == 0
                            ? "Far"
                            : "Near"
                      : 'No data',
                  isAvailable: viewModel.isProximityAvailable,
                  textGuide:
                      'Hold the device still and move it around to see the values change.',
                ),
                _buildSensorCard(
                  context,
                  title: 'Light',
                  data: viewModel.lightEvent != null
                      ? '${viewModel.lightEvent!.toStringAsFixed(2)} Lux'
                      : 'No data',
                  isAvailable: viewModel.isLightAvailable,
                  textGuide:
                      'Hold the device still and move it around to see the values change.',
                ),
                _buildSensorCard(
                  context,
                  title: 'Relative Humidity',
                  data: viewModel.humidityEvent != null
                      ? '${viewModel.humidityEvent!.toStringAsFixed(2)} %'
                      : 'No data',
                  isAvailable: viewModel.isHumidityAvailable,
                  textGuide:
                      'Hold the device still and move it around to see the values change.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSensorCard(
    BuildContext context, {
    required String title,
    required String data,
    bool isAvailable = true,
    required String textGuide,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      color: isAvailable ? null : Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    if (!isAvailable)
                      const Icon(Icons.error, color: Colors.red),
                    Tooltip(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      message: textGuide,
                      triggerMode: TooltipTriggerMode.tap,
                      child: const Icon(Icons.info),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isAvailable ? data : 'Sensor not supported',
              style: TextStyle(
                fontSize: 14,
                color: isAvailable ? Colors.black : Colors.red,
                fontStyle: isAvailable ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
