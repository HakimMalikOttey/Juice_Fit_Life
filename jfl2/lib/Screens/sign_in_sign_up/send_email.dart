import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/Screens/sign_in_sign_up/reset_username.dart';
import 'package:jfl2/components/square_button.dart';
import 'package:jfl2/constants.dart';
import 'package:http/http.dart' as http;
import 'package:jfl2/main.dart';
class SendEmail extends StatefulWidget{
  static String id = "SendEmail";
  final url;
  final type;
  SendEmail({@required this.url,@required this.type});
  @override
  _SendEmail createState() => _SendEmail();
}

class _SendEmail extends State<SendEmail> {
  bool? sent;
  final TextEditingController testcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body:Container(
        decoration: BoxDecoration(
          image:DecorationImage(
            image: AssetImage("assets/jf_5.jpg"),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, -55,
              0.2126, 0.7152, 0.0722, 0, -55,
              0.2126, 0.7152, 0.0722, 0, -55,
              0, 0, 0, 1, 0,
            ]),
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.only(bottom: 2.0),
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
            child:Center(
              child: ListView(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 300.0,
                      ),
                      Container(
                          child: sent != true ? Text("Please type in your email. If we have a matching email on file, we will send you a ${widget.type} reset link.", style: Theme.of(context).textTheme.headline1):
                          Text("Check your email. If you don't receive it in 10 minutes, check if you typed in the right email and submit again.", style: Theme.of(context).textTheme.headline1)
                      ),
                      TextField(
                        controller: testcontroller,
                        onChanged: (String value) {
                          setState(() {

                          });
                        },
                        decoration: InputDecoration(
                            focusedBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white,
                                    width: 3.0)),
                            enabledBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white,
                                    width: 3.0)),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white)),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: testcontroller.text != "" ? SquareButton(
                          color:Colors.white,
                          pressed: ()async{
                            setState(() {
                              sent = true;
                            });
                            // Navigator.pushNamed(context, CodeInput.id);
                            final http.Response response = await http.post(
                                Uri.https('$link', "${widget.url}"),
                                headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                },
                                body: jsonEncode({
                                  "email": testcontroller.text,
                                }));
                            print("${response.body}");
                          },
                          butContent: Text('Submit', style: kFirstButton),
                          buttonwidth:150.0,
                        ):SizedBox(),
                      ),
                    ],
                  ),
                ],
              ),
            )
          )
        ),
      )
    );
  }
}