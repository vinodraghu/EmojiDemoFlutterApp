import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gmail_login/helper/app_state.dart';
import 'package:flutter_gmail_login/models/emojiModel.dart';
import 'package:flutter_gmail_login/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeContent extends StatefulWidget {
  @override
  State createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  final _searchController = TextEditingController();
  List<emojiModel> _emojiList = [];
  List<emojiModel> _searchemojiList = [];
  List<String> comments = [];
  SharedPreferences prefs;
  String imgClickFlag = "";

  Future<String> _loadAStudentAsset() async {
    return await rootBundle.loadString('assets/json/emoji.json');
  }

  void loadStudent() async {
    String jsonString = await _loadAStudentAsset();
    final jsonResponse = json.decode(jsonString);
    // print(jsonResponse);
    prefs = await SharedPreferences.getInstance();

    setState(() {
      _emojiList = List<emojiModel>.from(
          jsonResponse.map((i) => emojiModel.fromJson(i)));
      _searchemojiList = _emojiList;
      comments.add("Recent");
      for (var values in _emojiList) {
        if (!comments.contains(values.category)) {
          comments.add(values.category);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadStudent();
  }

  Widget _gridView() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
      dragStartBehavior: DragStartBehavior.start,
      itemBuilder: (_, index) => _emojiList.length > 0
          ? GestureDetector(
              onTap: () {
                List rc = prefs.getStringList("rlist");
                if (rc != null && !rc.contains(_emojiList[index].emoji)) {
                  if (rc.length > 44) {
                    rc.removeAt(0);
                  }
                  rc.add(_emojiList[index].emoji);
                  prefs.setStringList('rlist', rc);
                } else if (rc == null) {
                  List<String> rc = [];
                  rc.add(_emojiList[index].emoji);
                  prefs.setStringList('rlist', rc);
                }
              },
              child: Center(
                child: Text(
                  _emojiList[index].emoji,
                  style: Style.ETextStyle,
                ),
              ),
            )
          : CircularProgressIndicator(backgroundColor: Colors.red,),
      itemCount:
          _emojiList != null && _emojiList.length > 0 ? _emojiList.length : 0,
    );
  }

  Widget _recentemgridView() {
    List rc = prefs.getStringList("rlist");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Frequently Used",
            style: Style.RETextStyle,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
          dragStartBehavior: DragStartBehavior.start,
          itemBuilder: (_, index) => rc.length > 0
              ? Center(
                  child: Text(
                    rc[index],
                    style: Style.ETextStyle,
                  ),
                )
              : CircularProgressIndicator(),
          itemCount: rc != null && rc.length > 0 ? rc.length : 0,
        ),
      ],
    );
  }

  Widget imgCateIcons(IconData icon, String is_selected, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Column(
        children: [
          Icon(
            icon,
            size: 35,
            color: is_selected == value ? Colors.white : Colors.grey,
          ),
          is_selected == value
              ? Container(
                  width: 35,
                  height: 4,
                  margin: const EdgeInsets.only(top: 2),
                  color: Colors.green,
                )
              : Container(),
        ],
      ),
    );
  }

  Widget getTextWidgets(String value) {
    final appState = Provider.of<AppState>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 2, right: 2),
      child: Row(
        children: [
          SizedBox(
            width: 7.0,
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  _searchController.clear();
                  if (value == "Recent") {
                    imgClickFlag = value;
                  } else {
                    imgClickFlag = value;
                    _emojiList = _searchemojiList.where((customerTicket) {
                      return customerTicket.category == value;
                    }).toList();
                  }
                  appState.selectedCategory = value;
                });
              },
              child: value == "Recent"
                  ? imgCateIcons(
                      Icons.recent_actors, appState.selectedCategory, value)
                  : value == "Smileys & Emotion"
                      ? imgCateIcons(
                          Icons.face, appState.selectedCategory, value)
                      : value == "People & Body"
                          ? imgCateIcons(
                              Icons.people, appState.selectedCategory, value)
                          : value == "Animals & Nature"
                              ? imgCateIcons(Icons.nature,
                                  appState.selectedCategory, value)
                              : value == "Food & Drink"
                                  ? imgCateIcons(
                                      Icons.emoji_food_beverage_outlined,
                                      appState.selectedCategory,
                                      value)
                                  : value == "Travel & Places"
                                      ? imgCateIcons(Icons.place_outlined,
                                          appState.selectedCategory, value)
                                      : value == "Activities"
                                          ? imgCateIcons(Icons.local_activity,
                                              appState.selectedCategory, value)
                                          : value == "Objects"
                                              ? imgCateIcons(
                                                  Icons.emoji_objects_outlined,
                                                  appState.selectedCategory,
                                                  value)
                                              : value == "Symbols"
                                                  ? imgCateIcons(
                                                      Icons.emoji_symbols,
                                                      appState.selectedCategory,
                                                      value)
                                                  : value == "Flags"
                                                      ? imgCateIcons(
                                                          Icons.flag_outlined,
                                                          appState
                                                              .selectedCategory,
                                                          value)
                                                      : imgCateIcons(
                                                          Icons.flag_rounded,
                                                          appState
                                                              .selectedCategory,
                                                          value))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Demo'),
        ),
        body: ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //_emojiList != null ?getTextWidgets():Container(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for (var item in comments) getTextWidgets(item),
                      ],
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.lightBlue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextField(
                      autofocus: true,
                      inputFormatters: [
                        ],
                      style: Style.InputTextStyle,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey,
                          size: 30,
                        ),
                        contentPadding: const EdgeInsets.all(8.0),
                        border: InputBorder.none,
                        hintStyle: Style.InputHintTextStyle,
                        isDense: true,
                        hintText: 'Search...',
                      ),
                      controller: _searchController,
                      onChanged: (text) {
                        text = text.toLowerCase();
                        setState(() {
                          if (text.trim() != "") {
                            _emojiList =
                                _searchemojiList.where((customerTicket) {
                              String ticketNo =
                                  customerTicket.description.toLowerCase();
                              List alies = customerTicket.aliases;
                              List tags = customerTicket.tags;
                              String ticketSubject =
                                  customerTicket.description.toLowerCase();
                              return ticketNo.contains(text) ||
                                  ticketNo.indexOf(text) > 0 ||
                                  alies.contains(text) ||
                                  alies.indexOf(text) > 0 ||
                                  tags.contains(text) ||
                                  tags.contains(text) ||
                                  tags.indexOf(text) > 0;
                            }).toList();
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: imgClickFlag == "Recent"
                          ? _recentemgridView()
                          : _gridView())
                ],
              ),
            ),
          ),
        ));
  }
}
