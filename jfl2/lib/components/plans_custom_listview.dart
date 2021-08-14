import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlansCustomListview extends StatefulWidget{
  final List<Widget> widgetList;
  PlansCustomListview({required this.widgetList});
  @override
  _PlansCustomListviewState createState() => _PlansCustomListviewState();
}

class _PlansCustomListviewState extends State<PlansCustomListview> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.widgetList,
          ),
        ],
      ),
    );
  }
}
// [
// Padding(
// padding: const EdgeInsets.only(top: 10.0),
// child: SquareButton(
// color: Colors.black,
// pressed: () {
// Navigator.of(context, rootNavigator: true)
//     .pushNamed(StretchEditor.id, arguments: {
// "stretchId": "",
// "name": "",
// "media": "",
// "type": 1
// });
// },
// butContent: Row(
// children: [
// Text(
// "Create A New Stretch",
// style: Theme.of(context).textTheme.headline1,
// ),
// SizedBox(
// width: 10.0,
// ),
// Icon(Icons.add_circle_outline_outlined)
// ],
// ),
// buttonwidth: MediaQuery.of(context).size.width),
// ),
// FutureBuilder(
// future: Provider.of<StretchMakerData>(context)
// .getstretches(Provider.of<TrainerSignUpData>(context)
// .trainerData
//     .data["_id"]),
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.done) {
// if (snapshot.hasData) {
// List decoded = json.decode(snapshot.data);
// if (dropdownValue == filters[0]) {
// decoded.sort((a, b) => (a["name"].toLowerCase())
//     .compareTo(b["name"].toLowerCase()));
// } else if (dropdownValue == filters[1]) {
// decoded.sort((a, b) => (b["name"].toLowerCase())
//     .compareTo(a["name"].toLowerCase()));
// } else if (dropdownValue == filters[2]) {
// decoded.sort((a, b) =>
// (DateFormat(a["date"]).format(DateTime.now()))
//     .compareTo(DateFormat(b["date"])
//     .format(DateTime.now())));
// } else if (dropdownValue == filters[3]) {
// decoded.sort((a, b) =>
// (DateFormat(b["date"]).format(DateTime.now()))
//     .compareTo(DateFormat(a["date"])
//     .format(DateTime.now())));
// }
// return ListView.builder(
// shrinkWrap: true,
// physics: ScrollPhysics(),
// itemCount: decoded.length,
// itemBuilder: (context, index) {
// if (decoded[index]["name"]
//     .contains(search.text)) {
// return WorkoutExampleCell(
// DBactions: Padding(
// padding: const EdgeInsets.only(
// right: 10.0),
// child: ActionButtons(
// copy: () {
// var result = CustomAlertBox(
// infolist: <Widget>[
// Text(
// "Do you want to copy this workout: ${decoded[index]["name"]}")
// ],
// actionlist: <Widget>[
// TextButton(
// child: Text(
// "Yes",
// style:
// Theme.of(context)
//     .textTheme
//     .headline1,
// ),
// onPressed: () {
// Navigator.of(context,
// rootNavigator:
// true)
//     .pop(true);
// var copy =
// FutureBuilder(
// future: Provider.of<
// StretchMakerData>(
// context,
// listen:
// false)
//     .createstrecth(
// "${Provider.of<TrainerSignUpData>(context, listen: false).trainerData.data["_id"]}",
// {
// "name": decoded[index]
// [
// "name"],
// "media":
// decoded[index]["media"],
// "date":
// DateTime.now().toString(),
// }),
// builder: (context,
// snapshot) {
// if (snapshot
//     .connectionState ==
// ConnectionState
//     .done) {
// if (snapshot
//     .hasData) {
// if (snapshot.data ==
// true) {
// return CustomAlertBox(
// infolist: <Widget>[
// Text("Workout has been copied.")
// ],
// actionlist: <Widget>[
// TextButton(
// child: Text(
// "Ok",
// style: Theme.of(context).textTheme.headline1,
// ),
// onPressed: () {
// Navigator.of(context, rootNavigator: true).pop(true);
// },
// ),
// ],
// );
// } else {
// return CustomAlertBox(
// infolist: <Widget>[
// Text("There was an error copying this workout. Please try again later.")
// ],
// actionlist: <Widget>[
// TextButton(
// child: Text(
// "Ok",
// style: Theme.of(context).textTheme.headline1,
// ),
// onPressed: () {
// Navigator.of(context, rootNavigator: true).pop(true);
// },
// ),
// ],
// );
// }
// } else {
// return LoadingIndicator();
// }
// } else {
// return LoadingIndicator();
// }
// });
// showDialog(
// barrierDismissible:
// false,
// context: context,
// builder:
// (context) =>
// copy);
// },
// ),
// TextButton(
// child: Text(
// "No",
// style:
// Theme.of(context)
//     .textTheme
//     .headline1,
// ),
// onPressed: () {
// Navigator.of(context,
// rootNavigator:
// true)
//     .pop(true);
// },
// ),
// ]);
// showDialog(
// context: context,
// builder: (context) =>
// result);
// },
// delete: () {},
// edit: () {
// Navigator.of(context,
// rootNavigator: true)
//     .pushNamed(StretchEditor.id,
// arguments: {
// "stretchId":
// decoded[index]["_id"],
// "name": decoded[index]
// ["name"],
// "media": decoded[index]
// ["media"],
// "type": 0
// });
// },
// )),
// path: decoded[index]["media"],
// sets: null,
// workoutname: decoded[index]["name"],
// action: () {});
// } else {
// return Container();
// }
// });
// } else {
// return Container();
// }
// } else {
// return Container();
// }
// }),
// SizedBox(
// height: 20.0,
// ),
// ],