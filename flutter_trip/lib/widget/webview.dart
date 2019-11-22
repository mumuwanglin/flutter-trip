import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5', 'm.ctrip.com/html5/'];

class WebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;


  WebView({this.url, this.statusBarColor, this.title, this.hideAppBar, this.backForbid = false});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;
  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url){

    });

    _onStateChanged = flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged stateChanged){
      switch (stateChanged.type) {
        case WebViewState.startLoad:
          if(_isToMain(stateChanged.url) && exiting){
            if(widget.backForbid){
              flutterWebviewPlugin.launch(widget.url);
            }else {
              Navigator.pop(context);
            }
          }
          break;
        default:
          break;
      }
    });

    _onHttpError = flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error){
      print(error);
    });

  }


  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? "ffffff";
    Color backButtonColor;
    if(statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    }else {
      backButtonColor = Colors.white;
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              userAgent: 'null',
              //防止携程H5页面重定向到打开携程APP ctrip://wireless/xxx的网址
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              enableAppScheme: true,
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if(widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }else {
      return Container(
        color: backButtonColor,
        padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
        child: FractionallySizedBox(  //FractionallySizedBox 使得元素撑满
          widthFactor: 1,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Icon(Icons.close, color: backButtonColor, size: 26,),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    widget.title ?? "",
                    style: TextStyle(color:  backButtonColor, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  _isToMain(String url) {
    bool contain = false;
    for(final value in CATCH_URLS) {
      if(url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }
}
