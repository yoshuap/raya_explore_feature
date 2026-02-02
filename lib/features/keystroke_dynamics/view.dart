import 'package:flutter/material.dart';
import 'package:raya_explore_feature/features/keystroke_dynamics/logic/keystroke_model.dart';
import 'package:raya_explore_feature/features/keystroke_dynamics/logic/keystroke_repository.dart';
import 'package:raya_explore_feature/features/keystroke_dynamics/logic/keystroke_viewmodel.dart';
import 'package:stacked/stacked.dart';

class KeystrokeDynamics extends StatelessWidget {
  const KeystrokeDynamics({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<KeystrokeViewModel>.reactive(
      viewModelBuilder: () => KeystrokeViewModel(KeystrokeRepository()),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Keystroke Dynamics'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: viewModel.clearData,
                tooltip: 'Clear Data',
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 16),
                  _buildInputCard(viewModel),
                  const SizedBox(height: 16),
                  _buildControlButtons(viewModel),
                  const SizedBox(height: 24),
                  _buildAnalysisSection(context, viewModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Type in the field below to analyze your keystroke patterns',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(KeystrokeViewModel viewModel) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.keyboard,
                  color: viewModel.isRecording ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  viewModel.isRecording ? 'Recording...' : 'Not Recording',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: viewModel.isRecording ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.textController,
              maxLines: 5,
              enabled: viewModel.isRecording,
              decoration: InputDecoration(
                hintText: viewModel.isRecording
                    ? 'Start typing to capture keystroke dynamics...'
                    : 'Press "Start Recording" to begin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: viewModel.isRecording
                    ? Colors.white
                    : Colors.grey[100],
              ),
              onChanged: (newText) {
                viewModel.onTextChanged(newText);
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Keystrokes: ${viewModel.keystrokeCount}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons(KeystrokeViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: viewModel.isRecording ? null : viewModel.startRecording,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Recording'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: viewModel.isRecording ? viewModel.stopRecording : null,
            icon: const Icon(Icons.stop),
            label: const Text('Stop Recording'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisSection(
    BuildContext context,
    KeystrokeViewModel viewModel,
  ) {
    if (viewModel.keystrokeCount == 0) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.analytics_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No data yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start typing to see your keystroke analysis',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final analysis = viewModel.analysis;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Keystroke Analysis',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildMetricCard(
          context,
          'Average Dwell Time',
          '${analysis.averageDwellTime.toStringAsFixed(1)} ms',
          'Time each key is held down',
          Icons.timer,
          Colors.blue,
          explanation: 'The average amount of time a key is held down.',
          example:
              'Key "A" pressed for 90 ms\nKey "B" pressed for 110 ms\n➡️ Average dwell time = 100 ms',
          whyItMatters:
              '• Humans → varied dwell times\n• Bots/scripts → very consistent dwell times\n• Nervous or careful users → longer dwell times',
          interpretation: analysis.dwellInterpretation,
        ),
        const SizedBox(height: 12),
        _buildMetricCard(
          context,
          'Average Flight Time',
          '${analysis.averageFlightTime.toStringAsFixed(1)} ms',
          'Time between key presses',
          Icons.flight,
          Colors.purple,
          explanation:
              'The average time gap between releasing one key and pressing the next key.',
          example: 'Release "A"\nPress "B" after 70 ms\n➡️ Flight time = 70 ms',
          whyItMatters:
              '• Humans pause inconsistently\n• Bots type with near-perfect timing\n• Reflects natural typing rhythm',
          interpretation: analysis.flightInterpretation,
        ),
        const SizedBox(height: 12),
        _buildMetricCard(
          context,
          'Typing Speed',
          '${analysis.typingSpeed.toStringAsFixed(1)} CPM',
          'Characters per minute',
          Icons.speed,
          Colors.green,
          explanation:
              'How many characters are typed per minute.\nFormula: CPM = (total characters / typing duration) × 60',
          example: '10 characters in 5 seconds\n➡️ (10 / 5) × 60 = 120 CPM',
          whyItMatters:
              '• Extremely high CPM → bot/autofill/paste\n• Very low CPM → hesitation or difficulty\n• Normal humans fall in a realistic range (40-80 CPM typical)',
          interpretation: analysis.speedInterpretation,
        ),
        const SizedBox(height: 12),
        _buildMetricCard(
          context,
          'Total Keystrokes',
          '${analysis.totalKeystrokes}',
          'Number of keys pressed',
          Icons.keyboard_alt,
          Colors.orange,
          explanation:
              'The total number of key presses, including letters, numbers, backspace, and delete.',
          example:
              'Typing "hello" with 2 corrections\n➡️ 5 letters + 2 backspaces = 7 keystrokes',
          whyItMatters:
              '• Humans make mistakes → more backspaces\n• Bots → minimal or zero corrections\n• Higher count indicates natural typing with edits',
        ),
        const SizedBox(height: 12),
        _buildMetricCard(
          context,
          'Dwell Time Std Dev',
          '${analysis.dwellTimeStdDev.toStringAsFixed(1)} ms',
          'Consistency of key hold duration',
          Icons.show_chart,
          Colors.teal,
          explanation:
              'How consistent or variable the dwell times are (standard deviation).',
          example:
              'All keys ~100 ms → ❌ suspicious\nKeys range 80–140 ms → ✅ normal',
          whyItMatters:
              '• Low std dev → too consistent → suspicious\n• Higher std dev → natural human behavior\n• Humans vary their key press duration',
        ),
        const SizedBox(height: 12),
        _buildMetricCard(
          context,
          'Flight Time Std Dev',
          '${analysis.flightTimeStdDev.toStringAsFixed(1)} ms',
          'Consistency of typing rhythm',
          Icons.trending_up,
          Colors.indigo,
          explanation:
              'How much the time gaps between keys vary (standard deviation).',
          example:
              'All gaps ~50 ms → ❌ bot-like\nGaps vary 30–120 ms → ✅ human',
          whyItMatters:
              '• Bots → near-zero variation\n• Humans → irregular pauses and rhythm\n• Natural typing has variable timing',
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    String description,
    IconData icon,
    Color color, {
    String? explanation,
    String? example,
    String? whyItMatters,
    KeystrokeInterpretation? interpretation,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: explanation != null
            ? () => _showMetricExplanation(
                context,
                title,
                explanation,
                example,
                whyItMatters,
                color,
                interpretation,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (interpretation != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getInterpretationColor(
                                interpretation.color,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _getInterpretationColor(
                                  interpretation.color,
                                ).withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              interpretation.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getInterpretationColor(
                                  interpretation.color,
                                ),
                              ),
                            ),
                          ),
                        if (explanation != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.info_outline,
                              size: 16,
                              color: color.withValues(alpha: 0.5),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getInterpretationColor(String colorName) {
    switch (colorName) {
      case KeystrokeInterpretation.colorGreen:
        return Colors.green;
      case KeystrokeInterpretation.colorOrange:
        return Colors.orange;
      case KeystrokeInterpretation.colorRed:
        return Colors.red;
      case KeystrokeInterpretation.colorBlue:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showMetricExplanation(
    BuildContext context,
    String title,
    String explanation,
    String? example,
    String? whyItMatters,
    Color color,
    KeystrokeInterpretation? interpretation,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: TextStyle(color: color)),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (interpretation != null) ...[
                const Text(
                  'Current Interpretation:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getInterpretationColor(
                      interpretation.color,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getInterpretationColor(
                        interpretation.color,
                      ).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        interpretation.label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getInterpretationColor(interpretation.color),
                        ),
                      ),
                      if (interpretation.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          interpretation.description!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              const Text(
                'What it means:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(explanation, style: const TextStyle(fontSize: 14)),
              if (example != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Example:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    example,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
              if (whyItMatters != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Why it matters:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(whyItMatters, style: const TextStyle(fontSize: 14)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
