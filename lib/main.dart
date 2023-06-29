import 'package:browser_app/controllers/browser_controller.dart';
import 'package:browser_app/views/screens/home_page.dart';
import 'package:browser_app/views/screens/web_five.dart';
import 'package:browser_app/views/screens/web_four.dart';
import 'package:browser_app/views/screens/web_one.dart';
import 'package:browser_app/views/screens/web_three.dart';
import 'package:browser_app/views/screens/web_two.dart';
import 'package:browser_app/views/utils/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(providers: [
     ChangeNotifierProvider(create: (context) => Engine_Controller(),)
    ],child: MyApp(),),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        '/':(context) => Home_Page(),
        Myroutes.Chrome:(context) => One(),
        Myroutes.Bing:(context) => Two(),
        Myroutes.Duck:(context) => Three(),
        Myroutes.Brave:(context) => Four(),
        Myroutes.Yahoo:(context) => Five(),
      },
    );
  }
}

