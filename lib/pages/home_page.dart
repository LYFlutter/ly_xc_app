import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ly_xc_app/model/common_model.dart';
import 'package:ly_xc_app/model/grid_nav_model.dart';
import 'package:ly_xc_app/model/home_model.dart';
import 'dart:convert';
import 'package:ly_xc_app/dao/home_dao.dart';
import 'package:ly_xc_app/widget/grid_nav.dart';
import 'package:ly_xc_app/widget/local_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _iamgeUrls = [
    'http://img5.mtime.cn/mg/2022/02/18/133826.30848199.jpg',
    'http://img5.mtime.cn/mg/2021/12/24/103423.66994613.jpg',
    'http://img5.mtime.cn/mg/2021/12/24/102414.16825817.jpg'
  ];

  double appBarAlpha = 0;

  List<CommonModel>? localNavList;
  GridNavModel? gridNavModel;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  _onscroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }

    setState(() {
      appBarAlpha = alpha;
    });
  }

  loadData() async {
    try {
      HomeModel homeModel = await HomeDao.fetch();

      setState(() {
        localNavList = homeModel.localNavList;
        gridNavModel = homeModel.gridNav;
      });
    } catch (e) {
      String eStr = e.toString();
      print(eStr);
    }
  }

  // loadData() {
  //   HomeDao.fetch().then((result) {
  //     setState(() {
  //       resultString = json.encode(result);
  //     });
  //   }).catchError((e) {
  //     setState(() {
  //       resultString = e.toString();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: Stack(
          children: [
            MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: NotificationListener(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification &&
                        scrollNotification.depth == 0) {
                      _onscroll(scrollNotification.metrics.pixels);
                    }
                    return true;
                  },
                  child: ListView(
                    children: [
                      Container(
                        height: 160,
                        child: Swiper(
                          itemCount: _iamgeUrls.length,
                          autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              _iamgeUrls[index],
                              fit: BoxFit.fill,
                            );
                          },
                          pagination: SwiperPagination(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                        child: LocalNav(localNavList: localNavList),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                        child: GridNav(
                          gridNavModel: gridNavModel,
                        ),
                      ),
                    ],
                  ),
                )),
            Opacity(
              opacity: appBarAlpha,
              child: Container(
                height: 80,
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('首页'),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
