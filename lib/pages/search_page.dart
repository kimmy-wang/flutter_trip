import 'package:flutter/material.dart';
import 'package:flutter_trip/widgets/search.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Search(
            hideLeft: true,
            defaultText: '搜索',
            hint: '123',
            leftButtonClick: (){
              Navigator.pop(context);
            },
            onChanged: _onTextChange,
          )
        ],
      ),
    );
  }

  void _onTextChange(String text) {

  }
}
