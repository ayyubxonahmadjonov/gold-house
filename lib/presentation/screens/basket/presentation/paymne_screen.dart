import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const PaymentScreen({super.key, required this.paymentUrl});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late InAppWebViewController _webViewController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Validate URL format
    if (!Uri.parse(widget.paymentUrl).isAbsolute || !widget.paymentUrl.startsWith('https://')) {
      setState(() {
        _errorMessage = 'Invalid or insecure payment URL';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('To‘lov'),
          automaticallyImplyLeading: false, // Disable default back button
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _handleBackNavigation(),
          ),
        ),
        body: Stack(
          children: [
            if (_errorMessage != null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Orqaga'),
                    ),
                  ],
                ),
              )
            else
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(widget.paymentUrl)),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true, // Enable JS for payment gateways
                    useShouldOverrideUrlLoading: true,
                    cacheEnabled: false, // Disable cache for security
                  ),
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    _isLoading = true;
                  });
                },
                onLoadStop: (controller, url) async {
                  setState(() {
                    _isLoading = false;
                  });
                  if (url != null) {
                    final currentUrl = url.toString().toLowerCase();
                    // Check for success, fail, or cancel URLs
                    if (currentUrl.contains('success')) {
                      Navigator.pop(context, {'success': true, 'url': currentUrl});
                    } else if (currentUrl.contains('fail') || currentUrl.contains('cancel')) {
                      Navigator.pop(context, {'success': false, 'url': currentUrl});
                    }
                  }
                },
                onLoadError: (controller, url, code, message) {
                  setState(() {
                    _isLoading = false;
                    _errorMessage = 'Failed to load payment page: $message';
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final url = navigationAction.request.url.toString();
                  // Restrict navigation to the payment domain for security
                  if (!url.startsWith(widget.paymentUrl.split('?')[0])) {
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },
              ),
            if (_isLoading && _errorMessage == null)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Future<bool> _handleBackNavigation() async {
    // Check if web view can go back
    if (await _webViewController.canGoBack()) {
      _webViewController.goBack();
      return false; // Prevent app from popping
    } else {
      // Confirm with user before canceling payment
      final confirmCancel = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('To‘lovni bekor qilish'),
          content: const Text('To‘lov jarayonini bekor qilmoqchimisiz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Yo‘q'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child:  Text('yes'.tr()),
            ),
          ],
        ),
      );
      if (confirmCancel == true) {
        Navigator.pop(context, {'success': false, 'reason': 'user_cancelled'});
      }
      return confirmCancel ?? false;
    }
  }
}