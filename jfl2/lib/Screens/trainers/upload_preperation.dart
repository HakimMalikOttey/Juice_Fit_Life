import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jfl2/components/dialog_typer.dart';
import 'package:jfl2/components/footer_button.dart';
import 'package:jfl2/components/sign_up_fields.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:jfl2/components/upload_choices.dart';

class UploadPreperation extends StatefulWidget {
  static String id = "UploadPreperation";
  final String? banner;
  final String? title;
  final String? author;
  final String? hook;
  UploadPreperation({this.banner, this.title, this.author, this.hook});
  @override
  _UploadPreperationState createState() => _UploadPreperationState();
}

class _UploadPreperationState extends State<UploadPreperation> {
  TextEditingController initialPrice = new TextEditingController();
  TextEditingController constantPrice = new TextEditingController();
  String symbol = 'USD ';
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
        title: Text('Plan Upload'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                Container(
                    height: 180.0,
                    width: MediaQuery.of(context).size.width,
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/no_pic.png",
                      image: widget.banner as String,
                      fit: BoxFit.fitWidth,
                    )),
                Container(
                  color: Theme.of(context).cardColor,
                  height: 140.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${widget.title}",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("by ${widget.author}",
                                style: Theme.of(context).textTheme.headline1),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text("${widget.hook}",
                            style: Theme.of(context).textTheme.headline1),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 20.0,
                          child: Row(
                            children: [
                              Text("${initialPrice.text} to start!",
                                  style: Theme.of(context).textTheme.headline1),
                              VerticalDivider(
                                thickness: 1.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.point_of_sale,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text("0",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => DialogTyper(
                        keyboard: TextInputType.number,
                        formatters: [
                          CurrencyTextInputFormatter(symbol: symbol)
                        ],
                        controller: initialPrice,
                        hint: "Initial Cost",
                        changed: (text) {}));
              },
              child: CustomTextBox(
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyTextInputFormatter()],
                controller: initialPrice,
                active: false,
                hintText: "Initial Cost",
                onChanged: (text) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => DialogTyper(
                        keyboard: TextInputType.number,
                        formatters: [
                          CurrencyTextInputFormatter(symbol: symbol)
                        ],
                        controller: constantPrice,
                        hint: "Constant Cost",
                        changed: (text) {
                          setState(() {});
                        }));
              },
              child: CustomTextBox(
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyTextInputFormatter()],
                controller: constantPrice,
                active: false,
                hintText: "Constant Cost",
                onChanged: (text) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
                child: initialPrice.text.trim() != "" &&
                        constantPrice.text.trim() != ""
                    ? FooterButton(
                        text: Text("Push",
                            style: Theme.of(context).textTheme.headline6),
                        color: Colors.green,
                        action: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => UploadChoices());
                        },
                      )
                    : FooterButton(
                        text: Text("Push",
                            style: Theme.of(context).textTheme.headline6),
                        color: Colors.grey,
                        // action: (){
                        //   showModalBottomSheet(
                        //       context: context,
                        //       builder: (context)=>UploadChoices());
                        // },
                      ))
          ],
        ),
      ),
    );
  }
}
