import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:raya_explore_feature/features/data_device/logic/device_info_repository.dart';
import 'package:raya_explore_feature/features/data_device/logic/device_info_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DataDevice extends StatelessWidget {
  const DataDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ViewModelBuilder<DeviceInfoViewModel>.reactive(
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
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Feature', icon: Icon(Icons.info_outline)),
                  Tab(text: 'Docs', icon: Icon(Icons.description)),
                ],
              ),
            ),
            body: SafeArea(
              child: TabBarView(
                children: [_buildBody(viewModel), _buildDocsTab()],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDocsTab() {
    return FutureBuilder<String>(
      future: rootBundle.loadString('lib/features/data_device/docs.md'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading docs: ${snapshot.error}'));
        }
        return Markdown(data: snapshot.data ?? 'No documentation available.');
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
