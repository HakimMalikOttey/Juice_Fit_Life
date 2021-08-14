import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

class PlanSegmentCell extends StatelessWidget {
  final Text name;
  final String id;
  //When Batch Operation is running
  final VoidCallback? onLongPressActive;
  final VoidCallback? onTapActive;
  //When Batch Operation is not running
  final VoidCallback? onLongPressInactive;
  final VoidCallback? onTapInactive;
  final added;
  PlanSegmentCell(
      {required this.name,
      required this.id,
      required this.onLongPressActive,
      required this.onTapActive,
      required this.onLongPressInactive,
      required this.onTapInactive,
      this.added});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Provider.of<UserData>(context).BatchOperation,
        builder: (context, data, child) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.grey[850]?.withOpacity(0.3),
                    onLongPress: data == false ? onLongPressInactive : null,
                    onTap: data == false ? onTapInactive : onTapActive,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: name),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: added != true
                                  ? Container(
                                      child: data == true
                                          ? Container(
                                              child: Provider.of<UserData>(
                                                          context,
                                                          listen: false)
                                                      .QueryIds
                                                      .value
                                                      .contains("$id")
                                                  ? Icon(
                                                      Icons.check_box_outlined,
                                                      color: Colors.white)
                                                  : Icon(
                                                      Icons
                                                          .check_box_outline_blank,
                                                      color: Colors.white,
                                                    ))
                                          : Container(),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
