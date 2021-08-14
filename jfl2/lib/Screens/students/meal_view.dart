import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/plans_meals.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/nutrition_field.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/day_meal_data.dart';
import 'package:provider/provider.dart';

class mealView extends StatefulWidget {
  static String id = "mealView";
  final String? name;
  final double? kCalPerServ;
  final double? satFat;
  final double? tranFat;
  final double? cholesteral;
  final double? sodium;
  final double? totalCarbs;
  final double? dietFiber;
  final double? totalSugar;
  final double? protien;
  mealView(
      {@required this.name,
      @required this.kCalPerServ,
      @required this.satFat,
      @required this.tranFat,
      @required this.cholesteral,
      @required this.sodium,
      @required this.totalCarbs,
      @required this.dietFiber,
      @required this.totalSugar,
      @required this.protien});
  @override
  _mealViewState createState() => _mealViewState();
}

class _mealViewState extends State<mealView> {
  TextEditingController name = new TextEditingController();
  TextEditingController calories = new TextEditingController();
  TextEditingController servings = new TextEditingController();
  TextEditingController satFat = new TextEditingController();
  TextEditingController transFat = new TextEditingController();
  TextEditingController cholestral = new TextEditingController();
  TextEditingController sodium = new TextEditingController();
  TextEditingController dietFiber = new TextEditingController();
  TextEditingController totalSugar = new TextEditingController();
  TextEditingController totalCarbs = new TextEditingController();
  TextEditingController protien = new TextEditingController();
  @override
  void initState() {
    calories.text = widget.kCalPerServ.toString();
    name.text = widget.name.toString();
    servings.text = "0";
    satFat.text = widget.satFat.toString();
    transFat.text = widget.tranFat.toString();
    cholestral.text = widget.cholesteral.toString();
    sodium.text = widget.sodium.toString();
    dietFiber.text = widget.dietFiber.toString();
    totalSugar.text = widget.totalSugar.toString();
    totalCarbs.text = widget.totalCarbs.toString();
    protien.text = widget.protien.toString();
    super.initState();
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
        actions: <Widget>[],
        title: Text('Meal Breakdown'),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Name:"),
                    ),
                    Expanded(
                      child: CustomTextBox(
                        controller: name,
                        active: true,
                        labelText: 'Name',
                        onChanged: (text) {},
                      ),
                    ),
                  ],
                ),
              ),
              NutritionField(
                  name: "Servings",
                  controller: servings,
                  onChanged: (value) {},
                  active: true),
              Text(
                "Nutrition Values (for 1 servings)",
                style: Theme.of(context).textTheme.headline6,
              ),
              NutritionField(
                  name: "Calories",
                  controller: calories,
                  onChanged: (value) {},
                  active: true),
              NutritionField(
                  name: "Saturated Fat",
                  controller: satFat,
                  onChanged: (value) {},
                  active: true),
              NutritionField(
                  name: "Trans Fat",
                  controller: satFat,
                  onChanged: (value) {},
                  active: true),
              NutritionField(
                  name: "Cholesterol",
                  controller: cholestral,
                  onChanged: (value) {},
                  active: true),
              NutritionField(
                  name: "Sodium",
                  controller: sodium,
                  onChanged: (value) {},
                  active: true),
              NutritionField(
                  name: "Total Carbohydrates",
                  controller: sodium,
                  onChanged: (value) {},
                  active: true),
              NutritionField(
                  name: "Dietary Fibers",
                  controller: dietFiber,
                  onChanged: (value) {},
                  active: true),
              NutritionField(
                  name: "Total Sugars",
                  controller: totalSugar,
                  onChanged: (value) {},
                  active: true),
              NutritionField(
                  name: "Protein",
                  controller: protien,
                  onChanged: (value) {},
                  active: true),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: FooterButton(
            action: () {
              meal mealData = new meal(
                  name: name.text,
                  calories: double.tryParse(calories.text) as double,
                  cholesteral: double.tryParse(cholestral.text) as double,
                  dietFiber: double.tryParse(dietFiber.text) as double,
                  protien: double.tryParse(protien.text) as double,
                  satFat: double.tryParse(satFat.text) as double,
                  sodium: double.tryParse(sodium.text) as double,
                  totalCarbs: double.tryParse(totalCarbs.text) as double,
                  totalSugar: double.tryParse(totalSugar.text) as double,
                  tranFat: double.tryParse(transFat.text) as double);
              Provider.of<dayMeals>(context, listen: false).pushMeal(mealData);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            text: Text("Submit Meal",
                style: Theme.of(context).textTheme.headline6),
            color: Colors.green),
      ),
    );
  }
}
