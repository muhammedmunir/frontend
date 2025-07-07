import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart'; // Pastikan ini betul
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/firebase_options.dart'; // Guna kalau ada

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform, // Guna fail firebase_options.dart
    );
  });

  testWidgets('Ujian ringkas', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('0'), findsOneWidget); // Semak teks '0'
    await tester.tap(find.byIcon(Icons.add)); // Klik butang tambah
    await tester.pump();

    expect(find.text('1'), findsOneWidget); // Pastikan jadi '1'
  });
}
