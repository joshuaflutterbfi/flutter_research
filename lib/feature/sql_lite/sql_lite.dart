import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_research/feature/sql_lite/database/db_manager.dart';
import 'package:flutter_research/feature/sql_lite/model/data.dart';
import 'package:flutter_research/styles/fontTheme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteScreen extends StatefulWidget {
  @override
  _SQLiteScreenState createState() => _SQLiteScreenState();
}

class _SQLiteScreenState extends State<SQLiteScreen> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  final db = DatabaseManager.instance;
  List<TVSeries> listTv = [];
  TVSeries tvSeries;
  @override
  void initState() {
    super.initState();
    getTvSeries();
  }

  Uint8List _bytes;
  String base64Image;
  PlatformFile file;

  addTvSeries(TVSeries tvSeries) async {
    await db.addTVSeries(tvSeries);
  }

  getTvSeries() async {
    await db.database;
    listTv = await db.fetchAllTvSeries();
    print(listTv);
  }

  Future _getFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      imageCache.maximumSize = 0;
      imageCache.clear();
      file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      File fileBase64 = File(file.path);
      base64Image = base64Encode(fileBase64.readAsBytesSync());
    }
  }

  Widget textField(TextEditingController textEditingController, String title) =>
      Container(
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: TextField(
          textAlign: TextAlign.center,
          controller: textEditingController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Color(0xFF495ECA),
                width: 2.0,
              ),
            ),
            hintText: title,
            hintStyle: TextStyle(
              fontSize: 16,
              color: Color(0xFF495ECA),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Color(0xFF495ECA),
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            fillColor: Colors.white,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Header.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'List of TV Series',
                            style: titleHeaderWhite,
                          ),
                        ),
                        textField(_title, ' Enter Title '),
                        textField(_description, ' Enter Description'),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  _getFile();
                                },
                                child: Text(
                                  "Choose Image",
                                  style: sans14Black,
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: StadiumBorder()),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            file != null ? Text(file.name) : Text('Filename')
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 400,
                          child: ElevatedButton(
                            onPressed: () async {
                              final TVSeries tvSeries = TVSeries(
                                  id: 3,
                                  title: _title.text,
                                  description: _description.text,
                                  image: base64Image);
                              await addTvSeries(tvSeries);
                              await getTvSeries();
                            },
                            child: Text(
                              "Add Tv Series",
                              style: sans16Black,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFFFFFFFF),
                                shape: StadiumBorder()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                ),
                color: Color(0xFFFFFFFF),
              ),
              child: StaggeredGridView.countBuilder(
                scrollDirection: Axis.vertical,
                crossAxisCount: 4,
                itemCount: listTv.length,
                itemBuilder: (BuildContext context, int index) => Container(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.memory(
                            listTv[index]?.image != null
                                ? Base64Decoder().convert(listTv[index].image)
                                : Base64Decoder().convert(listTv[0].image),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Text(listTv[index].title, style: titleSubHeader),
                      ],
                    ),
                  ),
                ),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
