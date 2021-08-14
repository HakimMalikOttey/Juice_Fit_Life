import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/data/meal_plan_maker_data.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

import 'custom_alert_box.dart';
import 'loading_dialog.dart';

class MealCopy extends StatelessWidget {
  final List mealIds;
  MealCopy({required this.mealIds});
  @override
  Widget build(BuildContext context) {
    return LoadingDialog(
      future: Provider.of<MealPlanMakerData>(context, listen: false)
          .copyMeal(Provider.of<UserData>(context).id as String, {'mealIDs': mealIds}),
      errorRoutine: (data) {
        return CustomAlertBox(
          infolist: <Widget>[
            Text("There was an error copying your meal. Try again later.")
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
        return CustomAlertBox(
          infolist: <Widget>[
            Text("There was a major error copying your meal. Try again later.")
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
      successRoutine: (data) {
        return CustomAlertBox(
          infolist: <Widget>[Text("Meal has been successfully copied!")],
          actionlist: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
                onPressed: () {
                  Provider.of<UserData>(context, listen: false)
                      .QueryIds
                      .value
                      .clear();
                  Provider.of<UserData>(context, listen: false).queryReload =
                      true;
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    Navigator.pop(context);
                  });
                  Navigator.pop(context);
                },
                child: Text("Ok"))
          ],
        );
      },
    );
  }
}
