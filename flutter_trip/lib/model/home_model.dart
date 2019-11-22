
//config	Object	NonNull
//bannerList	Array	NonNull
//localNavList	Array	NonNull
//gridNav	Object	NonNull
//subNavList	Array	NonNull
//salesBox	Object	NonNull

import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/config_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;
  final SalesBoxModel salesBox;

  HomeModel({this.config, this.bannerList, this.localNavList, this.subNavList,
    this.gridNav, this.salesBox});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    var config = json['config'] != null ? new ConfigModel.fromJson(json['config']) : null;

    var bannerList = new List<CommonModel>();
    json['bannerList'].forEach((v) {
      bannerList.add(new CommonModel.fromJson(v));
    });


    var localNavList = new List<CommonModel>();
    json['localNavList'].forEach((v) {
      localNavList.add(new CommonModel.fromJson(v));
    });

    var gridNav =
    json['gridNav'] != null ? new GridNavModel.fromJson(json['gridNav']) : null;

    var subNavList = new List<CommonModel>();
    json['subNavList'].forEach((v) {
      subNavList.add(new CommonModel.fromJson(v));
    });

    var salesBox = json['salesBox'] != null
        ? new SalesBoxModel.fromJson(json['salesBox'])
        : null;

    return HomeModel(
        config: config,
        bannerList: bannerList,
        localNavList: localNavList,
        subNavList: subNavList,
        gridNav: gridNav,
        salesBox: salesBox
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.config != null) {
      data['config'] = this.config.toJson();
    }
    if (this.bannerList != null) {
      data['bannerList'] = this.bannerList.map((v) => v.toJson()).toList();
    }
    if (this.localNavList != null) {
      data['localNavList'] = this.localNavList.map((v) => v.toJson()).toList();
    }
    if (this.gridNav != null) {
      data['gridNav'] = this.gridNav.toJson();
    }
    if (this.subNavList != null) {
      data['subNavList'] = this.subNavList.map((v) => v.toJson()).toList();
    }
    if (this.salesBox != null) {
      data['salesBox'] = this.salesBox.toJson();
    }
    return data;
  }
}