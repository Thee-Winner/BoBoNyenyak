import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_bobonyenyak/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    TestFirebaseCoreHostApi.setUp(_MockFirebaseCore());
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'test-api-key',
        appId: 'test-app-id',
        messagingSenderId: 'test-sender-id',
        projectId: 'test-project',
      ),
    );
  });

  testWidgets('App opens on the branded startup screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Memeriksa sesi...'), findsOneWidget);
    expect(
      find.text('You have pushed the button this many times:'),
      findsNothing,
    );

    await tester.pumpWidget(const SizedBox.shrink());
  });
}

class _MockFirebaseCore implements TestFirebaseCoreHostApi {
  CoreFirebaseOptions get _options => CoreFirebaseOptions(
    apiKey: 'test-api-key',
    appId: 'test-app-id',
    messagingSenderId: 'test-sender-id',
    projectId: 'test-project',
  );

  @override
  Future<CoreInitializeResponse> initializeApp(
    String appName,
    CoreFirebaseOptions initializeAppRequest,
  ) async {
    return CoreInitializeResponse(
      name: appName,
      options: initializeAppRequest,
      pluginConstants: {},
    );
  }

  @override
  Future<List<CoreInitializeResponse>> initializeCore() async => [
    CoreInitializeResponse(
      name: defaultFirebaseAppName,
      options: _options,
      pluginConstants: {},
    ),
  ];

  @override
  Future<CoreFirebaseOptions> optionsFromResource() async => _options;
}
