import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/code_input.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/contact_info.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/password_info.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/password_retrieval.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/physical_condition.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/sign_up_wrapper.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/student_info_compile.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/trainer_info_compile.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/user_name_info.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/user_personal_info.dart';
import 'package:jfl2/Screens/students/meal_view.dart';
import 'package:jfl2/Screens/students/open_food_facts_load.dart';
import 'package:jfl2/Screens/students/plans_meals.dart';
import 'package:jfl2/Screens/students/plans_shop.dart';
import 'package:jfl2/Screens/students/student_end_user_license.dart';
import 'package:jfl2/Screens/students/student_menu_wrapper.dart';
import 'package:jfl2/Screens/students/your_calendar.dart';
import 'package:jfl2/Screens/trainers/End_User_License.dart';
import 'package:jfl2/Screens/students/Student_Main_Menu.dart';
import 'package:jfl2/Screens/students/calorie_break_down.dart';
import 'package:jfl2/Screens/trainers/linked_accounts.dart';
import 'package:jfl2/Screens/trainers/stretch_editor.dart';
import 'package:jfl2/Screens/trainers/level_editor.dart';
import 'package:jfl2/Screens/trainers/level_editor_launch.dart';
import 'package:jfl2/Screens/trainers/client_profile.dart';
import 'package:jfl2/Screens/sign_in_sign_up/reset_username.dart';
import 'package:jfl2/Screens/trainers/day_editor_launch.dart';
import 'package:jfl2/Screens/trainers/meal_plan_editor_launch.dart';
import 'package:jfl2/Screens/trainers/plan_editor_launch.dart';
import 'package:jfl2/Screens/students/student_sign_up.dart';
import 'package:jfl2/Screens/students/member_sign_up_goals.dart';
import 'package:jfl2/Screens/trainers/plan_info.dart';
// import 'package:juice_fit_life/Screens/trainers/plan_partition_maker.dart';
import 'package:jfl2/Screens/students/plans_wrapper.dart';
import 'package:jfl2/Screens/students/plans_upcoming.dart';
import 'package:jfl2/Screens/students/schedule_session_time.dart';
import 'package:jfl2/Screens/sign_in_sign_up/send_email.dart';
import 'package:jfl2/Screens/start.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_in.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up.dart';
import 'package:jfl2/Screens/trainers/day_editor.dart';
import 'package:jfl2/Screens/trainers/meal_plan_maker.dart';
import 'package:jfl2/Screens/trainers/trainer_menu_wrappers.dart';
import 'package:jfl2/Screens/trainers/trainer_notifications.dart';
import 'package:jfl2/Screens/trainers/partition_editor_launch.dart';
import 'package:jfl2/Screens/trainers/plan_editor.dart';
import 'package:jfl2/Screens/trainers/plan_maker_wrapper.dart';
import 'package:jfl2/Screens/trainers/trainer_settings.dart';
import 'package:jfl2/Screens/trainers/stretch_editor_launch.dart';
import 'package:jfl2/Screens/trainers/upload_preperation.dart';
import 'package:jfl2/Screens/trainers/week_editor.dart';
import 'package:jfl2/Screens/trainers/week_editor_launch.dart';
import 'package:jfl2/Screens/trainers/youtube_presentation.dart';
import 'package:jfl2/data/day_meal_data.dart';
import 'package:jfl2/data/secret.dart';
import 'package:jfl2/data/secret_loader.dart';
import 'package:jfl2/data/stretch_maker_data.dart';
import 'package:jfl2/data/trainer_level_editor_data.dart';
import 'package:jfl2/data/trainer_partition_editor_data.dart';
import 'package:jfl2/data/trainer_week_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'Screens/sign_in_sign_up/reset_password.dart';
import 'Screens/sign_in_sign_up/send_email.dart';
import 'Screens/students/payment_portal.dart';
import 'Screens/trainers/partition_editor.dart';
import 'package:jfl2/Screens/sign_in_sign_up/general_sign_up.dart';
import 'package:jfl2/Screens/trainers/workout_editor.dart';
import 'package:jfl2/Screens/trainers/trainer_your_clients.dart';
import 'package:jfl2/Screens/trainers/trainer_your_plans.dart';
import 'package:jfl2/Screens/trainers/trainer_your_sessions.dart';
import 'package:jfl2/Screens/trainers/workout_editor_launch.dart';
import 'package:jfl2/Screens/students/workout_preview.dart';
import 'package:jfl2/Screens/students/workout_review.dart';
import 'package:jfl2/Screens/students/workout_start.dart';
import 'package:jfl2/Screens/trainers/workout_type_selector.dart';
import 'package:jfl2/components/custom_page_route.dart';
import 'package:jfl2/components/dynamic_link_service.dart';
import 'package:jfl2/components/locator.dart';
import 'package:jfl2/components/navigation_service.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/plan_editor_data.dart';
import 'package:jfl2/data/sign_in_data.dart';
import 'package:jfl2/data/student_sign_up_data.dart';
import 'package:jfl2/data/trainer_day_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:jfl2/data/goal_data.dart';
import 'package:jfl2/data/plan_data.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:jfl2/Screens/trainers/Trainer_Main_Menu.dart';
import 'package:jfl2/Screens/students/plans_upcoming.dart';
import 'package:jfl2/Screens/sign_in_sign_up/start_wrapper.dart';
import 'dart:io';
// import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'components/show_dialog_dismiss.dart';
import 'package:push_notification/push_notification.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

