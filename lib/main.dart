import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:attendance_tracking_app/screens/auth_page.dart';
import 'package:attendance_tracking_app/screens/home.dart';
import 'package:attendance_tracking_app/screens/login_screen.dart';
import 'package:attendance_tracking_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:attendance_tracking_app/routes/routes.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
    child:  MyApp(),
  ));
}

class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Widget staggeredLoading(BuildContext context) {
    return Scaffold(
        body: Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: 100,
      ),
    ));
  }

  @override
  void initState(){
    super.initState();
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final AuthService authService = new AuthService(authProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
    authService.isLoggedIn();
    // testFunc();
    
  });
    
  }
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      routerConfig: Routes().router,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
         );
  }
}
// home: Consumer<AuthProvider>(builder: (context, auth, child){
//           if(auth.isLoading){
//             return staggeredLoading(context);
//           }else if(auth.isLoggedin){
//             return HomeScreen();
//           }
//           else{
//             return LoginScreen();
//           }
//         },)

// class StaggeredLoading extends StatefulWidget {
//   const StaggeredLoading({super.key});

//   @override
//   State<StaggeredLoading> createState() => _StaggeredLoadingState();
// }

// class _StaggeredLoadingState extends State<StaggeredLoading> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: LoadingAnimationWidget.staggeredDotsWave(
//         color: Colors.black,
//         size: 100,
//       ),
//     ));
//   }
// }