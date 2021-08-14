import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/meal_view.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/loading_dialog.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/data/secret.dart';
import 'package:jfl2/data/secret_loader.dart';
import 'package:openfoodfacts/model/parameter/ContainsAdditives.dart';
import 'package:openfoodfacts/model/parameter/SearchTerms.dart';
import 'package:openfoodfacts/model/parameter/WithoutAdditives.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as openfoodfacts;
import 'package:openfoodfacts/utils/QueryType.dart';

class OpenFoodFactsLoad extends StatefulWidget {
  static String id = "OpenFoodFactsLoad";
  @override
  _OpenFoodFactsLoadState createState() => _OpenFoodFactsLoadState();
}

class _OpenFoodFactsLoadState extends State<OpenFoodFactsLoad> {
  late openfoodfacts.User testUser;
   openfoodfacts.SearchResult? results;
  TextEditingController search = new TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      Secret openfoodJson =
          await SecretLoader(secretPath: "secrets.json").load();
      testUser = openfoodfacts.User(
          userId: '${openfoodJson.offluserId}',
          password: '${openfoodJson.offpassword}',
          comment: 'Juice-Fit-Life API test');
    });
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
        title: Text('Select a Meal'),
      ),
      body: Column(
        children: [
          Container(
            height: 100.0,
            child: Filter(
              submitAction: () async {
                if (search.text.trim() != "") {
                  var parameters = <openfoodfacts.Parameter>[
                    const openfoodfacts.Page(page: 1),
                    const openfoodfacts.PageSize(size: 200),
                    const openfoodfacts.SortBy(
                        option: openfoodfacts.SortOption.PRODUCT_NAME),
                    SearchTerms(terms: ['${search.text}']),
                    const WithoutAdditives()
                  ];
                  openfoodfacts.ProductSearchQueryConfiguration configuration =
                      openfoodfacts.ProductSearchQueryConfiguration(
                          parametersList: parameters,
                          fields: [openfoodfacts.ProductField.ALL],
                          language:
                              openfoodfacts.OpenFoodFactsLanguage.ENGLISH);
                  showDialog(
                      context: context,
                      builder: (context) => LoadingDialog(
                          future:
                              openfoodfacts.OpenFoodAPIClient.searchProducts(
                                  testUser, configuration,
                                  queryType: QueryType.TEST),
                          successRoutine: (data) {
                            results = data.data;
                            return WidgetsBinding.instance
                                ?.addPostFrameCallback((timeStamp) {
                              setState(() {});
                              Navigator.pop(context);
                            });
                          },
                          failedRoutine: (data) {
                            return WidgetsBinding.instance
                                ?.addPostFrameCallback((timeStamp) {
                              setState(() {});
                              Navigator.pop(context);
                            });
                          },
                          errorRoutine: (data) {
                            return WidgetsBinding.instance
                                ?.addPostFrameCallback((timeStamp) {
                              setState(() {});
                              Navigator.pop(context);
                            });
                          }));
                }
              },
              value: null,
              show: false,
              searchController: search, queryAction: (Map<dynamic, dynamic>? data) {
            // setState(() {
            //   Provider.of<UserData>(context, listen: false).sort = newValue;
            //   Provider.of<UserData>(context, listen: false).searchAction();
            // });
            // _future
            //     .whenComplete(() => _refreshController.refreshCompleted());
            },

            ),
          ),
          //Will print out all gathered results from the openfoodfacts api and display them on screen.
          //Since we can only get 1 page at a time, this will basically only show page 1 of the OFF API Search
          Expanded(
            child: ListView.builder(
                itemCount: results != null ? results!.products!.length : 0,
                itemBuilder: (context, index) {
                  if (results!.products![index].nutriments!.energyServing ==
                          null ||
                      results!.products![index].productName == null ||
                      results!.products![index].productName!.isEmpty) {
                    return Container();
                  } else {
                    return ListTile(
                      title: Text(
                        "${results!.products![index].productName}",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      trailing: Text(
                          "${results!.products![index].nutriments!.energyServing} Calories"),
                      onTap: () {
                        Navigator.pushNamed(context, mealView.id, arguments: {
                          "name": results!.products![index].productName,
                          "kCal": results
                                  !.products![index].nutriments!.energyServing ??
                              0.0,
                          "cholesteral": results!.products![index].nutriments!
                                  .cholesterolServing ??
                              0.0,
                          "protien": results
                                  !.products![index].nutriments!.proteinsServing ??
                              0.0,
                          "sodium": results
                                  !.products![index].nutriments!.sodiumServing ??
                              0.0,
                          "tranFat": results
                                  !.products![index].nutriments!.transFatServing ??
                              0.0,
                          "totalCarbs": results!.products![index].nutriments
                                  !.carbohydratesServing ??
                              0.0,
                          "totalSugar": results
                                  !.products![index].nutriments!.sugarsServing ??
                              0.0,
                          "dietFiber":
                              results!.products![index].nutriments!.fiberServing ??
                                  0.0,
                          "satFat": results!.products![index].nutriments
                                  !.saturatedFatServing ??
                              0.0,
                        });
                      },
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
