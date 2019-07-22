import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/mine_page.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/travel_page.dart';

const TEXTS = ['首页', '搜索', '旅拍', '我的'];
const ICONS = [
  Icons.home,
  Icons.search,
  Icons.camera_alt,
  Icons.account_circle
];

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomePage(),
          SearchPage(
            hideLeft: true,
          ),
          TravelPage(),
          MinePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: _items),
    );
  }

  List<BottomNavigationBarItem> get _items {
    List<BottomNavigationBarItem> items = [];
    TEXTS.asMap().forEach((int index, String text) {
      items.add(_item(index, text));
    });
    return items;
  }

  BottomNavigationBarItem _item(int index, String text) {
    return BottomNavigationBarItem(
        title: Text(
          text,
          style: TextStyle(
              color: _currentIndex == index ? _activeColor : _defaultColor),
        ),
        icon: Icon(
          ICONS[index],
          color: _defaultColor,
        ),
        activeIcon: Icon(
          ICONS[index],
          color: _activeColor,
        ));
  }
}
