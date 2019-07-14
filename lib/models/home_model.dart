import 'common_model.dart';
import 'config_model.dart';
import 'grid_nav_model.dart';
import 'sales_box_model.dart';

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;
  final SalesBoxModel salesBox;

  HomeModel(
      {this.config,
      this.bannerList,
      this.localNavList,
      this.subNavList,
      this.gridNav,
      this.salesBox});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    List<CommonModel> bannerList = json['bannerList'] == null
        ? null
        : (json['bannerList'] as List)
            .map((j) => CommonModel.fromJson(j))
            .toList();

    List<CommonModel> localNavList = json['localNavList'] == null
        ? null
        : (json['localNavList'] as List)
            .map((j) => CommonModel.fromJson(j))
            .toList();

    List<CommonModel> subNavList = json['subNavList'] == null
        ? null
        : (json['subNavList'] as List)
            .map((j) => CommonModel.fromJson(j))
            .toList();

    return HomeModel(
      config: ConfigModel.fromJson(json['config']),
      bannerList: bannerList,
      localNavList: localNavList,
      subNavList: subNavList,
      gridNav: GridNavModel.fromJson(json['gridNav']),
      salesBox: SalesBoxModel.fromJson(json['salesBox']),
    );
  }
}
