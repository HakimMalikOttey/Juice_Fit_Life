import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_in.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/code_input.dart';
import 'package:jfl2/Screens/sign_in_sign_up/sign_up/password_retrieval.dart';
import 'package:jfl2/Screens/start.dart';
import 'package:jfl2/components/AnimatedBackground.dart';
import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/background_image_container.dart';

class StartWrapper extends StatefulWidget {
  static String id = "StartWrapper";
  _StartWrapper createState() => _StartWrapper();
}

class _StartWrapper extends State<StartWrapper> with TickerProviderStateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();
  Animation<double>? _animation;
  AnimationController? _controller1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: Duration(milliseconds: 20000));
    _animation =
        new Tween<double>(begin: 0.5, end: 1.0).animate(new CurvedAnimation(
      parent: _controller1 as AnimationController,
      curve: Curves.easeIn.flipped,
    ));
    // _controller1.repeat();
  }

  @override
  void dispose() {
    _controller1?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: Alignment.center,
          children: [
            ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: AnimatedBackground(),
                ),
              ],
            ),
            Container(
              child: MediaQuery.of(context).viewInsets.bottom == 0
                  ? Positioned(
                      bottom: 0,
                      child: Container(
                        color: Colors.grey,
                        height: MediaQuery.of(context).size.height / 5.5,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text("© Juice Fit Life Company"),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ),
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 180.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Image.asset(
                            "assets/placeholder_logo.png",
                            width: 150.0,
                          ),
                        ),
                        Container(
                          color: Colors.grey[800],
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: MediaQuery.of(context).size.height / 2.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Navigator(
                              key: _navigatorKey,
                              initialRoute: SignIn.id,
                              onGenerateRoute: (settings) {
                                WidgetBuilder builder;
                                if (settings.name == Start.id)
                                  builder = (context) => Start();
                                else if (settings.name == SignIn.id)
                                  builder = (context) => SignIn();
                                else if (settings.name == SignUp.id)
                                  builder = (context) => SignUp();
                                else if (settings.name == PasswordRetrieval.id)
                                  builder = (context) => PasswordRetrieval();
                                else if (settings.name == CodeInput.id)
                                  builder = (context) => CodeInput();
                                else
                                  builder = (context) => SignIn();
                                return MaterialPageRoute(
                                    builder: builder, settings: settings);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        // Image.asset(
                        //   "assets/placeholder_logo.png",
                        //   width: 150.0,
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
