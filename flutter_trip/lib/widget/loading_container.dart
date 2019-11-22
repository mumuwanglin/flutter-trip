import 'package:flutter/material.dart';
// 加载进度条组件
class LoadingContainer extends StatelessWidget {
  final Widget childWidget;
  final bool isLoading;
  final bool isCover;

  const LoadingContainer({Key key, @required this.childWidget, @required this.isLoading, this.isCover=false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return !isCover ? !isLoading ? childWidget : _loadingView :
        Stack(
          children: <Widget>[
            childWidget,
            isLoading ? _loadingView : null
          ],
        );
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
