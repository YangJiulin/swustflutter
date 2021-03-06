import 'package:swustflutter/pages/find_page.dart';
import 'package:swustflutter/pages/personal_center.dart';
import 'package:flutter/material.dart';

import 'pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //AppConfig.instance.requestPermissions();

  //AppConfig.instance.initPlatformFileSystem();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baidu Disk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<BottomNavigationBarItem> bottomNavigationBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.explore), title: Text('发现')),
    BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我的')),
  ];

  final pages = [FindPage(), PersonalCenter()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomNavigationBarItems,
          currentIndex: _selectedIndex,
          fixedColor: Colors.blue,
          onTap: (int index) => setState(() => _selectedIndex = index),
        ));
  }
}
