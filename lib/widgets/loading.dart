import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Widget child;
  final bool loading;
  final bool cover;

  const Loading(
      {Key key,
      @required this.loading,
      this.cover = false,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !cover
        ? !loading ? child : _loadingView
        : Stack(
            children: <Widget>[child, loading ? _loadingView : null],
          );
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
