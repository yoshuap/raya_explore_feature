# Keystroke Dynamics

## Use Case
This feature is designed for applications that need to analyze typing behavior patterns. Keystroke dynamics is a behavioral biometric that can be used for:
- **User authentication**: Verify identity based on typing patterns
- **Typing analysis**: Understand typing speed and consistency
- **Behavioral research**: Study human-computer interaction patterns
- **Security applications**: Detect anomalous typing behavior

## Purpose
The primary purpose of this feature is to:
- **Capture Keystroke Timing**: Record precise timing data for each keystroke including dwell time (how long a key is pressed) and flight time (time between key presses)
- **Analyze Typing Patterns**: Calculate metrics such as average dwell time, average flight time, typing speed, and consistency measures
- **Provide Real-time Feedback**: Display typing analysis in real-time as the user types
- **Enable Behavioral Biometrics**: Provide data that can be used for user identification or verification

## Implementation Details
- **Architecture**: Stacked MVVM Architecture
- **Dependencies**: None (uses built-in Flutter capabilities)
- **Components**:
    - `KeystrokeModel`: Data models for keystroke events and analysis results
    - `KeystrokeRepository`: Handles keystroke data collection and analysis calculations
    - `KeystrokeViewModel`: Manages state and coordinates between view and repository
    - `KeystrokeDynamics` (View): Interactive UI for capturing and displaying keystroke data

## Key Metrics Explained

### Dwell Time
The duration a key is held down, measured from key press to key release. Typical values range from 50-150ms.

### Flight Time
The time between releasing one key and pressing the next key. This measures typing rhythm and speed.

### Typing Speed
Calculated as characters per minute (CPM) based on the total time elapsed and number of keystrokes.

### Standard Deviation
Measures consistency in typing patterns. Lower values indicate more consistent typing rhythm.

## Usage
1. Navigate to the Keystroke Dynamics screen
2. Press "Start Recording" to begin capturing keystroke data
3. Type in the text field - your keystroke patterns will be analyzed in real-time
4. Press "Stop Recording" when finished
5. View detailed analysis metrics below the input field
6. Use the clear button (trash icon) to reset all data and start over

## Technical Notes
- Since Flutter's TextField doesn't provide direct access to key press/release events, the implementation simulates keystroke timing based on text input changes
- Dwell times are estimated with realistic values (80-120ms range)
- All timing calculations are performed in milliseconds for precision
- The analysis updates in real-time as you type
