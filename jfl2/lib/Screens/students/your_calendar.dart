import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jfl2/Screens/students/plans_meals.dart';
import 'package:jfl2/Screens/students/workout_start.dart';
import 'package:jfl2/components/query_button.dart';
import 'package:jfl2/data/event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class YourCalendar extends StatefulWidget {
  static String id = "YourCalendar";
  @override
  _YourCalendarState createState() => _YourCalendarState();
}

class _YourCalendarState extends State<YourCalendar> {
  late Map<DateTime, List<Event>> selectedEvents;
  // final ValueNotifier<List<Event>> _selectedEvents;
  late DateTime _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool outside = false;
  @override
  void initState() {
    DateTime now = new DateTime.now();
    _selectedDay = now;
    selectedEvents = {
      DateTime(now.year, now.month, now.day): [Event(title: "test event")],
    };
    // selectedEvents[DateTime.now()].add(Event(title: "test event"));
    // TODO: implement initState
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    print("!!!!!!!!!!!!!!!!!");
    print(selectedEvents);
    print("!!!!!!!!!!!!!!!!!");
    print("----------");
    print(DateTime(date.year, date.month, date.day));
    print("------------");
    return selectedEvents[DateTime(date.year, date.month, date.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          body: TableCalendar(
            shouldFillViewport: true,
            eventLoader: _getEventsfromDay,
            calendarBuilders: CalendarBuilders(
                todayBuilder: (context, DateTime day, DateTime outsideBuilder) {
              final text = DateFormat.d().format(day);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 50.0,
                    height: MediaQuery.of(context).size.height / 5,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.apply(color: Colors.red),
                    ),
                  ),
                ),
              );
            }, outsideBuilder:
                    (context, DateTime day, DateTime outsideBuilder) {
                  //This determines the material design of dates the go beyond the current month that the user is sitting on
              final text = DateFormat.d().format(day);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 50.0,
                    height: MediaQuery.of(context).size.height / 5,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.apply(color: Colors.grey),
                    ),
                  ),
                ),
              );
            }, selectedBuilder:
                    (context, DateTime day, DateTime outsideBuilder) {
                  //This determines the material design of the day that matches the current date
              final text = DateFormat.d().format(day);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 50.0,
                    height: MediaQuery.of(context).size.height / 5,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ),
              );
            }, defaultBuilder:
                    (context, DateTime day, DateTime outsideBuilder) {
                  //This determines the material design of the days that do not match the current date
              final text = DateFormat.d().format(day);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 50.0,
                    height: MediaQuery.of(context).size.height / 5,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ),
              );
            }, dowBuilder: (context, day) {
              final text = DateFormat.E().format(day);
              return Center(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.headline1,
                ),
              );
            }),
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              // setState(() {
              //   _selectedDay = selectedDay;
              //   _focusedDay = focusedDay;
              // });
              showDialog(
                  context: context,
                  builder: (context) => Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Material(
                          child: Container(
                            width: 200.0,
                            height: 200.0,
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 80.0,
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${DateFormat('EEEE').format(selectedDay)} - ${DateFormat.MMMM().format(selectedDay)} ${selectedDay.day}, ${selectedDay.year}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(fontSize: 28.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ScrollSnapList(
                                    scrollDirection: Axis.horizontal,
                                    itemSize: 320.0,
                                    onItemFocus: (index) {},
                                    itemCount: 2,
                                    itemBuilder: (context, index) {
                                      return index == 0
                                          ? Container(
                                              height: 20.0,
                                              width: 320.0,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10.0),
                                                    child: Text(
                                                      "Plan Name",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                    color: Colors.white,
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          "assets/no_pic.png",
                                                      image:
                                                          "https://firebasestorage.googleapis.com/v0/b/juicefitlife.appspot.com/o/folderName%2Fimage_cropper_1627588001935.jpg?alt=media&token=a3e639ce-55d6-4efe-9071-3d766cf6b55f",
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )),
                                                  Expanded(
                                                      child: Container(
                                                    child: ListView(
                                                      children: [
                                                        ListTile(
                                                          onTap: () {},
                                                          onLongPress: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pushNamed(
                                                                    WorkoutStart
                                                                        .id,
                                                                    arguments: {
                                                                  "name":
                                                                      "Arm Day"
                                                                });
                                                          },
                                                          leading: Icon(
                                                            Icons.play_arrow,
                                                            color: Colors.white,
                                                          ),
                                                          title: Text(
                                                            "Hold to start arm day. Click to view.",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline1,
                                                          ),
                                                        ),
                                                        ListTile(
                                                          onTap: () {
                                                            print("test");
                                                          },
                                                          onLongPress: () {},
                                                          leading: Icon(
                                                            Icons
                                                                .remove_red_eye,
                                                            color: Colors.white,
                                                          ),
                                                          title: Text(
                                                            "View All Workouts.",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              height: 20.0,
                                              width: 320.0,
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                    color: Colors.green,
                                                  )),
                                                  Expanded(
                                                      child: Container(
                                                    color: Colors.purple,
                                                  )),
                                                ],
                                              ),
                                            );
                                    },
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: QueryButton(
                                        color: Colors.red,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Column(
                                          children: [
                                            Icon(
                                              Icons.clear_outlined,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "Dismiss",
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: QueryButton(
                                        color: Colors.blue,
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pushNamed(PlansMeals.id);
                                        },
                                        icon: Column(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "Log Meals",
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
            },
            onPageChanged: (focusedDay) {
              // _focusedDay = focusedDay;
            },
            calendarFormat: _calendarFormat ,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
        ),
      ),
    );
  }
}
