import 'package:flutter/material.dart';
import 'package:raya_explore_feature/features/data_device/logic/device_info_repository.dart';
import 'package:raya_explore_feature/features/data_device/logic/device_info_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DataDevice extends StatelessWidget {
  const DataDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeviceInfoViewModel>.reactive(
      viewModelBuilder: () => DeviceInfoViewModel(DeviceInfoRepository()),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Data Device'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: viewModel.refresh,
              ),
            ],
          ),
          body: SafeArea(child: _buildBody(viewModel)),
        );
      },
    );
  }

  Widget _buildBody(DeviceInfoViewModel viewModel) {
    if (viewModel.isBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    final data = viewModel.deviceInfo;
    if (data.isEmpty) {
      return const Center(child: Text('No device information available.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final key = data.keys.elementAt(index);
        final value = data[key];
        return ListTile(
          title: Text(
            key,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          subtitle: Text(
            '$value',
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        );
      },
    );
  }
}
