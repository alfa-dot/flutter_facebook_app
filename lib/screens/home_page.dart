import 'dart:ffi';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook/config/xfs_header.dart';
import 'package:flutter_facebook/models/banner_model.dart';
import 'package:flutter_facebook/models/category_model.dart';
import 'package:flutter_facebook/screens/home_page_present.dart';
import 'package:flutter_facebook/subject/subject_page.dart';
import 'package:flutter_facebook/widgets/banner/commont_banner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xfs_flutter_utils/widgets/xfs_button.dart';


class HomePage extends XFSBasePage {
  @override
  XFSBasePageState getState() => _HomePageState();
}

class _HomePageState
    extends XFSBasePageState<HomePage, List<Data>, HomePagePresenter> implements HomePageView{
   List<BannerModelData> arr = [];
  @override
  void initState() {
    super.initState();
    presenter.getListFirstPlay();
    presenter.getHomeBanner();
  }

  @override
  backAction() {
    // presenter.getCityList();
    // presenter.getLinkedCategoryData();
    // presenter.getSearchProData();
    // presenter.getSubjectListData();
  }
  @override
  List<Widget> actions() {
    return [
      Container(
        margin: EdgeInsets.only(right: 10),
        child: XFSTextButton.icon(
          icon: Icon(Icons.shopping_cart),
          onPressed: (){

          },
        ),
      ),

      Container(
        margin: EdgeInsets.only(right: 10),
        child: XFSTextButton.icon(
          icon: Icon(Icons.search),
          onPressed: (){},
        ),
      ),
      Container(
        margin: EdgeInsets.only(right: 10),
        child: XFSTextButton.icon(
          icon: Icon(Icons.location_on_outlined),
          onPressed: (){
            SubectListPage.pushName(context);
          },
        ),
      ),
      Container(
        margin: EdgeInsets.only(right: 10),
        child: XFSTextButton.icon(
          icon: Icon(Icons.add_a_photo_outlined),
          onPressed: (){
            _scanQR();
          },
        ),
      ),

    ];
  }
  @override
  HomePagePresenter initPresenter() {
    return HomePagePresenter(this);
  }

  @override
  bool get isShowBackButton => false;
  @override
  String get naviTitle => "方盛云采";

  @override
  Widget buildWidget(BuildContext context, List<Data> object) {
    return RefreshIndicator(
      onRefresh: (){
        return  _onRefresh();
      },
      child: Scrollable(

      physics: BouncingScrollPhysics(),

        controller: ScrollController(),
          viewportBuilder: (BuildContext context, ViewportOffset offset) {

        return  XFSContainer(
          child: ListView(
            children: [
              CommontBanner(swiperDataList:arr),
              // Pagination(),
              Expanded(
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: GridView.count(
                    primary:false,
                      shrinkWrap:true,
                    controller: ScrollController(),
                      padding: EdgeInsets.all(10),
                    //水平子Widget之间间距
                    crossAxisSpacing: 10.0,
                    //垂直子Widget之间间距
                    mainAxisSpacing: 10.0,
                    //GridView内边距
                    // padding: EdgeInsets.all(10.0),
                    //一行的Widget数量
                    crossAxisCount: 4,
                    //子Widget宽高比例
                    // childAspectRatio: 2.0,
                    //子Widget列表
                    children: getWidgetList(object),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            presenter.getListFirstPlay();
          },
        );
       },),
    );
  }

  List<Widget> getWidgetList(List<Data> object) {
    if(object.isNullOrEmpty()){
      return [];
    }
    return object?.map((item) => getItemContainer(item))?.toList();
  }
   static Future _scanQR() async {
     try {
       String qrResult = await BarcodeScanner.scan();
       print(qrResult);
     } on PlatformException catch(ex) {
       if (ex.code == BarcodeScanner.CameraAccessDenied) {
         print(ex.code);
       } else {
         print(ex.code);
       }
     } on FormatException {
       print("pressed ths back button before scanning anyting");
     } catch(ex){
       print(ex);
     }
   }

  Widget getItemContainer(Data item) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: XFSTextButton.icon(
              textColor: Colors.black,
              fontSize: 14,
              icon: Expanded(child: Image.network(item?.pictureUrl)),
              title: item?.displayContent,
              direction:XFSTextButtonIconTextDirection.textBIconT,

              onLongPress: (){
                Fluttertoast.showToast(msg: '${item?.displayContent}');
              },
              onPressed: (){
                Fluttertoast.showToast(msg: '${item?.frontFirstCategoryId}');
              },
            ),
          ),
        ],
      ),
      color: Colors.white,
    );
  }

  @override
  void showBannerData(BannerModel bannerModel) {

     arr = bannerModel.data;
     setState(() {});
  }

   Future<void> _onRefresh() async{
     await Future.delayed(Duration(seconds: 1), () {
       presenter.getListFirstPlay();
       presenter.getHomeBanner();
     });
     setState(() {

     });
  }
}
