import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thinknest/core/common/error_text.dart';
import 'package:thinknest/core/common/loader.dart';
import 'package:thinknest/features/auth/controlller/auth_controller.dart';
import 'package:thinknest/firebase_options.dart';
import 'package:thinknest/models/user_model.dart';
import 'package:thinknest/router.dart';
import 'package:thinknest/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}









// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await FirebaseAppCheck.instance.activate(
//     // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
//     androidProvider: AndroidProvider.debug,
//     // androidProvider: AndroidProvider.playIntegrity,
//     // appleProvider: AppleProvider.appAttest,
//   );
//   // await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
//   debugPrint('Firebase Initialized');
//   runApp(
//     const ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(
//     const ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Reddit Tutorial',
            theme: ref.watch(themeNotifierProvider),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (data != null) {
                  getData(ref, data);
                  if (userModel != null) {
                    return loggedInRoute;
                  }
                }
                return loggedOutRoute;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
