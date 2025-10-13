import 'package:flutter/material.dart';
import 'package:myapp/features/authentication/presentation/pages/login_page.dart';
import 'package:myapp/features/authentication/presentation/pages/onboarding_page.dart';
import 'package:myapp/features/authentication/presentation/pages/register_page.dart';
import 'package:myapp/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:myapp/features/customer/presentation/pages/address_page.dart';
import 'package:myapp/features/customer/presentation/pages/cart_page.dart';
import 'package:myapp/features/customer/presentation/pages/home_page.dart';
import 'package:myapp/features/customer/presentation/pages/order_details_page.dart';
import 'package:myapp/features/customer/presentation/pages/order_history_page.dart';
import 'package:myapp/features/customer/presentation/pages/product_detail_page.dart';
import 'package:myapp/features/customer/presentation/pages/product_list_page.dart';
import 'package:myapp/features/customer/presentation/pages/profile_page.dart';
import 'package:myapp/features/checkout/presentation/pages/confirmation_page.dart';
import 'package:myapp/features/checkout/presentation/pages/delivery_page.dart';
import 'package:myapp/features/checkout/presentation/pages/payment_page.dart';
import 'package:myapp/routes/app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => OnboardingPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case AppRoutes.products:
        return MaterialPageRoute(builder: (_) => ProductListingPage());
      case AppRoutes.productDetail:
        return MaterialPageRoute(builder: (_) => ProductDetailsPage());
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => CartPage());

      case AppRoutes.checkoutAddress:
        return MaterialPageRoute(builder: (_) => MyAddressesPage());
      case AppRoutes.checkoutDelivery:
        return MaterialPageRoute(builder: (_) => DeliveryPage());
      case AppRoutes.checkoutPayment:
        return MaterialPageRoute(builder: (_) => PaymentPage());
       case AppRoutes.checkoutConfirmation:
         return MaterialPageRoute(builder: (_) => ConfirmationPage());

      case AppRoutes.orderHistory:
        return MaterialPageRoute(builder: (_) => OrderHistoryPage());
      case AppRoutes.orderDetails:
        return MaterialPageRoute(builder: (_) => OrderDetailsPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('404 - Page Not Found'))),
        );
    }
  }
}
