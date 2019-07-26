import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/travel_dao.dart';
import 'package:flutter_trip/models/travel_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_trip/widgets/loading.dart';
import 'package:flutter_trip/widgets/webview.dart';

const _TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';
const PAGE_SIZE = 10;

class TravelTabPage extends StatefulWidget {
  final String travelUrl;
  final String groupChannelCode;

  const TravelTabPage({Key key, this.travelUrl, this.groupChannelCode})
      : super(key: key);

  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  List<TravelItem> travelItems = [];
  int pageIndex = 1;
  bool isLoading = true;

  @override
  void initState() {
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Loading(
        loading: isLoading,
        child: RefreshIndicator(
            child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: StaggeredGridView.countBuilder(
                  controller: _scrollController,
                  crossAxisCount: 4,
                  itemCount: travelItems?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) =>
                      _TravelItem(index: index, travelItem: travelItems[index]),
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                  // StaggeredTile.count(2, index.isEven ? 2 : 1),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                )),
            onRefresh: _handleRefresh),
      ),
    );
  }

  void _loadData({loadMore = false}) {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }

    TravelDao.fetch(widget.travelUrl ?? _TRAVEL_URL, widget.groupChannelCode,
            pageIndex, PAGE_SIZE)
        .then((TravelModel model) {
      setState(() {
        travelItems.addAll(_filterItems(model.resultList));
      });
    }).catchError((e) {
      print(e);
    }).whenComplete(() {
      isLoading = false;
    });
  }

  Future<Null> _handleRefresh() async {
    TravelDao.fetch(widget.travelUrl ?? _TRAVEL_URL, widget.groupChannelCode,
            pageIndex, PAGE_SIZE)
        .then((TravelModel model) {
      setState(() {
        travelItems = _filterItems(model.resultList);
      });
    }).catchError((e) {
      print(e);
    }).whenComplete(() {
      isLoading = false;
    });
    return null;
  }

  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if (resultList == null) return [];
    List<TravelItem> filterItems = [];
    resultList.forEach((TravelItem item) {
      if (item.article != null) {
        filterItems.add(item);
      }
    });
    return filterItems;
  }

  @override
  bool get wantKeepAlive => true;
}

class _TravelItem extends StatelessWidget {
  final int index;
  final TravelItem travelItem;

  const _TravelItem({Key key, this.index, this.travelItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          if (travelItem.article.urls != null &&
              travelItem.article.urls.length > 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => WebView(
                          url: travelItem.article.urls[0].h5Url,
                          title: travelItem.article.articleTitle,
                        )));
          }
        },
        child: Card(
          child: PhysicalModel(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _itemImage(),
                Container(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    travelItem.article.articleTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                _infoText()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _itemImage() {
    return Stack(
      children: <Widget>[
        Image.network(travelItem.article.images[0]?.dynamicUrl),
        Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 3),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  LimitedBox(
                    maxWidth: 130,
                    child: Text(
                      _poiName(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  String _poiName() {
    return travelItem.article.pois == null ||
            travelItem.article.pois.length == 0
        ? '未知'
        : travelItem.article.pois[0]?.poiName ?? '未知';
  }

  _infoText() {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  travelItem.article.author?.coverImage?.dynamicUrl,
                  width: 24,
                  height: 24,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(
                  travelItem.article.author?.nickName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                size: 14,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  travelItem.article.likeCount.toString(),
                  style: TextStyle(fontSize: 10),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
