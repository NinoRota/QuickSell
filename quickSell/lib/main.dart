import 'package:flutter/material.dart';
import 'pages/PluginPage.dart';
import 'pages/SecondScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: _buildRoutes(),
      onGenerateRoute: _generateRoute,
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      "/": (context) => PluginPage(),
      // Add other routes as needed
    };
  }

  MaterialPageRoute _generateRoute(RouteSettings settings) {
    String? routeName = settings.name;
    print(routeName);
    return MaterialPageRoute(builder: (context) => PluginPage());
  }
}
