import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/filter.dart';
import 'package:jfl2/components/plan_container_mini.dart';
import 'package:jfl2/components/show_dialog_dismiss.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/secret.dart';
import 'package:jfl2/data/secret_loader.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class PlansShop extends StatefulWidget {
  static String id = "PlansShop";
  @override
  _PlansShopState createState() => _PlansShopState();
}

class _PlansShopState extends State<PlansShop> {
  String text = 'Click the button to start the payment';
  double totalCost = 10.0;
  double tip = 1.0;
  double tax = 0.0;
  double taxPercent = 0.2;
  int amount = 0;
  bool showSpinner = false;
  String url =
      'https://us-central1-demostripe-b9557.cloudfunctions.net/StripePI';
  void checkIfNativePayReady() async {
    print("started to check if native pay ready");
    bool deviceSupportNativePay = await StripePayment.deviceSupportsNativePay() as bool;
    bool isNativeReady = await StripePayment.canMakeNativePayPayments(
        ['american_express', 'visa', 'maestro', 'master_card']) as bool;
    deviceSupportNativePay && isNativeReady
        ? createPaymentMethodNative()
        : createPaymentMethod();
  }

  Future<void> createPaymentMethodNative() async {
    print('started NATIVE payment...');
    StripePayment.setStripeAccount("");
    //This is for apple. This has not been implemented yet because we dont have an apple developers ID
    //Once we get an ID, please implement apple payment
    List<ApplePayItem> items = [];
    PaymentMethod paymentMethod = PaymentMethod();
    Token token = await StripePayment.paymentRequestWithNativePay(
        androidPayOptions: AndroidPayPaymentRequest(
            currencyCode: 'GBP',
            totalPrice: (totalCost + tax + tip).toStringAsFixed(2)), applePayOptions: ApplePayPaymentOptions());
    paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: CreditCard(token: token.tokenId)));
    // paymentMethod != null ? processPaymentAsDirectCharge()
  }

  Future<void> createPaymentMethod() async {
    StripePayment.setStripeAccount("");
    tax = ((totalCost * taxPercent) * 100).ceil() / 100;
    amount = ((totalCost + tip + tax) * 100).toInt();
    print("amount in pence/cent which will be charged = $amount");
    PaymentMethod paymentMethod = PaymentMethod();
    paymentMethod =
        await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
            .then((PaymentMethod paymentMethod) {
      return paymentMethod;
    }).catchError((e) {
      print("Error Card: ${e.toString()}");
    });
    paymentMethod != null
        ? processPaymentAsDirectCharge(paymentMethod)
        : showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: 'Error',
                content:
                    'It is not possible to pay with this card. Please try again with a different card',
                buttonText: 'CLOSE'));
  }

  Future<void> processPaymentAsDirectCharge(PaymentMethod paymentMethod) async {
    setState(() {
      showSpinner = true;
    });
    //step 2: request to create PaymentIntent, attempt to confirm the payment & return PaymentIntent
    final http.Response response = await http.post(
        Uri.parse('$url?amount=$amount&currency=GBP&paym=${paymentMethod.id}'));
    print('Now i decode');
    if (response.body != null && response.body != 'error') {
      final paymentIntentX = jsonDecode(response.body);
      final status = paymentIntentX['paymentIntent']['status'];
      final strAccount = paymentIntentX['stripeAccount'];
      //step 3: check if payment was succesfully confirmed
      if (status == 'succeeded') {
        //payment was confirmed by the server without need for futher authentification
        StripePayment.completeNativePayRequest();
        setState(() {
          text =
              'Payment completed. ${paymentIntentX['paymentIntent']['amount'].toString()}p succesfully charged';
          showSpinner = false;
        });
      } else {
        //step 4: there is a need to authenticate
        StripePayment.setStripeAccount(strAccount);
        await StripePayment.confirmPaymentIntent(PaymentIntent(
                paymentMethodId: paymentIntentX['paymentIntent']
                    ['payment_method'],
                clientSecret: paymentIntentX['paymentIntent']['client_secret']))
            .then(
          (PaymentIntentResult paymentIntentResult) async {
            //This code will be executed if the authentication is successful
            //step 5: request the server to confirm the payment with
            final statusFinal = paymentIntentResult.status;
            if (statusFinal == 'succeeded') {
              StripePayment.completeNativePayRequest();
              setState(() {
                showSpinner = false;
              });
            } else if (statusFinal == 'processing') {
              StripePayment.cancelNativePayRequest();
              setState(() {
                showSpinner = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => ShowDialogToDismiss(
                      title: 'Warning',
                      content:
                          'The payment is still in \'processing\' state. This is unusual. Please contact us',
                      buttonText: 'CLOSE'));
            } else {
              StripePayment.cancelNativePayRequest();
              setState(() {
                showSpinner = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => ShowDialogToDismiss(
                      title: 'Error',
                      content:
                          'There was an error to confirm the payment. Details: $statusFinal',
                      buttonText: 'CLOSE'));
            }
          },
          //If Authentication fails, a PlatformException will be raised which can be handled here
        ).catchError((e) {
          //case B1
          StripePayment.cancelNativePayRequest();
          setState(() {
            showSpinner = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) => ShowDialogToDismiss(
                  title: 'Error',
                  content:
                      'There was an error to confirm the payment. Please try again with another card',
                  buttonText: 'CLOSE'));
        });
      }
    } else {
      //case A
      StripePayment.cancelNativePayRequest();
      setState(() {
        showSpinner = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
              title: 'Error',
              content:
                  'There was an error in creating the payment. Please try again with another card',
              buttonText: 'CLOSE'));
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPersistentFrameCallback((timeStamp) async {
      Secret pkJson = await SecretLoader(secretPath: "secrets.json").load();
      final pk = pkJson.pk;
      StripePayment.setOptions(
          StripeOptions(publishableKey: pk, androidPayMode: 'test'));
    });
    // final pk =
    //     'pk_live_51JIlAPJXK3SoJwpWT8uDgv7J1895eNZ2kLdcvl0FGHCih37R2qtY7WNDlGZW449URDB8O5z9qW8nNzvHTh18MSwP001HiOsxw2';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController search = new TextEditingController();
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SafeArea(
          child: Center(
            child: ListView(
              children: [
                CustomTextBox(
                  show: true,
                  controller: search,
                  hintText: "Search...",
                  onChanged: (text) {
                    // data.password = text;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Plans Right For You",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: 170,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          PlanContainerMini(
                            ontap: () {
                              createPaymentMethod();
                            },
                          ),
                          PlanContainerMini(
                            ontap: () {
                              createPaymentMethod();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Most Popular Plans",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: 170,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          PlanContainerMini(
                            ontap: () {
                              createPaymentMethod();
                            },
                          ),
                          PlanContainerMini(
                            ontap: () {
                              createPaymentMethod();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Recently Uploaded Plans",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: 170,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          PlanContainerMini(
                            ontap: () {
                              createPaymentMethod();
                            },
                          ),
                          PlanContainerMini(
                            ontap: () {
                              createPaymentMethod();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "All Plans",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