var port = 4000;
final FlutterAppAuth appAuth = FlutterAppAuth();
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
 late String AUTH0_DOMAIN;
 late String AUTH0_CLIENT_ID;

late String AUTH0_REDIRECT_URI;
late String AUTH0_ISSUER;
//ipv4 Mom
// final link = '192.168.1.6:3000';
//ipv4 Dad
// final link = '192.168.1.6:3000';
late final link;
late Notificator notification;

String _bodyText = 'notification test';
String notificationKey = 'key';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
// final BehaviorSubject<String?> selectNotificationSubject =
// BehaviorSubject<String?>();
String? selectedNotificationPayload;
void main() async {
  HttpOverrides.global = new MyHttpOverrides();
    WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  //Grab secret info and make it public for the app to use
  Secret secretData =
  await SecretLoader(secretPath: "secrets.json").load();
  AUTH0_DOMAIN = "${secretData.AUTH0DOMAIN}";
  AUTH0_CLIENT_ID = "${secretData.AUTH0CLIENTID}";
  AUTH0_REDIRECT_URI = "${secretData.AUTH0REDIRECTURI}";
  link = "${secretData.link}";
  AUTH0_DOMAIN = 'https://$AUTH0_DOMAIN';
  //End of secret parsing

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails!.payload;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (
          int id,
          String? title,
          String? body,
          String? payload,
          ) async {
        // didReceiveLocalNotificationSubject.add(
        //   ReceivedNotification(
        //     id: id,
        //     title: title,
        //     body: body,
        //     payload: payload,
        //   ),
        // );
      });
  const MacOSInitializationSettings initializationSettingsMacOS =
  MacOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectedNotificationPayload = payload;
        // selectNotificationSubject.add(payload);
      });
  test();
  runApp(juice_fit_life());
}

class juice_fit_life extends StatefulWidget {
  @override
  _juice_fit_lifeState createState() => _juice_fit_lifeState();
}

class _juice_fit_lifeState extends State<juice_fit_life> {
  String text = 'Click the button to start the payment';
  double totalCost = 10.0;
  double tip = 1.0;
  double tax = 0.0;
  double taxPercent = 0.2;
  int amount = 0;
  bool showSpinner = false;
  String url =
      'https://us-central1-demostripe-b9557.cloudfunctions.net/StripePI';
  bool isBusy = false;
  bool isLoggedIn = false;
  late String errorMessage;
  late String name;
  late String picture;

  @override

  // final DynamicLinkService dynamicLinkService = locator<DynamicLinkService>();
  // WidgetBuilder linkbuilder;
  var link;

  @override
  void initState() {
    // notification = Notificator(
    //   onPermissionDecline: () {
    //     // ignore: avoid_print
    //     print('permission decline');
    //   },
    //   onNotificationTapCallback: (notificationData) {
    //     setState(
    //           () {
    //         _bodyText = 'notification open: '
    //             '${notificationData[notificationKey].toString()}';
    //       },
    //     );
    //   },
    // )..requestPermissions(
    //   requestSoundPermission: true,
    //   requestAlertPermission: true,
    // );
    // notification.show(1, "hello", "this is test");
    initAction();
    super.initState();
    initDynamicLinks();
  }

