import 'package:flutter/material.dart';
import 'package:ly_xc_app/model/common_model.dart';
import 'package:ly_xc_app/widget/webview.dart';

class LocalNav extends StatelessWidget {
  final List<CommonModel>? localNavList;

  const LocalNav({Key? key, this.localNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (localNavList == null) {
      return null;
    }

    List<Widget> items = [];

    localNavList?.forEach((model) {
      items.add(_item(context, model));
    });

    return Row(
      children: items,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  Widget _item(BuildContext context, CommonModel itemModel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Webview(
                    url: itemModel.url,
                    statusBarColor: itemModel.statusBarColor,
                    hideAppBar: itemModel.hideAppBar)));
      },
      child: Column(
        children: [
          Image.network(
            itemModel.icon ?? "",
            width: 32,
            height: 32,
          ),
          Text(
            itemModel.title ?? "",
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
