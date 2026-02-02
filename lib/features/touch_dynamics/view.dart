import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:raya_explore_feature/features/touch_dynamics/logic/touch_model.dart';
import 'package:raya_explore_feature/features/touch_dynamics/logic/touch_repository.dart';
import 'package:raya_explore_feature/features/touch_dynamics/logic/touch_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TouchDynamics extends StatelessWidget {
  const TouchDynamics({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TouchViewModel>.reactive(
      viewModelBuilder: () => TouchViewModel(TouchRepository()),
      builder: (context, viewModel, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Touch Dynamics'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.touch_app), text: 'Explorer'),
                Tab(icon: Icon(Icons.description), text: 'Docs'),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                _TouchExplorer(viewModel: viewModel),
                const _TouchDocs(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TouchExplorer extends StatelessWidget {
  final TouchViewModel viewModel;

  const _TouchExplorer({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AnalysisDashboard(viewModel: viewModel),
        const Divider(height: 1),
        Expanded(child: _TouchInteractionArea(viewModel: viewModel)),
        if (viewModel.interpretations.isNotEmpty)
          _InterpretationList(viewModel: viewModel),
        _ControlPanel(viewModel: viewModel),
      ],
    );
  }
}

class _InterpretationList extends StatelessWidget {
  final TouchViewModel viewModel;

  const _InterpretationList({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: (Colors.grey[50] ?? Colors.grey).withValues(alpha: 0.5),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.interpretations.length,
        itemBuilder: (context, index) {
          final interpretation = viewModel.interpretations[index];
          return _InterpretationTile(interpretation: interpretation);
        },
      ),
    );
  }
}

class _InterpretationTile extends StatelessWidget {
  final TouchInterpretation interpretation;

  const _InterpretationTile({required this.interpretation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: interpretation.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: interpretation.color.withValues(alpha: 0.2)),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(interpretation.icon, color: interpretation.color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interpretation.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: interpretation.color,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      interpretation.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24), // Space for the expand button
            ],
          ),
          Positioned(
            right: -8,
            top: -8,
            child: IconButton(
              icon: Icon(
                Icons.open_in_new,
                size: 18,
                color: interpretation.color.withValues(alpha: 0.6),
              ),
              onPressed: () => _showDetailDialog(context),
              tooltip: 'Show Details',
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(interpretation.icon, color: interpretation.color),
            const SizedBox(width: 12),
            Text(
              interpretation.title,
              style: TextStyle(color: interpretation.color),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              interpretation.description,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, size: 20, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This insight is based on your recent touch patterns analyzed by our behavioral biometric engine.',
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _AnalysisDashboard extends StatelessWidget {
  final TouchViewModel viewModel;

  const _AnalysisDashboard({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final analysis = viewModel.analysis;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MetricCard(
                label: 'Avg Pressure',
                value: analysis.avgPressure.toStringAsFixed(3),
                icon: Icons.compress,
              ),
              _MetricCard(
                label: 'Avg Size',
                value: analysis.avgSize.toStringAsFixed(2),
                icon: Icons.photo_size_select_small,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MetricCard(
                label: 'Velocity',
                value: '${analysis.avgVelocity.toStringAsFixed(1)} px/s',
                icon: Icons.speed,
              ),
              _MetricCard(
                label: 'Sessions',
                value: analysis.totalSessions.toString(),
                icon: Icons.history,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TouchInteractionArea extends StatelessWidget {
  final TouchViewModel viewModel;

  const _TouchInteractionArea({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: viewModel.handlePointerDown,
      onPointerMove: viewModel.handlePointerMove,
      onPointerUp: viewModel.handlePointerUp,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: viewModel.isRecording
              ? Stack(
                  children: [
                    const Center(
                      child: Text(
                        'Touch, swipe, or tap here to capture data',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    if (viewModel.currentSessionPoints.isNotEmpty)
                      CustomPaint(
                        painter: _TouchPathPainter(
                          points: viewModel.currentSessionPoints,
                        ),
                        size: Size.infinite,
                      ),
                  ],
                )
              : const Text(
                  'Press "Start Recording" to begin',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
        ),
      ),
    );
  }
}

class _TouchPathPainter extends CustomPainter {
  final List<TouchPoint> points;

  _TouchPathPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(
        Offset(points[i].x, points[i].y),
        Offset(points[i + 1].x, points[i + 1].y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ControlPanel extends StatelessWidget {
  final TouchViewModel viewModel;

  const _ControlPanel({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: viewModel.isRecording
                  ? viewModel.stopRecording
                  : viewModel.startRecording,
              icon: Icon(viewModel.isRecording ? Icons.stop : Icons.play_arrow),
              label: Text(
                viewModel.isRecording ? 'Stop Recording' : 'Start Recording',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: viewModel.isRecording
                    ? Colors.red
                    : Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: viewModel.clearData,
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _TouchDocs extends StatelessWidget {
  const _TouchDocs();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(
        context,
      ).loadString('lib/features/touch_dynamics/docs.md'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading documentation: ${snapshot.error}'),
          );
        }
        return Markdown(
          data: snapshot.data ?? 'No documentation available.',
          selectable: true,
        );
      },
    );
  }
}
