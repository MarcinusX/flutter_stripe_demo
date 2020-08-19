import 'package:flutter/material.dart';
import 'package:flutter_stripe_demo/checkout_page.dart';
import 'package:flutter_stripe_demo/server_stub.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stripe Checkout Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: RaisedButton(
            onPressed: () async {
              final sessionId = await Server().createCheckout();
              final result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CheckoutPage(
                  sessionId: sessionId,
                ),
              ));
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Result: $result'),
                ),
              );
            },
            child: Text('Pay!'),
            color: Colors.blue,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
