import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:intl/intl.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MenuFutureBuilder extends StatefulWidget {
  final int? daysindex;
  final Future? future;
  final dropdownValue;
  final TextEditingController? searchController;
  final bool? mainMenu;
  final RefreshController? refreshController;
  final VoidCallback? onrefresh;
  final double? height;
  final Function(AsyncSnapshot<dynamic> data)? failedRoutine;
  final Widget Function(dynamic, BuildContext, bool, int, FutureOr<dynamic> Function(Object?))? spawner;
  final Function(Object data)? errorRoutine;
  MenuFutureBuilder({
    @required this.future,
    @required this.dropdownValue,
    @required this.searchController,
    @required this.spawner,
    @required this.mainMenu,
    @required this.failedRoutine,
    @required this.errorRoutine,
    this.daysindex,
    this.refreshController,
    this.onrefresh,
    this.height,
  });

  @override
  _MenuFutureBuilderState createState() => _MenuFutureBuilderState();
}

class _MenuFutureBuilderState extends State<MenuFutureBuilder> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    FutureOr onGoBack(dynamic value) {
      setState(() {
        widget.onrefresh!();
      });
    }

    return Container(
      height: widget.height,
      child: SmartRefresher(
        controller: widget.refreshController as RefreshController,
        onRefresh: widget.onrefresh,
        child: FutureBuilder(
            future: widget.future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data == "") {
                    return widget.failedRoutine!(snapshot);
                  } else {
                    List decoded = json.decode(snapshot.data as String);
                    // print(decoded);
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: decoded.length,
                        itemBuilder: (context, index) {
                          return widget.spawner!(decoded[index], context,
                              widget.mainMenu!, widget.daysindex ?? 0 , onGoBack);
                          // if (decoded[index]["name"]
                          //     .contains(widget.searchController.text)) {
                          //   return widget.spawner(decoded[index], context,
                          //       widget.mainMenu, widget.daysindex,onGoBack);
                          // } else {
                          //   return Container();
                          // }
                        });
                  }
                } else if (snapshot.hasError) {
                  return widget.errorRoutine!(snapshot.error as Object);
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
