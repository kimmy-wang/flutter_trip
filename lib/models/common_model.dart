class CommonModel {
  final String icon;
  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;

  CommonModel(
      {this.icon, this.title, this.url, this.statusBarColor, this.hideAppBar});

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : CommonModel(
            icon: json['json'],
            title: json['title'],
            url: json['url'],
            statusBarColor: json['statusBarColor'],
            hideAppBar: json['hideAppBar'],
          );
  }
}
