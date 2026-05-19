import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikwiki/app.dart';
import 'package:tikwiki/core/di/injection.dart';
import 'package:tikwiki/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();
  configureDependencies();

  runApp(const ProviderScope(child: App()));
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      debugPrint('Firebase initialization skipped: ${e.message}');
    }
  } on Exception catch (e) {
    debugPrint('Firebase initialization skipped: $e');
  }
}
