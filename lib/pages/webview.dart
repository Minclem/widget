import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class IWebview extends StatefulWidget {
  @override
  _IWebviewState createState() => _IWebviewState();
}

class _IWebviewState extends State<IWebview> {
  WebViewController _webViewController;
  String _title = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return WebView(
            initialUrl: 'https://xxxx/scheme',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
              print('onWebViewCreated');
            },
            onPageFinished: (url) {
              print('onPageFinished $url');
              _webViewController
                  .evaluateJavascript('document.title')
                  .then((result) {
                setState(() {
                  _title = result ?? 'WEBVIEW';
                });
              });
            },
            navigationDelegate: (NavigationRequest request) async {
              // 协议链接拦截
              if (request.url.startsWith('myapp://')) {
                print(request);

                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            // JSBridge 通讯
            javascriptChannels: <JavascriptChannel>[
              // window.share.postMessage(params); params = JSON.stringify({xx: xx});
              JavascriptChannel(
                  name: 'share',
                  onMessageReceived: (JavascriptMessage message) {
                    Map<String, dynamic> msg = jsonDecode(message.message);
                    String data = jsonEncode(msg);
                    String callBack =
                        'window.callbackHandleList[${msg['handle']}]($data)';

                    // 触发回调
                    _webViewController
                        .evaluateJavascript(callBack)
                        .then((result) {
                      print(
                          '_webViewController.evaluateJavascript callback => $result');
                    });
                  }),

              /// window.nactiveBack.postMessage(null);
              JavascriptChannel(
                  name: 'nactiveBack',
                  onMessageReceived: (JavascriptMessage message) {
                    print(message.message);
                    print(message.message == '<null>');
                    Navigator.pop(context);
                  }),
            ].toSet(),
          );
        },
      ),
    );
  }
}
