import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe_demo/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutPage extends StatefulWidget {
  final String sessionId;

  const CheckoutPage({Key key, this.sessionId}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) => _controller = controller,
        onPageFinished: (String url) {
          if (url == initialUrl) {
            _redirectToStripe();
          }
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://success.com')) {
            Navigator.of(context).pop('success');
          } else if (request.url.startsWith('https://cancel.com')) {
            Navigator.of(context).pop('cancel');
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  void _redirectToStripe() {
    final redirectToCheckoutJs = '''
var stripe = Stripe(\'$apiKey\');
    
stripe.redirectToCheckout({
  sessionId: '${widget.sessionId}'
}).then(function (result) {
  result.error.message = 'Error'
});
''';
    _controller.evaluateJavascript(redirectToCheckoutJs);
  }

  String get initialUrl =>
      'data:text/html;base64,${base64Encode(Utf8Encoder().convert(kStripeHtmlPage))}';
}

const kStripeHtmlPage = '''
<!DOCTYPE html>
<html>
<script src="https://js.stripe.com/v3/"></script>
<head><title>Stripe checkout</title></head>
<body>
Hello Webview
</body>
</html>
''';
