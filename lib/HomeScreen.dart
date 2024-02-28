import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_pay/upi_pay.dart';

class Home_Screen extends StatefulWidget {
  final String title;

  const Home_Screen({Key? key, required this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home_Screen> {
  String resultText = "";
  String selectedUpiApp = "Google Pay"; // Replace with user's default app
  String defaultapp = "";
  Future<String>? _defaultUpiApp;
  UpiTransactionResponse? response;

  @override
  void initState() {
    super.initState();
    _requestMicPermission();
    _getDefaultUpiApp();
  }

  Future<void> _requestMicPermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Handle permission denial or show appropriate message
    }
  }

  Future<void> _getDefaultUpiApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    defaultapp = prefs.getString("upiapp") ?? "";
    if (defaultapp.isNotEmpty) {
      selectedUpiApp = defaultapp;
    } else {
      _defaultUpiApp = UpiPay.getInstalledUpiApplications().then((apps) {
        if (apps.isNotEmpty) {
          return apps[0].packageName; // Choose first available app by default
        } else {
          return ""; // No UPI apps found
        }
      });
    }
  }

  void _launchUpiPayment(String upiid, String amount, String username) async {
    try {
      final upiPayment = UpiPayment(
        app: selectedUpiApp,
        payeeAddress: upiid,
        payeeName: username,
        transactionRefId: '9e543J979m9',
        paymentNote: 'Paid with VoiceCoin',
        // currency: UpiCurrency.INR,
      );

      Future<UpiTransactionResponse> initiateTransaction;
      if (response?.status == UpiTransactionStatus.success) {
        // Handle successful payment
        print("Payment successful! Response: $response");
      } else {
        // Handle failure or user cancellation
        print("Payment failed or cancelled. Response: $response");
      }
    } catch (e) {
      // Handle errors gracefully
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Try Saying Pay to \ndo the payment",
                  style: TextStyle(color: Colors.redAccent, fontSize: 24),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Text(
                  "Select a UPI Application:",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                FutureBuilder<String>(
                  future: _defaultUpiApp,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      selectedUpiApp = snapshot.data ?? "";
                      return DropdownButton<String>(
                        hint: Text("Click to choose a UPI app"),
                        value: selectedUpiApp,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 34,
                        elevation: 100,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                          wordSpacing: 2,
                        ),
                        // underline: Container
                        underline: Container(
                          height: 3,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (newValue) => setState(() {
                          selectedUpiApp = newValue!;
                        }),
                        // onChanged: (String newValue) {
                        //   setState(() {
                        //     selectedUpiApp = newValue;
                        //   });
                        // },
                        items: <String>[
                          "Google Pay",
                          "Paytm",
                          "PhonePe",
                          "BHIM UPI",
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(80.0),
                ),
                FloatingActionButton(
                  heroTag: "fbot",
                  child: Icon(Icons.save),
                  onPressed: () => _launchUpiPayment("upiid@yourbank.com",
                      "100.00", "Merchant Name"), // Replace with actual values
                  backgroundColor: Colors.pink,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

UpiPayment(
    {required String app,
    required String payeeAddress,
    required String payeeName,
    required String transactionRefId,
    required String paymentNote}) {}
