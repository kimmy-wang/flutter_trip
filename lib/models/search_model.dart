class SearchModel {
  final List<SearchItem> data;

  String keyword;

  SearchModel({this.data});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    List<SearchItem> searchItemList = json['data'] == null
        ? null
        : (json['data'] as List).map((j) => SearchItem.fromJson(j)).toList();
    return SearchModel(data: searchItemList);
  }
}

class SearchItem {
  final String word;
  final String type;
  final String price;
  final String star;
  final String zonename;

  final String districtname;
  final String url;

  SearchItem(
      {this.word,
      this.type,
      this.price,
      this.star,
      this.zonename,
      this.districtname,
      this.url});

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : SearchItem(
            word: json['word'],
            type: json['word'],
            price: json['price'],
            star: json['star'],
            zonename: json['zonename'],
            districtname: json['districtname'],
            url: json['url'],
          );
  }
}
