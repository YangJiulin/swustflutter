import 'dart:io';

import 'package:swustflutter/config/constant.dart';
import 'package:swustflutter/model/experiment_info.dart';
import 'package:swustflutter/pages/detail_info.dart';
import 'package:swustflutter/pages/find/search_page.dart';
import 'package:swustflutter/widgets/find_list.dart';
import 'package:swustflutter/widgets/search_input.dart';
import 'package:swustflutter/client/swust_api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/experiment_info.dart';

class FindPage extends StatefulWidget {
  ///发现界面
  var apiClient = new SwustAPIClient();
  @override
  State<StatefulWidget> createState() => _FindPageState();
}

///查找状态
enum FindState { loading, loaded, fail }

class _FindPageState extends State<FindPage> {
  FindState _filesState = FindState.loaded;

  ///实验室列表
  List<dynamic> _experimentList = [];

  Future<List<dynamic>> _getList() async {
    return await widget.apiClient
        .getExperimentList(Constant.userConfigInfo.authtoken);
  }

  @override
  void initState() {
    super.initState();
//    _exper = _experimentList;
    _getList().then((value) {
      setState(() {
        _experimentList = value;
        print(_experimentList.length);
      });
    });
  }

  ///聚焦搜索框
  void _onFocusSearchInput() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchPage()));
  }

  /// 获取实验室详情信息
  Future<Map<String, dynamic>> getDetailInfo(String token, String labId) async {
    return await widget.apiClient.getDetailInfo(labId, token);
  }

  Map<String, dynamic> experimentInfo;

  ///跳转到实验室详细信息界面
  void _onForwardDir(String labId) {
    getDetailInfo(Constant.userConfigInfo.authtoken, labId).then((value) {
      setState(() {
        print(value);
        experimentInfo = value;
        ExperimentInfo info = ExperimentInfo.fromJsonAll(experimentInfo);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailInfo(experimentInfo: info)));
      });
    });
  }

  ///实验室界面
  Widget _buildExperWidget() {
    switch (_filesState) {
      case FindState.loading:
        ///加载中
        return Center(
          heightFactor: 5,
          child: Column(children: <Widget>[
            CircularProgressIndicator(strokeWidth: 4.0),
            Text('正在加载')
          ]),
        );
      case FindState.loaded:
        return ExperimentListWidget(_experimentList, onFileTap: _onForwardDir);
      case FindState.fail:
        ///加载失败
        return Column(children: <Widget>[
          SizedBox(height: 200),
          /*IconButton(
              icon: Icon(Icons.refresh),
              iconSize: 96,
              onPressed: _requestFiles),
          Text(_failMsg)*/
        ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('实验室信息', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
        child: Column(
          children: <Widget>[
            Container(
                height: 35,
                child: SearchInputWidget(onTap: _onFocusSearchInput)),
            Center(child: _buildExperWidget())
          ],
        ),
      ),
    );
  }
}
