import 'package:flutter/material.dart';

class PaymentPortal extends StatefulWidget {
  static String id = "PaymentPortal";

  _PaymentPortal createState() => _PaymentPortal();
}

class _PaymentPortal extends State<PaymentPortal> {
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
        title: Text('Payment'),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/jf_5.jpg"),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.matrix(<double>[
                0.2126, 0.400, 0.0100, 0, -55,
                0.2126, 0.400, 0.0100, 0, -55,
                0.2126, 0.400, 0.0100, 0, -55,
                0, 0, 0, 1, 0,
              ]),
            ),
          ),
          child: ListView(
          children: [
          Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
      child: Column(
        children: [

        ],
      ),
    )],
    )
    ,
    )
    ,
    );
  }
}