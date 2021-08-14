import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/query_button.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PlanMakerPopUp extends StatelessWidget {
  final String name;
  final List<Widget> listview;
  final VoidCallback? delete;
  final VoidCallback? copy;
  final VoidCallback? edit;
  final VoidCallback? add;
  final VoidCallback? view;
  final VoidCallback? remove;
  final VoidCallback? upload;
  PlanMakerPopUp(
      {required this.name,
      required this.listview,
      this.delete,
      this.copy,
      this.edit,
      this.view,
      this.add,
      this.remove,
      this.upload});
  @override
  Widget build(BuildContext context) {
    var myGroup = AutoSizeGroup();
    //Shows Preview for any content within the launch screens and selection screens of the plan maker.
    return Container(
      color: Theme.of(context).shadowColor,
      width: 100.0,
      height: 100.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("$name", style: Theme.of(context).textTheme.headline6),
          ),
          Expanded(
            child: Column(
              children: listview,
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: delete != null ? 1 : 0,
                  child: delete != null
                      ? QueryButton(
                          onTap: delete,
                          icon: Column(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              AutoSizeText(
                                "Delete",
                                group: myGroup,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                maxFontSize: 11.0,
                                minFontSize: 3.0,
                              )
                            ],
                          ),
                        )
                      : Container(
                          height: 0.0,
                          width: 0.0,
                        )),
              Expanded(
                flex: copy != null ? 1 : 0,
                child: copy != null
                    ? QueryButton(
                        onTap: copy,
                        icon: Column(
                          children: [
                            Icon(Icons.copy, color: Colors.blue),
                            AutoSizeText(
                              "Copy",
                              group: myGroup,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              maxFontSize: 11.0,
                              minFontSize: 3.0,
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      ),
              ),
              Expanded(
                flex: edit != null ? 1 : 0,
                child: edit != null
                    ? QueryButton(
                        onTap: edit,
                        icon: Column(
                          children: [
                            Icon(Icons.edit, color: Colors.yellow),
                            AutoSizeText(
                              "Edit",
                              group: myGroup,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              maxFontSize: 11.0,
                              minFontSize: 3.0,
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      ),
              ),
              Expanded(
                flex: view != null ? 1 : 0,
                child: view != null
                    ? QueryButton(
                        onTap: view,
                        icon: Column(
                          children: [
                            Icon(Icons.remove_red_eye, color: Colors.white),
                            AutoSizeText(
                              "View",
                              group: myGroup,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              maxFontSize: 11.0,
                              minFontSize: 3.0,
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      ),
              ),
              Expanded(
                flex: add != null ? 1 : 0,
                child: add != null
                    ? QueryButton(
                        onTap: add,
                        icon: Column(
                          children: [
                            Icon(Icons.add, color: Colors.blueGrey),
                            AutoSizeText(
                              "Add",
                              group: myGroup,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              maxFontSize: 11.0,
                              minFontSize: 3.0,
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      ),
              ),
              Expanded(
                flex: remove != null ? 1 : 0,
                child: remove != null
                    ? QueryButton(
                        onTap: remove,
                        icon: Column(
                          children: [
                            Icon(Icons.remove, color: Colors.yellow),
                            AutoSizeText(
                              "Remove",
                              group: myGroup,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              maxFontSize: 11.0,
                              minFontSize: 3.0,
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      ),
              ),
              Expanded(
                flex: upload != null ? 1 : 0,
                child: upload != null
                    ? QueryButton(
                        onTap: remove,
                        icon: Column(
                          children: [
                            Icon(Icons.upload, color: Colors.green),
                            AutoSizeText(
                              "Upload Plan",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              maxFontSize: 11.0,
                              minFontSize: 3.0,
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      ),
              ),
              Expanded(
                flex: 1,
                child: QueryButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  icon: Column(
                    children: [
                      Icon(Icons.clear_outlined, color: Colors.red),
                      AutoSizeText(
                        "Cancel",
                        group: myGroup,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        maxFontSize: 11.0,
                        minFontSize: 3.0,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
