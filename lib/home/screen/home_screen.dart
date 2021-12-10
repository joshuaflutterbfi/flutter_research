import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_research/home/data/remote_config_home_model.dart';
import 'package:flutter_research/styles/fontTheme.dart';
import 'package:flutter_research/util/general_util.dart';
import 'package:flutter_research/util/remote_config_util.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  RemoteConfigHomeModel remoteConfigHomeModel;

  @override
  void initState() {
    FeatureRemoteConfig()
        .checkPageRomoteConfigSpecific('home_menu')
        .then((RemoteConfigHomeModel value) {
      if (value != null) {
        setState(() {
          remoteConfigHomeModel = value;
          isLoading = false;
        });
      }
    }).catchError((dynamic onError) {
      print(onError);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 45, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                'Flutter Research',
                style: titleHeader,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 4, bottom: 12),
              child: Text('by Mobile Squad', style: titleSubHeader),
            ),
            isLoading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()),
                      ),
                    ],
                  )
                : Expanded(
                    child: StaggeredGridView.countBuilder(
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 4,
                      itemCount: remoteConfigHomeModel.homeMenu.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        child: GestureDetector(
                          onTap: () {
                            log('${remoteConfigHomeModel.homeMenu[index].value}');
                            Navigator.pushNamed(context,
                                remoteConfigHomeModel.homeMenu[index].value);
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Color(GeneralUtil().hexToInt(
                                remoteConfigHomeModel.homeMenu[index].color)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    child: Image.network(
                                  remoteConfigHomeModel.homeMenu[index].asset,
                                  fit: BoxFit.fitWidth,
                                )),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      remoteConfigHomeModel
                                          .homeMenu[index].name,
                                      style: titleCardWhite,
                                      textAlign: TextAlign.center,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.count(2, index.isEven ? 3.2 : 2.8),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
