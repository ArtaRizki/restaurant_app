import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/src/restaurant/view/restaurant_view.dart';

import 'common/helper/sharedpref.dart';

Prefs prefs = Prefs();
void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await prefs.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      home: const RestaurantView(),
    );
  }
}
