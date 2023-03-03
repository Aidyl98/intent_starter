import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:platform/platform.dart';

import 'package:intent_starter/custom_text_field.dart';
import 'package:intent_starter/validators_model.dart';

void main() {
  runApp(const MyApp());
}

/// A sample app for launching intents.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All In One',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

/// Holds the different intent widgets.
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  void _launchAsTech({required String package, required String JSON}) {
    final intent = AndroidIntent(
      action: 'OPEN_HISTORY_SCREEN',
      arguments: {'package': package, 'JSON': JSON},
    );
    intent.launch().catchError((e) {
      print(e.toString());
    });
  }

  void _seeAsTechAppInfo() {
    const intent = AndroidIntent(
      action: 'action_application_details_settings',
      data: 'package:com.astech.connect',
    );
    intent.launch().catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController controllerPackage = TextEditingController();
    TextEditingController controllerJSON = TextEditingController();

    ValidatorModel<String> required = ValidatorModel(
      (String? value) => value != '' && value != 'Selecciona',
      'Este campo es requerido.',
    );

    Widget body;
    if (const LocalPlatform().isAndroid) {
      body = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    key: GlobalKey(),
                    label: 'Package',
                    controller: controllerPackage,
                    validators: [required],
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextField(
                    key: GlobalKey(),
                    label: 'JSON',
                    multiline: true,
                    controller: controllerJSON,
                    validators: [required],
                  ),
                  const SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () => {
                      if (formKey.currentState!.validate())
                        {
                          _launchAsTech(
                            package: controllerPackage.text,
                            JSON: controllerJSON.text,
                          ),
                        }
                    },
                    child: const Text("Send Data"),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _seeAsTechAppInfo(),
              child: const Text('See AsTech App Info.'),
            ),
          ],
        ),
      );
    } else {
      body = const Text('This plugin only works with Android');
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('All In One'),
      ),
      body: Center(child: body),
    );
  }
}
