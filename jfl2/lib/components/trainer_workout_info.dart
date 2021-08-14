import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/components/custom_alert_box.dart';
import 'package:jfl2/components/plan_maker_popup.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/trainer_workout_editor_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:jfl2/data/vimeo_data.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'loading_dialog.dart';
import 'package:vimeoplayer/vimeoplayer.dart';

class TrainerWorkoutInfo extends StatefulWidget {
  final TextEditingController name;
  final TextEditingController description;
  final int type;
  TrainerWorkoutInfo(
      {required this.name, required this.type, required this.description});
  @override
  _TrainerWorkoutInfoState createState() => _TrainerWorkoutInfoState();
}

class _TrainerWorkoutInfoState extends State<TrainerWorkoutInfo> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TrainerWorkoutEditorData>(builder: (context, data, child) {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                child: CustomTextBox(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]'))
                  ],
                  active: widget.type == 2 ? false : true,
                  controller: data.name,
                  labelText: 'Workout Name...(Required)',
                  onChanged: (text) {
                    print(data.name.text);
                    data.refresh();
                  },
                  maxlength: 20,
                ),
              ),
            ),
            CustomTextBox(
              keyboardType: TextInputType.multiline,
              controller: data.description,
              active: widget.type == 2 ? false : true,
              labelText: "Workout Description (Required)",
              onChanged: (text) {
                data.refresh();
              },
              lines: 3,
              // maxlength: 150,
            ),
            // SizedBox(
            //   height: 20.0,
            // ),
            Container(
              child: widget.type == 2
                  ? Container()
                  : SquareButton(
                      padding: EdgeInsets.only(top: 0),
                      color: Colors.black,
                      pressed: () async {
                        // setState(() {
                        //   data.appendLink();
                        // });
                        if(Provider.of<UserData>(context,listen: false).access_token.isEmpty){
                          return showDialog(context: context, builder: (context)=>CustomAlertBox(
                              infolist: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text("You have not linked a Vimeo account to Juice Fit Life."
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text("A Vimeo account is required to link videos in your plan."),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text("Go to Settings > Linked Accounts to link a Vimeo Account to your Juice Fit Life account."),
                                )

                              ],
                            actionlist: <Widget>[
                              FlatButton(
                                child: Text("Ok"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ));
                        }
                        else{
                          await showDialog(
                              context: context,
                              builder: (context) => LoadingDialog(
                                  future: Provider.of<UserData>(context)
                                      .getVimeoVideos(),
                                  successRoutine: (data) async {
                                    Navigator.pop(context);
                                    final Map videodata = jsonDecode(data.data);
                                    return WidgetsBinding.instance
                                        ?.addPostFrameCallback((_) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color:
                                            Theme.of(context).shadowColor,
                                            child: Scaffold(
                                              appBar: AppBar(
                                                leading: IconButton(
                                                  icon: Icon(
                                                      Icons.arrow_back_ios),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                title: Text('Select A Video'),
                                              ),
                                              body: ListView.builder(
                                                  itemCount: videodata["data"]
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          bottom: 10.0),
                                                      child: ListTile(
                                                        leading: Image.network(
                                                            "${videodata["data"][index]["pictures"]["sizes"][0]["link"]}"),
                                                        title: Text(
                                                          '${videodata["data"][index]["name"]}',
                                                        ),
                                                        onTap: () {
                                                          Provider.of<TrainerWorkoutEditorData>(
                                                              context,
                                                              listen:
                                                              false)
                                                              .appendLink(new VimeoData(
                                                              link:
                                                              "${videodata["data"][index]["link"]}",
                                                              name:
                                                              '${videodata["data"][index]["name"]}',
                                                              thumbnail:
                                                              "${videodata["data"][index]["pictures"]["sizes"][0]["link"]}"));
                                                          Navigator.pop(
                                                              context);
                                                          // Navigator.of(context,
                                                          //         rootNavigator: true)
                                                          //     .pushNamed(
                                                          //         LinkedAccounts.id);
                                                          // scaffoldKey.currentState.openEndDrawer();
                                                          // navigatorKey.currentState.pushNamed(TrainerMainMenu.id);
                                                        },
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ));
                                    });
                                    // print(data);

                                    // return Navigator.pop(context);
                                  },
                                  failedRoutine: (data) {
                                    print(data);
                                  },
                                  errorRoutine: (data) {
                                    print(data);
                                  }));
                        }
                        // data.appendWorkout();
                      },
                      butContent: Row(
                        children: [
                          Text(
                            "Link A Video",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(Icons.add_circle_outline_outlined)
                        ],
                      ),
                      buttonwidth: MediaQuery.of(context).size.width,
                      height: 50.0,
                    ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: Provider.of<TrainerWorkoutEditorData>(context)
                    .youtubeLinks
                    .length,
                itemBuilder: (context, index) {
                  return Padding(
                    key: ObjectKey(index),
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: ListTile(
                      tileColor: Theme.of(context).cardColor,
                      leading: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.network(
                            "${Provider.of<TrainerWorkoutEditorData>(context).youtubeLinks[index].thumbnail}"),
                      ),
                      title: Text(
                        '${Provider.of<TrainerWorkoutEditorData>(context).youtubeLinks[index].name}',
                      ),
                      onTap: () {
                        String link = Provider.of<TrainerWorkoutEditorData>(context,listen: false).youtubeLinks[index].link!;
                        print("----------------------------");
                        print(link.substring(link.lastIndexOf("/")+1));
                        print("----------------------------");
                        showDialog(
                            context: context,
                            builder: (context) => Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: PlanMakerPopUp(
                                    name:
                                        '${Provider.of<TrainerWorkoutEditorData>(context,listen: false).youtubeLinks[index].name}',
                                    listview: [
                                      Expanded(
                                        // child: WebView(
                                        //   javascriptMode:
                                        //       JavascriptMode.unrestricted,
                                        //   initialUrl: Provider.of<
                                        //               TrainerWorkoutEditorData>(
                                        //           context)
                                          //       .youtubeLinks[index]
                                        //       .link,
                                        // ),
                                        child: Material(
                                          child: VimeoPlayer(id:"574744500",looping: false, autoPlay: false,
                                      ),
                                        ))
                                    ],
                                    remove: widget.type != 2
                                        ? () {
                                            setState(() {
                                              Provider.of<TrainerWorkoutEditorData>(
                                                      context,
                                                      listen: false)
                                                  .youtubeLinks
                                                  .removeAt(index);
                                            });
                                            Navigator.pop(context);
                                          }
                                        : null,
                                  ),
                                ));
                        // Navigator.pop(context);
                        // Navigator.of(context,
                        //         rootNavigator: true)
                        //     .pushNamed(
                        //         LinkedAccounts.id);
                        // scaffoldKey.currentState.openEndDrawer();
                        // navigatorKey.currentState.pushNamed(TrainerMainMenu.id);
                      },
                    ),
                  );
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = Provider.of<TrainerWorkoutEditorData>(context,
                            listen: false)
                        .youtubeLinks
                        .removeAt(oldIndex);
                    Provider.of<TrainerWorkoutEditorData>(context,
                            listen: false)
                        .youtubeLinks
                        .insert(newIndex, item);
                    print(data.SetsList);
                  });
                },
              ),
            )
            // Padding(
            //   padding: const EdgeInsets.only(top: 8.0),
            //   child: Container(
            //     height: 60.0,
            //     child: Row(
            //       children: [
            //         Expanded(
            //           // child: CustomTextBox(
            //           //   active: true,
            //           //   controller: test,
            //           //   hintText:
            //           //       'Input Youtube Video Link...(Required)',
            //           //   onChanged: (value) {},
            //           // ),
            //           child: SquareButton(
            //             padding: EdgeInsets.only(top: 0),
            //             color: Colors.black,
            //             pressed: () async {},
            //             butContent: Row(
            //               children: [
            //                 Text(
            //                   "Select a Video",
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //                 SizedBox(
            //                   width: 10.0,
            //                 ),
            //                 // Icon(Icons.add_circle_outline_outlined)
            //               ],
            //             ),
            //             buttonwidth:
            //                 MediaQuery.of(context).size.width,
            //             height: 50.0,
            //           ),
            //         ),
            //         VimeoQueryButton(
            //           ontap: () {},
            //         ),
            //         VimeoQueryButton(
            //           ontap: () {},
            //         ),
            //         VimeoQueryButton(
            //           ontap: () {},
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // YoutubeUploadList(
            //     scrollController: _myController,
            //     callback: this.callback,
            //     youtubeLinks: data.youtubeLinks,
            //     menu: widget.type == 2 ? false : true),
          ],
        ),
      );
    });
  }
}
