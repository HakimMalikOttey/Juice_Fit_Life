import 'package:flutter/cupertino.dart';
import 'package:jfl2/components/spawn_meal.dart';
import 'package:jfl2/components/menu_future_builder.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/trainer_sign_up_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'filter.dart';

class MealList extends StatefulWidget {
  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  TextEditingController search = new TextEditingController();
  String dropdownValue = 'Earliest';
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  late Future _future;
  void setFuture() {
    _future = Provider.of<MealPlanMakerData>(context, listen: false).getMeal(
        Provider.of<TrainerSignUpData>(context, listen: false)
            .trainerData
            .data["_id"],
        {});
  }

  @override
  void initState() {
    setFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        height: 400.0,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: MenuFutureBuilder(
                refreshController: _refreshController,
                onrefresh: () {
                  setState(() {
                    setFuture();
                  });
                  _future.whenComplete(
                      () => _refreshController.refreshCompleted());
                },
                height: 320.0,
                future: _future,
                dropdownValue: dropdownValue,
                searchController: search,
                mainMenu: false,
                spawner: spawnmeal, errorRoutine: (Object data) {  }, failedRoutine: (AsyncSnapshot<dynamic> data) {  },
              ),
            ),
            Positioned(
              top: 0,
              child: Filter(
                searchController: search,
                queryAction: (text) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
