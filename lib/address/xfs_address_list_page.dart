import 'package:flutter/material.dart';
import 'package:flutter_facebook/address/xfs_address_list_presenter.dart';
import 'package:flutter_facebook/address/xfs_address_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xfs_flutter_utils/base/xfs_base_list_page.dart';
import 'package:xfs_flutter_utils/base/xfs_base_presenter.dart';
import 'package:xfs_flutter_utils/base/xfs_base_view.dart';
import 'package:xfs_flutter_utils/widgets/xfs_inkwell.dart';




class XFSAddressListPage extends XFSBaseListPage {
  @override
  XFSBaseListPageState<XFSBaseListPage, Object, XFSBasePresenter<XFSBaseView>>
      getState() {
    return _AddressListPageState();
  }
}

class _AddressListPageState extends XFSBaseListPageState<XFSAddressListPage,
    XFSAddressModel, XFSAddressListPresenter>   {

  @override
  void initState() {
    super.initState();
    presenter.refreshData();
  }
  @override
  Widget buildItem(XFSAddressModel entity, int index) {
    return XFSInkWell(
        child: Text('${entity.detail_address}--$index'),
      onTap: (){
        Fluttertoast.showToast(msg: '${entity.detail_address}--$index');
      },
    );
  }


  @override
  XFSAddressListPresenter initPresenter() {
    return XFSAddressListPresenter(this);
  }
}
