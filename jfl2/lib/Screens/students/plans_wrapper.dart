import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/plans_meals.dart';
import 'package:jfl2/Screens/students/plans_past_workouts.dart';
import 'package:jfl2/Screens/students/plans_upcoming.dart';
import 'package:jfl2/components/footer_button.dart';

class PlansWrapper extends StatefulWidget{
  static String id = "PlansLaunch";
  _PlansWrapper createState() => _PlansWrapper();
}

class _PlansWrapper extends State<PlansWrapper> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  var currentscreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[],
          title: Text('Plans Information'),
        ),
      bottomNavigationBar: BottomAppBar(
            child: Row(
          children: [
            FooterButton(
              color: currentscreen == 0 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
              text: Text("Upcoming",style: TextStyle(color: Colors.white,fontSize: 11.0)),
              action: () {
                setState(() {
                  currentscreen = 0;
                  _navigatorKey.currentState?.pushNamed(PlansUpcoming.id);
                });
              },
            ),
            FooterButton(
                color:currentscreen == 1 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                text: Text("Past Workouts",style: TextStyle(color: Colors.white,fontSize: 11.0)),
                action: () {
                  setState(() {
                    currentscreen = 1;
                    _navigatorKey.currentState?.pushNamed(PlansPastWorkouts.id);
                  });
                }),
            FooterButton(
                color: currentscreen == 2 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                text: Text("Meals",style: TextStyle(color: Colors.white,fontSize: 11.0)),
                action: () {
                  currentscreen = 2;
                }),
            FooterButton(
                color: currentscreen == 3 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                text: Text("Training",style: TextStyle(color: Colors.white,fontSize: 11.0)) ,
                action: () {
                  setState(() {
                    currentscreen = 3;
                  });
                }),
          ],
        )),
      body: Navigator(
        key:_navigatorKey,
        initialRoute: PlansUpcoming.id ,
        onGenerateRoute: (settings){
          WidgetBuilder? builder;
          if(settings.name == PlansUpcoming.id) builder = (context) => PlansUpcoming();
          else if(settings.name == PlansPastWorkouts.id) builder = (context) =>  PlansPastWorkouts();
          return MaterialPageRoute(builder: builder as Widget Function(BuildContext),settings: settings);
        },
      ),
    );
  }
}