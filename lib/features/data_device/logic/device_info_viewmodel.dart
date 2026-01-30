import 'package:raya_explore_feature/features/data_device/logic/device_info_repository.dart';
import 'package:stacked/stacked.dart';

class DeviceInfoViewModel extends BaseViewModel {
  final DeviceInfoRepository _repository;

  DeviceInfoViewModel(this._repository) {
    _init();
  }

  Map<String, dynamic> _deviceInfo = {};
  Map<String, dynamic> get deviceInfo => _deviceInfo;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> _init() async {
    setBusy(true);
    try {
      _deviceInfo = await _repository.getDeviceInfo();
      if (_deviceInfo.containsKey('error')) {
        _errorMessage = _deviceInfo['error'];
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch device info: $e';
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _init();
  }
}
