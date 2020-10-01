import 'package:flutter/material.dart';

import 'stripe_checkout_stub.dart'
    if (dart.library.io) 'stripe_checkout_mobile.dart'
    if (dart.library.js) 'stripe_checkout_web.dart' as impl;

void redirectToCheckout(BuildContext context) =>
    impl.redirectToCheckout(context);
