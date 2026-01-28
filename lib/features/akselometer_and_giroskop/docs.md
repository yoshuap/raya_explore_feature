1. Add Package sensors_plus to pubspec.yaml
2. On iOS, navigate to [ios/Runner/Info.plist] and add `NSMotionUsageDescription`
example:
<key>NSMotionUsageDescription</key>
<string>This app needs access to motion sensors to track device movement.</string>
3. 