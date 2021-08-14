import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/contact_info.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/password_info.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/physical_condition.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/step_transition.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/student_info_compile.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/trainer_info_compile.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/user_name_info.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/user_personal_info.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/custom_page_route.dart';
import 'package:jfl2/data/sign_up_template.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';

class SignUpWrapper extends StatefulWidget {
  static String id = "SignUpWrapper";
  //0 - User
  // 1 - Trainer
  final int? userType;
  SignUpWrapper({@required this.userType});
  @override
  _SignUpWrapperState createState() => _SignUpWrapperState();
}

class _SignUpWrapperState extends State<SignUpWrapper> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  // 0 - Neutral(user hasnt inputted anything in that field set yet)
  //1 - Active(User is currently inputting data into that field set)
  // 2 - Finished(User has finished inputting data into that field set)
  //3 - Error(The User has inputted illegal data into that field set, or has left something empty in it)

  int step = 0;
  List<SignUpTemplate> studentSignUp = [];
  List<SignUpTemplate> trainerSignUp = [];
  bool isLoaded = false;
  bool validData = false;
  @override
  void didChangeDependencies() {
    if (isLoaded == false) {
      studentSignUp = [
        new SignUpTemplate(state: 0, page: UserPersonalInfo.id, arguments: {
          "user": Provider.of<StudentSignUpData>(context, listen: false)
              .studentData,
          "validate": allowAdvance
        }),
        new SignUpTemplate(state: 0, page: ContactInfo.id, arguments: {
          "user": Provider.of<StudentSignUpData>(context, listen: false)
              .studentData,
          "validate": allowAdvance
        }),
        new SignUpTemplate(state: 0, page: UserNameInfo.id, arguments: {
          "user": Provider.of<StudentSignUpData>(context, listen: false)
              .studentData,
          "validate": allowAdvance
        }),
        new SignUpTemplate(state: 0, page: PasswordInfo.id, arguments: {
          "user": Provider.of<StudentSignUpData>(context, listen: false)
              .studentData,
          "validate": allowAdvance,
          "reset": false,
        }),
        new SignUpTemplate(
            state: 0,
            page: PhysicalConditions.id,
            arguments: {"validate": allowAdvance}),
        new SignUpTemplate(
            state: 0,
            page: StudentInfoCompile.id,
            arguments: {"edit": toggleState}),
      ];
      trainerSignUp = [
        new SignUpTemplate(state: 0, page: UserPersonalInfo.id, arguments: {
          "user": Provider.of<TrainerSignUpData>(context, listen: false)
              .trainerData,
          "validate": allowAdvance
        }),
        new SignUpTemplate(state: 0, page: ContactInfo.id, arguments: {
          "user": Provider.of<TrainerSignUpData>(context, listen: false)
              .trainerData,
          "validate": allowAdvance
        }),
        new SignUpTemplate(state: 0, page: UserNameInfo.id, arguments: {
          "user": Provider.of<TrainerSignUpData>(context, listen: false)
              .trainerData,
          "validate": allowAdvance
        }),
        new SignUpTemplate(state: 0, page: PasswordInfo.id, arguments: {
          "user": Provider.of<TrainerSignUpData>(context, listen: false)
              .trainerData,
          "validate": allowAdvance,
          "reset": false,
        }),
        new SignUpTemplate(
            state: 0,
            page: TrainerInfoCompile.id,
            arguments: {"edit": toggleState}),
      ];
      toggleState(step);
      isLoaded = true;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // {"state": 0, "page": UserPersonalInfo.id, "arguments":{"user":Provider.of<StudentSignUpData>(context)}},
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: widget.userType == 0
            ? Text("Student Sign Up")
            : Text("Trainer Sign Up"),
        leading: IconButton(
          icon: Text("Cancel"),
          onPressed: () {
             exitSignUp();
          },
        ),
        actions: [
          Container(
            child: step != 0 && validData != false
                ? IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      setState(() {
                        step--;
                        toggleState(step);
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
                    onPressed: () {},
                  ),
          ),
          Container(
            child: widget.userType == 0 &&
                        step != studentSignUp.length - 1 &&
                        validData != false ||
                    widget.userType == 1 &&
                        step != trainerSignUp.length - 1 &&
                        validData != false
                ? IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      setState(() {
                        step++;
                        toggleState(step);
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onPressed: () {},
                  ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Row(
              children: List.generate(
            widget.userType == 0 ? studentSignUp.length : trainerSignUp.length,
            (index) => Expanded(
              child: GestureDetector(
                onTap: () {
                  // setState(() {
                  //   step = index;
                  //   toggleState(index,
                  //       widget.userType == 0 ? studentSignUp : trainerSignUp);
                  // });
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Builder(builder: (context) {
                      final List<SignUpTemplate> currentStep =
                          widget.userType == 0 ? studentSignUp : trainerSignUp;
                      if (currentStep[index].state == 0) {
                        return Container(
                          color: Colors.white,
                          height: 20.0,
                        );
                      } else if (currentStep[index].state == 1) {
                        return Container(
                          color: Colors.green,
                          height: 20.0,
                        );
                      } else if (currentStep[index].state == 2) {
                        return Container(
                          color: Colors.blue,
                          height: 20.0,
                        );
                      } else {
                        return Container(
                          color: Colors.red,
                          height: 20.0,
                        );
                      }
                    })),
              ),
            ),
          )),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          exitSignUp();
          return Future.value(false);
        },
        child: Navigator(
          key: _navigatorKey,
          initialRoute: StepTransition.id,
          onGenerateRoute: (settings) {
            Map arguments ={};
            if(settings.arguments != null){
             arguments = settings.arguments as Map;
            }
            WidgetBuilder builder;
            if (settings.name == UserPersonalInfo.id)
              builder = (context) => UserPersonalInfo(
                    user: arguments["user"],
                    validate: arguments["validate"],
                  );
            else if (settings.name == ContactInfo.id)
              builder = (context) => ContactInfo(
                    user: arguments["user"],
                    validate: arguments["validate"],
                  );
            else if (settings.name == UserNameInfo.id)
              builder = (context) => UserNameInfo(
                  user: arguments["user"], validate: arguments["validate"]);
            else if (settings.name == PasswordInfo.id)
              builder = (context) => PasswordInfo(
                    user: arguments["user"],
                    validate: arguments["validate"],
                    reset: arguments["reset"],
                  );
            else if (settings.name == PhysicalConditions.id)
              builder = (context) =>
                  PhysicalConditions(validate: arguments["validate"]);
            else if (settings.name == StudentInfoCompile.id)
              builder = (context) => StudentInfoCompile(
                    edit: arguments["edit"],
                  );
            else if (settings.name == TrainerInfoCompile.id)
              builder = (context) => TrainerInfoCompile(
                    edit: arguments["edit"],
                  );
            else
              builder = (context) => StepTransition();
            return CustomPageRoute(builder: builder, settings: settings);
          },
        ),
      ),
    );
  }

  void toggleState(int i) {
    step = i;
    List<SignUpTemplate> stepList =
        widget.userType == 0 ? studentSignUp : trainerSignUp;
    for (int index = 0; index < stepList.length; index++) {
      if (index == stepList.length - 1) {
        stepList[index].state = 0;
      } else if (stepList[index].state == 1 || stepList[index].state == 2) {
        stepList[index].state = 2;
      } else if (stepList[index].state != 2 || stepList[index].state != 3) {
        stepList[index].state = 0;
      }
    }
    stepList[i].state = 1;
    Future(() {
      _navigatorKey.currentState?.pushReplacementNamed(stepList[i].page,
          arguments: stepList[i].arguments);
      // Navigator.of(context, rootNavigator: true)
      //     .pushNamed(stepList[i].page, arguments: stepList[i].arguments);
    });
  }

  void allowAdvance(bool valid) {
    if (valid == true) {
      setState(() {
        validData = true;
      });
    } else {
      setState(() {
        validData = false;
      });
    }
  }

  Future exitSignUp() {
    var baseDialog = CustomAlertBox(
      infolist: <Widget>[
        Text(
            "If you exit out of sign up, you will lose all previously inputted data! Do you want to continue?"),
      ],
      actionlist: <Widget>[
        FlatButton(
          child: Text("Yes"),
          onPressed: () {
            if (widget.userType == 0) {
              Provider.of<StudentSignUpData>(context, listen: false)
                  .resetData();
            } else {
              Provider.of<TrainerSignUpData>(context, listen: false)
                  .resetData();
            }
            // Provider.of<MealPlanMakerData>(context, listen: false).mealname.clear();
            Navigator.of(context, rootNavigator: true).pop(true);
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
        )
      ],
    );
    return showDialog(
        context: context, builder: (BuildContext context) => baseDialog);
  }
}
