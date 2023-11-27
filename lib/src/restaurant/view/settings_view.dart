import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../common/helper/custom_dialog.dart';
import '../controller/scheduling_provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<SchedulingProvider>(
        create: (_) => SchedulingProvider(),
        child: ListView(
          shrinkWrap: true,
          children: [
            Material(
              child: ListTile(
                title: const Text('Scheduling Restaurant'),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, widget) {
                    return Switch.adaptive(
                      value: scheduled.isScheduled(),
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          customDialog(context);
                        } else {
                          scheduled.scheduledRestaurant(value);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
