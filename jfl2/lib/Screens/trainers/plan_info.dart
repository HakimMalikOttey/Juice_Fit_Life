import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/students/payment_portal.dart';
import 'package:jfl2/components/AnimatedBackground.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/components/plan_cell.dart';

import '../../components/custom_alert_box.dart';
class PlanInfo extends StatefulWidget{
  static String id = "PlanInfo";
  final String? name;
  final String? author;
  final String? intropar;
  final String? authorinfo;
  final comments;
  final authpic;
  PlanInfo({this.name,this.author,this.intropar,this.authorinfo,this.comments,this.authpic});
  // PlanInfo({Key key, @required this.data}):super(key:key);
  _PlanInfo createState() => _PlanInfo();
}

class _PlanInfo  extends State<PlanInfo>{
  @override
  Widget build(BuildContext context) {
    // final test = ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    print(widget.name);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[],
        title: Text('Plans Information'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image:DecorationImage(
            image: AssetImage("assets/jf_3.jpg"),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.matrix(<double>[
              0.2126, 0.400, 0.0100, 0, -55,
              0.2126, 0.400, 0.0100, 0, -55,
              0.2126, 0.400, 0.0100, 0, -55,
              0, 0, 0, 1, 0,
            ]),
          ),
        ),
        child: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Get Big",style: Theme.of(context).textTheme.headline3),
                            SizedBox(
                              width: 20.0,
                            ),
                            SquareButton(
                              color: Colors.green,
                              pressed: () {
                                var paymentmethod = CustomAlertBox(
                                  infolist: <Widget>[
                                    Text("Summary:",style: Theme.of(context).textTheme.headline3,),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Text("Today's Charge:",style: Theme.of(context).textTheme.headline6,),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: [
                                        Text("USD"),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text("\$200",style: TextStyle(decoration: TextDecoration.lineThrough),),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text("\$0"),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text("(Free for 30 days)")
                                      ],
                                    ),
                                    Divider(),
                                    Text("Charge every 30 days:",style: Theme.of(context).textTheme.headline6),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text("USD \$200"),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text("This charge renews every 30 days. You can change payment method or cancel your subscription in the plans settings menu.",style: TextStyle(fontSize: 13.0),),
                                    // SquareButton(
                                    //   butContent: Text("Purchase Plan",style: Theme.of(context).textTheme.headline2,),
                                    //   buttonwidth: 100.0,
                                    //   color:Colors.white,
                                    //   pressed: _pay,
                                    // )
                                  ],
                                );
                                showDialog(context: context, builder: (context) => paymentmethod);
                              },
                              butContent: Text('Purchase',
                                  style: TextStyle(
                                      color: Colors.white)),
                              buttonwidth: 130.0,
                              height: 20.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text("by Hakim Ottey",style: Theme.of(context).textTheme.headline1),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                child: Container(
                                  height: 170.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/PlanPlaceholderImage.jpg"),
                                      fit: BoxFit.fill
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("",style: TextStyle(fontSize: 15),),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text("Workout Examples",style: Theme.of(context).textTheme.headline6),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                                child: Divider()
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        PlanCell(title: "Monday", content:Text("Excercise 1,Excercise 2...")),
                        SizedBox(
                          height: 20.0,
                        ),
                        PlanCell(title: "Tuesday", content:Text("Excercise 1,Excercise 2...")),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text("About the Author",style: Theme.of(context).textTheme.headline6),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                                child: Divider(
                                )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text("Registered since january 1st,2021", style: Theme.of(context).textTheme.headline1),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/PlanPlaceholderImage.jpg"),
                                      ),
                                      color: Colors.black
                                  ),
                                  width: 150.0,
                                  height: 150.0,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text("Hakim Ottey",style:Theme.of(context).textTheme.headline3 )
                              ],
                            ),
                            SizedBox(
                              width: 7.0,
                            ),
                            Expanded(
                              child: Text("",),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
      ),

    );
  }
}