import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/trainers/workout_editor_launch.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

class MiniPlanView extends StatefulWidget {
  final Widget dataWindow;
  final String windowName;
  MiniPlanView({required this.dataWindow, required this.windowName});
  @override
  _MiniPlanViewState createState() => _MiniPlanViewState();
}

class _MiniPlanViewState extends State<MiniPlanView> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Provider.of<UserData>(context, listen: false).search.clear();
            Provider.of<UserData>(context, listen: false).sort = filters[0];
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[],
        title: Text('${widget.windowName}'),
      ),
      body: WillPopScope(
        onWillPop: () {
          Provider.of<UserData>(context, listen: false).search.clear();
          Provider.of<UserData>(context, listen: false).sort = filters[0];
          Navigator.pop(context);
          return Future.value();
        },
        child: Column(
          children: [
            Container(
              height: 100.0,
              child: Filter(
                submitAction: Provider.of<UserData>(context, listen: false)
                    .miniSearchAction,
                value: Provider.of<UserData>(context, listen: false).sort,
                show: false,
                searchController: Provider.of<UserData>(context).search,
                queryAction: (Map<dynamic, dynamic>? data) {
              setState(() {
              Provider.of<UserData>(context, listen: false).sort =
              data as Map<String,dynamic>;
              Provider.of<UserData>(context, listen: false)
                  .miniSearchAction!();
              });
              // _future
              //     .whenComplete(() => _refreshController.refreshCompleted());

              },
              ),
            ),
            Expanded(
              child: widget.dataWindow,
            ),
          ],
        ),
      ),
    );
  }
}
