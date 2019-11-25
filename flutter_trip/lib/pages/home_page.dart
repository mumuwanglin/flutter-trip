import 'dart:convert';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/speak_page.dart';
import 'package:flutter_trip/util/navigator_util.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/webview.dart';

const APPBAR_SCROLL_OFFET = 100;
const SEARCH_BAR_DEFAULT_TEXT = "网红打卡地 景点 酒店 美食";
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double appBarAlpha = 0;
  String resultString = "";
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  List<CommonModel> bannerList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBox;
  bool _isLoading = true;

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFET;
    if(alpha < 0){
      alpha = 0;
    }else if(alpha > 1){
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  @override
  void initState() {
    super.initState();
    _handleRefresh();
    hideScreen();
  }

  Future<void> hideScreen() async {
    Future.delayed(Duration(milliseconds: 3600), () {
      FlutterSplashScreen.hide();
    });
  }

  Future<Null> _handleRefresh() async {
    try{
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBox = model.salesBox;
        bannerList = model.bannerList;
        _isLoading = false;
      });
    } catch(e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffaf2f2),
        body: LoadingContainer(
          childWidget: Stack(
            children: <Widget>[
              MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: NotificationListener(
                      onNotification: (scrollNotification){
                        if(scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0){
                          // 滚动而且是列表滚动的时候
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                        return true;
                      },
                      child: _listView,
                    ),
                  )
              ),
              _appBar,
            ],
          ),
          isLoading: _isLoading,
        )
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
            padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
            child: LocalNav(localNavList: localNavList,)
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: GridNav(gridNavModel: gridNavModel,),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SubNav(subNavList: subNavList,),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SalesBox(salesBox: salesBox,),
        ),
      ],
    );
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80,
            decoration: BoxDecoration(color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
            child:SearchBar(
              searchBarType: appBarAlpha > 0.2 ? SearchBarType.homeLight : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: (){},
            ),
          ),
        ),

        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]
          ),
        )
      ],
    );


  }

  Widget get _banner {
    return Container(
      height: 160,
      child: new Swiper(
        itemBuilder: (BuildContext context,int index){
          return GestureDetector(
            onTap: (){
              CommonModel model = bannerList[index];
              NavigatorUtil.push(context, WebView(
                url: model.url,
                title: model.title,
                hideAppBar: model.hideAppBar,
              ));
            },
            child: new Image.network(bannerList[index].icon,fit: BoxFit.fill,),
          );
        },
        itemCount: bannerList.length,
        autoplay: true,
        pagination: new SwiperPagination(),
      ),
    );
  }

  _jumpToSearch() {
    NavigatorUtil.push(context, SearchPage(hint: SEARCH_BAR_DEFAULT_TEXT,));
  }

  _jumpToSpeak() {
    NavigatorUtil.push(context, SpeakPage());
  }
}

