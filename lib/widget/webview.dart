import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];

class Webview extends StatefulWidget {
  final String? url;
  final String? statusBarColor;
  final String? title;
  final bool? hideAppBar;
  final bool? backForbid;

  Webview(
      {Key? key,
      this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar = false,
      this.backForbid = false})
      : super(key: key);

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  final webviewPreference = FlutterWebviewPlugin();
  StreamSubscription<String>? _onUrlChanged;
  StreamSubscription<WebViewStateChanged>? _onStateChanged;
  StreamSubscription<WebViewHttpError>? _onHttpError;

  bool existing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    webviewPreference.close();
    _onUrlChanged = webviewPreference.onUrlChanged.listen((event) {});
    _onStateChanged =
        webviewPreference.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.startLoad:
          if (_isToMain(state.url) && existing == false) {
            if (widget.backForbid == true) {
              webviewPreference.launch(widget.url);
            } else {
              Navigator.pop(context);
              existing = true;
            }
          }
          break;
        default:
      }
    });
    _onHttpError =
        webviewPreference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  _isToMain(String? url) {
    bool contain = false;

    for (var value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }

    return contain;
  }

  @override
  void dispose() {
    _onUrlChanged?.cancel();
    _onStateChanged?.cancel();
    _onHttpError?.cancel();
    webviewPreference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? "ffffff";
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }

    return Scaffold(
      body: Column(
        children: [
          _appBar(
              Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          Expanded(
              child: WebviewScaffold(
            url: widget.url ?? "",
            withZoom: true,
            hidden: true,
            withLocalStorage: true,
            initialChild: Container(
              color: Colors.white,
              child: Center(
                child: Text('Waiting...'),
              ),
            ),
          ))
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Text(
                  widget.title ?? "",
                  style: TextStyle(color: backButtonColor, fontSize: 20),
                ),
              ),
              left: 0,
              right: 0,
            )
          ],
        ),
      ),
    );
  }
}
