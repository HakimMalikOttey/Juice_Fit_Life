import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/plans_shop.dart';
import 'package:jfl2/Screens/students/your_calendar.dart';

class StudentDrawer extends StatelessWidget {
  final navigatorKey;
  final GlobalKey<ScaffoldState> scaffoldKey;
  StudentDrawer({required this.navigatorKey, required this.scaffoldKey});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Theme(
      data: Theme.of(context)
          .copyWith(dividerTheme: DividerThemeData(thickness: 0.0)),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/weights.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.matrix(<double>[
                        0.2126,
                        0.250,
                        0.070,
                        0,
                        -55,
                        0.2126,
                        0.250,
                        0.070,
                        0,
                        -55,
                        0.2126,
                        0.250,
                        0.070,
                        0,
                        -55,
                        0,
                        0,
                        0,
                        1,
                        0,
                      ]))),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, GeneralSignUp.id,
                  //     arguments: {"type": true});
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   width: 100.0,
                    //   height: 100.0,
                    //   decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //         image: NetworkImage(
                    //             Provider.of<TrainerSignUpData>(context,
                    //                     listen: false)
                    //                 .trainerData
                    //                 .data["profpic"]),
                    //         fit: BoxFit.cover,
                    //       ),
                    //       border: Border.all(color: Colors.white)),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["username"]}",
                          //   style: Theme.of(context).textTheme.headline3,
                          // ),
                          // Text(
                          //   "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["fname"]} ${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["lname"]}",
                          //   style: Theme.of(context).textTheme.headline6,
                          // ),
                          // Text(
                          //   "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["email"]}",
                          //   style: Theme.of(context).textTheme.headline1,
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text("Dashboard"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Juice Fit Life Shop"),
              onTap: () {
                scaffoldKey.currentState?.openEndDrawer();
                navigatorKey.currentState.pushNamed(PlansShop.id);
              },
            ),
            ListTile(
              title: Text("Your Calendar"),
              onTap: () {
                scaffoldKey.currentState?.openEndDrawer();
                navigatorKey.currentState.pushNamed(YourCalendar.id);
              },
            ),
            ListTile(
              title: Text("Settings"),
              onTap: () {},
            ),
          ],
        ),
      ),
    ));
  }
}
