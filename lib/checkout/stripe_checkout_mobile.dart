import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe_demo/checkout/server_stub.dart';
import 'package:flutter_stripe_demo/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

void redirectToCheckout(BuildContext context) async {
  final sessionId = await Server().createCheckout();
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CheckoutPage(sessionId: sessionId),
  ));
}

class CheckoutPage extends StatefulWidget {
  final String sessionId;

  const CheckoutPage({Key key, this.sessionId}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (webViewController) =>
            _webViewController = webViewController,
        onPageFinished: (String url) {
          if (url == initialUrl) {
            _redirectToStripe(widget.sessionId);
          }
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('http://localhost:8080/#/success')) {
            Navigator.of(context).pushReplacementNamed('/success');
          } else if (request.url.startsWith('http://localhost:8080/#/cancel')) {
            Navigator.of(context).pushReplacementNamed('/cancel');
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  String get initialUrl =>
      'data:text/html;base64,${base64Encode(Utf8Encoder().convert(kStripeHtmlPage))}';

  Future<String> _redirectToStripe(String sessionId) async {
    final redirectToCheckoutJs = '''
var stripe = Stripe(\'$apiKey\');
    
stripe.redirectToCheckout({
  sessionId: '$sessionId'
}).then(function (result) {
  result.error.message = 'Error'
});
''';

    return await _webViewController.evaluateJavascript(redirectToCheckoutJs);
  }
}

const String kStripeHtmlPage = '''
<!DOCTYPE html>
<html>
<script src="https://js.stripe.com/v3/"></script>
<head><title>Stripe checkout</title></head>
<body>
Hello YouTube!!!
</body>
</html>
''';
