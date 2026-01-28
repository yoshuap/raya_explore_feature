import 'package:flutter/material.dart';
import 'package:raya_explore_feature/features/akselometer_and_giroskop/view.dart';
import 'package:raya_explore_feature/features/battery_and_charging_status/view.dart';
import 'package:raya_explore_feature/features/data_device/view.dart';
import 'package:raya_explore_feature/features/keystroke_dynamics/view.dart';
import 'package:raya_explore_feature/features/touch_dynamics/view.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raya Explore Feature'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                title: 'Akselometer and Giroskop',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AkselometerAndGiroskop(),
                    ),
                  );
                },
              ),
              AppButton(
                title: 'Battery and Charging Status',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BatteryAndChargingStatus(),
                    ),
                  );
                },
              ),
              AppButton(
                title: 'Data Device',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DataDevice()),
                  );
                },
              ),
              AppButton(
                title: 'Keystroke Dynamics',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KeystrokeDynamics(),
                    ),
                  );
                },
              ),
              AppButton(
                title: 'Touch Dynamics',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TouchDynamics(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
