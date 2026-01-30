import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoRepository {
  final DeviceInfoPlugin _deviceInfoPlugin;

  DeviceInfoRepository({DeviceInfoPlugin? deviceInfoPlugin})
    : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin();

  /// Gets the full device information for the current platform.
  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return _parseAndroidInfo(androidInfo);
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      return _parseIosInfo(iosInfo);
    } else {
      return {'error': 'Platform not supported'};
    }
  }

  Map<String, dynamic> _parseAndroidInfo(AndroidDeviceInfo androidInfo) {
    return {
      'Model': androidInfo.model,
      'Device': androidInfo.device,
      'Hardware': androidInfo.hardware,
      'Manufacturer': androidInfo.manufacturer,
      'Brand': androidInfo.brand,
      'Product': androidInfo.product,
      'OS Version': androidInfo.version.release,
      'SDK Int': androidInfo.version.sdkInt,
      'Security Patch': androidInfo.version.securityPatch,
      'Is Physical Device': androidInfo.isPhysicalDevice,
      'Fingerprint': androidInfo.fingerprint,
      'Tags': androidInfo.tags,
      'Display': androidInfo.display,
      'Bootloader': androidInfo.bootloader,
      'Board': androidInfo.board,
      'Type': androidInfo.type,
      'Supported ABIs': androidInfo.supportedAbis.join(', '),
      'Supported 32-bit ABIs': androidInfo.supported32BitAbis.join(', '),
      'Supported 64-bit ABIs': androidInfo.supported64BitAbis.join(', '),
    };
  }

  Map<String, dynamic> _parseIosInfo(IosDeviceInfo iosInfo) {
    return {
      'Name': iosInfo.name,
      'System Name': iosInfo.systemName,
      'System Version': iosInfo.systemVersion,
      'Model': iosInfo.model,
      'Localized Model': iosInfo.localizedModel,
      'Identifier for Vendor': iosInfo.identifierForVendor,
      'Is Physical Device': iosInfo.isPhysicalDevice,
      'UTS Name Machine': iosInfo.utsname.machine,
      'UTS Name Nodename': iosInfo.utsname.nodename,
      'UTS Name Release': iosInfo.utsname.release,
      'UTS Name Sysname': iosInfo.utsname.sysname,
      'UTS Name Version': iosInfo.utsname.version,
    };
  }
}
