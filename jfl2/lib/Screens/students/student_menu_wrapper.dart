import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/plans_shop.dart';
import 'package:jfl2/Screens/students/your_calendar.dart';
import 'package:jfl2/components/custom_page_route.dart';
import 'package:jfl2/components/student_drawer.dart';

class StudentMenuWrapper extends StatefulWidget {
  static String id = "StudentMenuWrapper";
  @override
  _StudentMenuWrapperState createState() => _StudentMenuWrapperState();
}

class _StudentMenuWrapperState extends State<StudentMenuWrapper> {
  ValueNotifier<String> settingsName = ValueNotifier<String>("");
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: StudentDrawer(
            navigatorKey: _navigatorKey,
            scaffoldKey: _scaffoldKey,
          ),
          appBar: AppBar(
            title: ValueListenableBuilder<String>(
              valueListenable: settingsName,
              builder: (context, String value, _) {
                if (value == PlansShop.id) {
                  return Text("Shop");
                } else {
                  return Text("Shop");
                }
              },
            ),
          ),
          body: Stack(
            children: [
              Navigator(
                key: _navigatorKey,
                initialRoute: PlansShop.id,
                onGenerateRoute: (settings) {
                  WidgetBuilder builder;
                  if (settings.name == PlansShop.id)
                    builder = (context) => PlansShop();
                  else if (settings.name == YourCalendar.id)
                    builder = (context) => YourCalendar();
                  else
                    builder = (context) => PlansShop();
                  settingsName.value = settings.name as String;
                  return CustomPageRoute(builder: builder, settings: settings);
                },
              )
            ],
          ),
        ));
  }
}
