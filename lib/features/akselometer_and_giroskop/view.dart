import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:raya_explore_feature/features/akselometer_and_giroskop/logic/sensor_repository.dart';
import 'package:raya_explore_feature/features/akselometer_and_giroskop/logic/sensor_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AkselometerAndGiroskop extends StatelessWidget {
  const AkselometerAndGiroskop({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SensorViewModel>.reactive(
      viewModelBuilder: () => SensorViewModel(SensorRepository()),
      builder: (context, viewModel, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Akselometer and Giroskop'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Feature', icon: Icon(Icons.sensors)),
                  Tab(text: 'Docs', icon: Icon(Icons.description)),
                ],
              ),
            ),
            body: SafeArea(
              child: TabBarView(
                children: [
                  _buildFeatureTab(context, viewModel),
                  const _SensorDocs(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureTab(BuildContext context, SensorViewModel viewModel) {
    return ListView(
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

class _SensorDocs extends StatelessWidget {
  const _SensorDocs();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(
        context,
      ).loadString('lib/features/akselometer_and_giroskop/docs.md'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading documentation: ${snapshot.error}'),
          );
        }
        return Markdown(data: snapshot.data ?? 'No documentation found.');
      },
    );
  }
}
