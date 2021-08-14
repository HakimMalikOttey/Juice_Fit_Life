import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

class LinkedAccounts extends StatefulWidget {
  static String id = "LinkedAccounts";
  @override
  _LinkedAccountsState createState() => _LinkedAccountsState();
}

class _LinkedAccountsState extends State<LinkedAccounts> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  late StreamSubscription _onDestroy;
  late StreamSubscription<String> _onUrlChanged;
  late StreamSubscription<WebViewStateChanged> _onStateChanged;
  late bool startCheck;
  late String code;
  var time;
  late Timer clock;
  @override
  void initState() {
    time = const Duration(milliseconds: 1);
    clock = new Timer.periodic(time, (timer) {
      print("test");
      setState(() {});
      if (Provider.of<UserData>(context, listen: false)
          .access_token
          .isNotEmpty) {
        clock.cancel();
      }
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await showDialog(
          context: context,
          builder: (context) => LoadingDialog(
                future:
                    Provider.of<UserData>(context, listen: false).getVimeoId(),
                errorRoutine: (data) {
                  return CustomAlertBox(
                    infolist: <Widget>[
                      Text(
                          "There was a major error in getting your Vimeo ID. Please try again later.")
                    ],
                    actionlist: <Widget>[
                      // ignore: deprecated_member_use
                      FlatButton(
                          onPressed: () {
                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              Navigator.pop(context);
                            });
                            Navigator.pop(context);
                          },
                          child: Text("Ok"))
                    ],
                  );
                },
                failedRoutine: (data) {
                  Navigator.pop(context);
                  // return CustomAlertBox(
                  //   infolist: <Widget>[
                  //     Text(
                  //         "We had a problem rendering this page. Please try again later.")
                  //   ],
                  //   actionlist: <Widget>[
                  //     // ignore: deprecated_member_use
                  //     FlatButton(
                  //         onPressed: () {
                  //           WidgetsBinding.instance.addPostFrameCallback((_) {
                  //             Navigator.pop(context);
                  //           });
                  //           Navigator.pop(context);
                  //           Navigator.pop(context);
                  //         },
                  //         child: Text("Ok"))
                  //   ],
                  // );
                },
                successRoutine: (data) {
                  final vimeoInfo = jsonDecode(data.data)["vimeo"];
                  // print("--------------");
                  // print(jsonDecode(data.data)["vimeo"]);
                  // print("--------------");
                  Provider.of<UserData>(context, listen: false).access_token =
                      vimeoInfo["access_token"];
                  print("reached");
                  Provider.of<UserData>(context, listen: false).scope =
                      vimeoInfo["scope"];
                  Provider.of<UserData>(context, listen: false).name =
                      vimeoInfo["name"];
                  Navigator.of(context).pop();
                  // print(data);
                  // final meal = jsonDecode(data.data);
                  // print(meal);
                  // name.text = meal["name"];
                  // _controller = new QuillController(
                  //   document: Document.fromJson(jsonDecode(meal["meal"])),
                  //   selection: TextSelection.collapsed(offset: 0),
                  // );
                  // print("this is fine");
                  // return WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   setState(() {
                  //     Navigator.pop(context);
                  //   });
                  // });
                },
              )).then((value) => setState(() {}));
    });
    flutterWebviewPlugin.close();
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((event) {
      print("destroy");
    });
    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url}");
    });
    _onUrlChanged =
        flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (url.startsWith("hakimottey.juicefitlife://login-callback")) {
        flutterWebviewPlugin.close();
        Navigator.pop(context);
        if (mounted) {
          print("URL changed: $url");
          RegExp regExp = new RegExp("code=(.*)");
          // print("-------------");
          // print(regExp.firstMatch(url)?.group(1));
          // print("-------------");
          this.code = regExp.firstMatch(url)?.group(1) as String;
          print("-------------");
          print(this.code);
          print("-------------");
          await showDialog(
              context: context,
              builder: (context) => LoadingDialog(
                    future: Provider.of<UserData>(context, listen: false)
                        .createVimeoId(this.code,
                            "hakimottey.juicefitlife://login-callback"),
                    errorRoutine: (data) {
                      return CustomAlertBox(
                        infolist: <Widget>[
                          Text(
                              "There was a major error in retrieving your Vimeo account. Please try again later.$data")
                        ],
                        actionlist: <Widget>[
                          // ignore: deprecated_member_use
                          FlatButton(
                              onPressed: () {
                                WidgetsBinding.instance
                                    ?.addPostFrameCallback((_) {
                                  Navigator.pop(context);
                                });
                                Navigator.pop(context);
                              },
                              child: Text("Ok"))
                        ],
                      );
                    },
                    failedRoutine: (data) {
                      Navigator.pop(context);
                      return CustomAlertBox(
                        infolist: <Widget>[
                          Text(
                              "There was an error in generating a key to link to your Vimeo account. Please try again later.")
                        ],
                        actionlist: <Widget>[
                          // ignore: deprecated_member_use
                          FlatButton(
                              onPressed: () {
                                WidgetsBinding.instance
                                    ?.addPostFrameCallback((_) {
                                  Navigator.pop(context);
                                });
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("Ok"))
                        ],
                      );
                    },
                    successRoutine: (founddata) {
                      final accountData = jsonDecode(founddata.data);
                      print(accountData);
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        Navigator.pop(context);
                         showDialog(
                            context: context,
                            builder: (context) => LoadingDialog(
                                  future: Provider.of<UserData>(context,
                                          listen: false)
                                      .submitVimeoRequest(
                                          Provider.of<UserData>(context).id as String, {
                                    "access_token": accountData["access_token"],
                                    "scope": accountData["scope"],
                                    "name": accountData["user"]["name"]
                                  }),
                                  errorRoutine: (data) {
                                    return CustomAlertBox(
                                      infolist: <Widget>[
                                        Text(
                                            "There was a major error in connecting your Vimeo account. Please try again later.")
                                      ],
                                      actionlist: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            onPressed: () {
                                              WidgetsBinding.instance
                                                  ?.addPostFrameCallback((_) {
                                                Navigator.pop(context);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text("Ok"))
                                      ],
                                    );
                                  },
                                  failedRoutine: (data) {
                                    Navigator.pop(context);
                                    return CustomAlertBox(
                                      infolist: <Widget>[
                                        Text(
                                            "There was an error in  your Vimeo account. Please try again later.")
                                      ],
                                      actionlist: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            onPressed: () {
                                              WidgetsBinding.instance
                                                  ?.addPostFrameCallback((_) {
                                                Navigator.pop(context);
                                              });
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: Text("Ok"))
                                      ],
                                    );
                                  },
                                  successRoutine: (data) {
                                    print("!!!!!!!!!!!!!!!");
                                    print(accountData);
                                    print("!!!!!!!!!!!!!!!");
                                    Provider.of<UserData>(
                                      context,
                                    ).access_token =
                                        accountData["access_token"];
                                    Provider.of<UserData>(
                                      context,
                                    ).scope = accountData["scope"];
                                    Provider.of<UserData>(
                                      context,
                                    ).name = accountData["user"]["name"];
                                    Navigator.of(context).pop();
                                  },
                                ));
                      });
                    },
                  ));
          // setState(() {});
          // print("-------------");
          // print(code);
          // print("--------------------");

        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    clock.cancel();
    super.dispose();
  }

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
          title: Text('Linked Accounts'),
        ),
        body: ListView(
          children: [
            Container(
              child: Provider.of<UserData>(context).access_token == null ||
                      Provider.of<UserData>(context).access_token == ""
                  ? ListTile(
                      title: Text("Link Your Vimeo Account"),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => WebviewScaffold(
                                  userAgent:
                                      "Mozilla/5.0 (Linux; Android 4.1.1; Galaxy Nexus Build/JRO03C) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19",
                                  url:
                                      'https://api.vimeo.com/oauth/authorize?response_type=code&client_id=6d6a413a6f0e83c3b0c82a105d7f26f93f4724b2&redirect_uri=hakimottey.juicefitlife://login-callback&scope={public private video_files}',
                                  appBar: new AppBar(
                                    title: new Text("Login to Vimeo"),
                                  ),
                                ));
                      },
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 90.0,
                      color: Theme.of(context).cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Linked Vimeo Account",
                              style: Theme.of(context).textTheme.headline6),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                              "Username: ${Provider.of<UserData>(context, listen: false).name}")
                        ],
                      ),
                    ),
            ),
          ],
        ));
  }
}