  void initAction() async {
    final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
    });

    try {
      final response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      final idToken = parseIdToken(response!.idToken as String);
      final profile = await getUserDetails(response.accessToken as String);

      secureStorage.write(key: 'refresh_token', value: response.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        picture = profile['picture'];
      });
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      logoutAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    var routes = {
      Start.id: (context) => Start(),
      SignIn.id: (context) => SignIn(),
      SignUp.id: (context) => SignUp(),
      MemberSignUp.id: (context) => MemberSignUp(),
      MemberSignUpGoals.id: (context) => MemberSignUpGoals(),
      StudentEndUserLicense.id: (context) => StudentEndUserLicense(),
      GeneralSignUp.id: (context) => GeneralSignUp(),
      TrainerEndUserLicense.id: (context) => TrainerEndUserLicense(),
      StudentMainMenu.id: (context) => StudentMainMenu(),
      PlanInfo.id: (context) => PlanInfo(),
      TrainerMainMenu.id: (context) => TrainerMainMenu(),
      SendEmail.id: (context) => SendEmail(),
      ResetUsername.id: (context) => ResetUsername(),
      SignUpWrapper.id: (context) => SignUpWrapper(),
      PlansUpcoming.id: (context) => PlansUpcoming(),
      ScheduleSessionTime.id: (context) => ScheduleSessionTime(),
      CalorieBreakDown.id: (context) => CalorieBreakDown(),
      WorkoutPreview.id: (context) => WorkoutPreview(),
      WorkoutStart.id: (context) => WorkoutStart(),
      WorkoutReview.id: (context) => WorkoutReview(),
      TrainerYourPlans.id: (context) => TrainerYourPlans(),
      TrainerYourClients.id: (context) => TrainerYourClients(),
      TrainerYourSessions.id: (context) => TrainerYourSessions(),
      TrainerNotifications.id: (context) => TrainerNotifications(),
      TrainerSettings.id: (context) => TrainerSettings(),
      ClientProfile.id: (context) => ClientProfile(),
      TrainerPlanEditor.id: (context) => TrainerPlanEditor(),
      TrainerWorkoutMakerStraight.id: (context) =>
          TrainerWorkoutMakerStraight(),
      TrainerMealPlanMaker.id: (context) => TrainerMealPlanMaker(),
      TrainerDayMaker.id: (context) => TrainerDayMaker(),
      // PlanPartitionMaker.id: (context) => PlanPartitionMaker(),
      PlansWrapper.id: (context) => PlansWrapper(),
      StartWrapper.id: (context) => StartWrapper(),
      TrainerPlanMakerWrapper.id: (context) => TrainerPlanMakerWrapper(),
      PlanEditorLaunch.id: (context) => PlanEditorLaunch(),
      DayEditorLaunch.id: (context) => DayEditorLaunch(),
      WorkoutEditorLaunch.id: (context) => WorkoutEditorLaunch(),
      MealPlanEditorLaunch.id: (context) => MealPlanEditorLaunch(),
      WorkoutTypeSelector.id: (context) => WorkoutTypeSelector(),
      ResetPassword.id: (context) => ResetPassword(),
      PaymentPortal.id: (context) => PaymentPortal(),
      TrainerPartitionEditorLaunch.id: (context) =>
          TrainerPartitionEditorLaunch(),
      TrainerWeekEditorLaunch.id: (context) => TrainerWeekEditorLaunch(),
      TrainerLevelEditorLaunch.id: (context) => TrainerLevelEditorLaunch(),
      TrainerStretchEditorLaunch.id: (context) => TrainerStretchEditorLaunch(),
      StretchEditor.id: (context) => StretchEditor(),
      TrainerWeekEditor.id: (context) => TrainerWeekEditor(),
      TrainerLevelEditor.id: (context) => TrainerLevelEditor(),
      TrainerPartitionEditor.id: (context) => TrainerPartitionEditor(),
      UserPersonalInfo.id: (context) => UserPersonalInfo(),
      ContactInfo.id: (context) => ContactInfo(),
      UserNameInfo.id: (context) => UserNameInfo(),
      PasswordInfo.id: (context) => PasswordInfo(),
      PhysicalConditions.id: (context) => PhysicalConditions(),
      StudentInfoCompile.id: (context) => StudentInfoCompile(),
      PasswordRetrieval.id: (context) => PasswordRetrieval(),
      CodeInput.id: (context) => CodeInput(),
      PlansShop.id: (context) => PlansShop(),
      StudentMenuWrapper.id: (context) => StudentMenuWrapper(),
      LinkedAccounts.id: (context) => LinkedAccounts(),
      YourCalendar.id: (context) => YourCalendar(),
      PlansMeals.id: (context) => PlansMeals(),
      OpenFoodFactsLoad.id: (context) => OpenFoodFactsLoad(),
      mealView.id: (context) => mealView()
    };
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        print(currentFocus.hasPrimaryFocus);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<GoalData>(create: (_) => GoalData()),
          ChangeNotifierProvider<StudentSignUpData>(
              create: (_) => StudentSignUpData()),
          ChangeNotifierProvider<TrainerSignUpData>(
              create: (_) => TrainerSignUpData()),
          ChangeNotifierProvider<PlanData>(create: (_) => PlanData()),
          ChangeNotifierProvider<TrainerWorkoutEditorData>(
            create: (_) => TrainerWorkoutEditorData(),
          ),
          ChangeNotifierProvider<MealPlanMakerData>(
              create: (_) => MealPlanMakerData()),
          ChangeNotifierProvider<TrainerDayMakerData>(
              create: (_) => TrainerDayMakerData()),
          ChangeNotifierProvider<PlanEditorData>(
              create: (_) => PlanEditorData()),
          ChangeNotifierProvider<StretchMakerData>(
              create: (_) => StretchMakerData()),
          ChangeNotifierProvider<TrainerWeekEditorData>(
              create: (_) => TrainerWeekEditorData()),
          ChangeNotifierProvider<TrainerLevelEditorData>(
              create: (_) => TrainerLevelEditorData()),
          ChangeNotifierProvider<TrainerPartitionEditorData>(
              create: (_) => TrainerPartitionEditorData()),
          ChangeNotifierProvider<UserData>(create: (_) => UserData()),
          ChangeNotifierProvider<dayMeals>(create: (_) => dayMeals())
        ],
        child: Container(
          child: MaterialApp(
            theme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Color(0xFF5F0000),
                accentColor: Colors.white,
                disabledColor: Colors.black,
                errorColor: Colors.red,
                toggleableActiveColor: Colors.green,
                secondaryHeaderColor: Colors.transparent,
                cardColor: Colors.white10,
                shadowColor: Colors.grey[900],
                dividerTheme: DividerThemeData(
                  thickness: 2.0,
                  color: Colors.white,
                ),
                iconTheme: IconThemeData(color: Colors.black),
                textTheme: TextTheme(
                    headline1: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    headline2: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    headline3: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    //negative action
                    headline4: TextStyle(
                        fontSize: 15.0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                    //affirmative action
                    headline5: TextStyle(
                        fontSize: 15.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    headline6: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))),
            //Don't remove this. this prevents the app from crashing when opening the app via a dynamic link
            //if removed a repeated key error will be caused
            home: StartWrapper(),
            initialRoute: StartWrapper.id,
            onGenerateRoute: (settings) {
              // initDynamicLinks();
              // print(settings);
              print("!-----------------!");
              print(settings);
              print("!-----------------!");
              // final test = Uri.parse(settings.name);
              WidgetBuilder builder;
              print(settings.arguments);
              late Map arguments;
              if(settings.arguments != null){
                arguments = settings.arguments! as Map;
              }
              if (settings.name == PlanInfo.id) {
                builder = (
                    context,
                    ) =>
                    PlanInfo(
                        name: arguments["name"],
                        author: arguments["auth"],
                        intropar: arguments["intro"],
                        authorinfo: arguments['authInfo'],
                        comments: arguments['comments'],
                        authpic: arguments['picture']);
              } else if (settings.name == SendEmail.id) {
                builder = (
                    context,
                    ) =>
                    SendEmail(
                      url: arguments['url'],
                      type: arguments['type'],
                    );
              }
              // else if (settings.name == PlanPartitionMaker.id) {
              //   builder = (
              //     context,
              //   ) =>
              //       PlanPartitionMaker(
              //         partitionindex: arguments["partitionindex"],
              //       );
              // }
              else if (settings.name == TrainerMealPlanMaker.id) {
                builder = (
                    context,
                    ) =>
                    TrainerMealPlanMaker(
                      mealid: arguments["mealid"],
                      type: arguments["type"],
                    );
              } else if (settings.name == mealView.id) {
                builder = (context) => mealView(
                  name: arguments["name"],
                  kCalPerServ: arguments["kCal"],
                  cholesteral: arguments["cholesteral"],
                  protien: arguments["protien"],
                  sodium: arguments["sodium"],
                  tranFat: arguments["tranFat"],
                  totalCarbs: arguments["totalCarbs"],
                  totalSugar: arguments["totalSugar"],
                  dietFiber: arguments["dietFiber"],
                  satFat: arguments["satFat"],
                );
              } else if (settings.name == WorkoutStart.id) {
                builder = (context) => WorkoutStart(name: arguments["name"]);
              } else if (settings.name == TrainerWorkoutMakerStraight.id) {
                builder = (
                    context,
                    ) =>
                    TrainerWorkoutMakerStraight(
                      workoutid: arguments["workoutid"],
                      type: arguments["type"],
                    );
              } else if (settings.name == GeneralSignUp.id) {
                builder = (context) => GeneralSignUp(
                    setting: arguments["setting"], type: arguments["type"]);
              } else if (settings.name == StretchEditor.id) {
                builder = (context) => StretchEditor(
                  stretchId: arguments["stretchId"],
                  name: arguments["name"],
                  youtubeLink: arguments["media"],
                  type: arguments["type"],
                );
              } else if (settings.name == TrainerDayMaker.id) {
                builder = (context) => TrainerDayMaker(
                  dayId: arguments["dayId"],
                  type: arguments["type"],
                );
              } else if (settings.name == DayEditorLaunch.id) {
                builder = (context) =>
                    DayEditorLaunch(menuType: arguments["menuType"]);
              } else if (settings.name == MealPlanEditorLaunch.id) {
                builder = (context) =>
                    MealPlanEditorLaunch(menuType: arguments["menuType"]);
              } else if (settings.name == TrainerWeekEditorLaunch.id) {
                builder = (context) =>
                    TrainerWeekEditorLaunch(menuType: arguments["menuType"]);
              } else if (settings.name == TrainerLevelEditorLaunch.id) {
                builder = (context) =>
                    TrainerLevelEditorLaunch(menuType: arguments["menuType"]);
              } else if (settings.name == TrainerPartitionEditorLaunch.id) {
                builder = (context) => TrainerPartitionEditorLaunch(
                    menuType: arguments["menuType"]);
              } else if (settings.name == PlanEditorLaunch.id) {
                builder = (context) =>
                    PlanEditorLaunch(menuType: arguments["menuType"]);
              } else if (settings.name == WorkoutEditorLaunch.id) {
                builder = (context) =>
                    WorkoutEditorLaunch(menuType: arguments["menuType"]);
              } else if (settings.name == TrainerWeekEditor.id) {
                builder = (context) => TrainerWeekEditor(
                  weekid: arguments["weekid"],
                  type: arguments["type"],
                );
              } else if (settings.name == TrainerLevelEditor.id) {
                builder = (context) => TrainerLevelEditor(
                  level: arguments["level"],
                  levelid: arguments["levelid"],
                  type: arguments["type"],
                  name: arguments["name"],
                );
              } else if (settings.name == TrainerPartitionEditor.id) {
                builder = (context) => TrainerPartitionEditor(
                  type: arguments["type"],
                  name: arguments["name"],
                  explanation: arguments["explanation"],
                  partitionId: arguments["partitionId"],
                  levels: arguments["levels"],
                  meal: arguments["meal"],
                );
              } else if (settings.name == TrainerPlanEditor.id) {
                builder = (context) => TrainerPlanEditor(
                  type: arguments["type"],
                  name: arguments["name"],
                  explanation: arguments["explanation"],
                  planId: arguments["planId"],
                  banner: arguments["banner"],
                  partitions: arguments["partitions"],
                  hook: arguments["hook"],
                );

              } else if (settings.name == TrainerMenuWrapper.id) {
                builder = (context) => TrainerMenuWrapper();
              } else if (settings.name == UploadPreperation.id) {
                builder = (context) => UploadPreperation(
                  banner: arguments["banner"],
                  title: arguments["title"],
                  author: arguments["author"],
                  hook: arguments["hook"],
                );
              } else if (settings.name == SignUpWrapper.id) {
                builder =
                    (context) => SignUpWrapper(userType: arguments["userType"]);
              } else if (settings.name == UserPersonalInfo.id) {
                builder = (context) => UserPersonalInfo(
                  user: arguments["user"],
                  validate: arguments["validate"],
                );
              } else if (settings.name == ContactInfo.id) {
                builder = (context) => ContactInfo(
                  user: arguments["user"],
                  validate: arguments["validate"],
                );
              } else if (settings.name == UserNameInfo.id) {
                builder = (context) => UserNameInfo(
                  user: arguments["user"],
                  validate: arguments["validate"],
                );
              } else if (settings.name == PasswordInfo.id) {
                builder = (context) => PasswordInfo(
                  user: arguments["user"],
                  validate: arguments["validate"],
                  reset: arguments["reset"],
                  Userid: arguments["Userid"],
                );
              } else if (settings.name == PhysicalConditions.id) {
                builder = (context) => PhysicalConditions(
                  validate: arguments["validate"],
                );
              } else if (settings.name == StudentInfoCompile.id) {
                builder = (context) => StudentInfoCompile(
                  edit: arguments["edit"],
                );
              } else if (settings.name == TrainerInfoCompile.id) {
                builder = (context) => TrainerInfoCompile(
                  edit: arguments["edit"],
                );
              } else if (settings.name == TrainerPlanMakerWrapper.id) {
                builder = (context) => TrainerPlanMakerWrapper();
              } else {
                builder = (
                    context,
                    ) =>
                    routes[settings.name]!(context);
              }
              return CustomPageRoute(builder: builder, settings: settings);
            },
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, dynamic>> getUserDetails(String accessToken) async {
    final url = 'https://$AUTH0_DOMAIN/userinfo';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });
    try {
      final AuthorizationTokenResponse? result =
      await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: ['openid', 'profile', 'offline_access'],
          // promptValues: ['login']
        ),
      );

      final idToken = parseIdToken(result!.idToken as String);
      final profile = await getUserDetails(result.accessToken as String);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        picture = profile['picture'];
      });
    } catch (e, s) {
      print('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  void logoutAction() async {}
  void initDynamicLinks() async {
    // FirebaseDynamicLinks.instance.onLink(
    //     onSuccess: (PendingDynamicLinkData? dynamicLink) async {
    //       final Uri deepLink = dynamicLink?.link as Uri;
    //       print("test");
    //       if (deepLink != null) {
    //         Map sharedListId = deepLink.queryParameters;
    //         print("reached");
    //         // WidgetsBinding.instance.addPostFrameCallback((_) {
    //         //   Navigator.pushNamed(context, TrainerPlanMakerWrapper.id);
    //         // });
    //         // Navigator.pushNamed(context, TrainerPlanMakerWrapper.id);
    //       } else {
    //         print("---------------try again 1--------------");
    //       }
    //     }, onError: (OnLinkErrorException e) async {
    //   print("test 2");
    //   print(e.message);
    // });
    // final PendingDynamicLinkData? data =
    // await FirebaseDynamicLinks.instance.getInitialLink();
    // final Uri deepLink = data?.link as Uri;
    // if (deepLink != null) {
    //   Map sharedListId = deepLink.queryParameters;
    //   print("reached");
    //   // if (deepLink.path == "/") {
    //   //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //   //     Navigator.pushNamed(context, TrainerPlanMakerWrapper.id);
    //   //   });
    //   // }
    // } else {
    //   print("---------------try again 2--------------");
    // }
  }
}

Future<http.Response> test() {
  return http.get(Uri.https('$link', "/"));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
