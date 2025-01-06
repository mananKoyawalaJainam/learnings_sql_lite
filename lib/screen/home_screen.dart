import 'package:flutter/material.dart';
import 'package:sql_lite/Package/Utils.dart';
import 'package:sql_lite/models/picture.dart';
import 'package:sql_lite/database/db_helper.dart';
import 'package:sql_lite/screen/edit_screen.dart';
import 'package:sql_lite/Package/Text_Button.dart';
import 'package:sql_lite/screen/profile_screen.dart';
import 'package:sql_lite/Package/PackageConstants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with text_with_button, utils {
  List<Picture> pictures = [];
  DBHelper helper = DBHelper.instance;

  @override
  void initState() {
    loadPictures();
    super.initState();
  }

  @override
  void dispose() {
    helper.close();
    super.dispose();
  }

  loadPictures() async {
    await helper.getAllPictures().then((value) {
      setState(() {
        pictures = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        },
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: CP(
        h: 16,
        child: pictures.isEmpty
            ? Center(
                child: text(text: "No Products are available", fontSize: 18))
            : RefreshIndicator(
                onRefresh: () => loadPictures(),
                child: ListView.builder(
                  itemCount: pictures.length,
                  itemBuilder: (context, index) {
                    Picture p = pictures[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            EditPictureScreen(pid: p.id)));
                              },
                              child: Icon(Icons.edit, color: Colors.blue)),
                          Image.memory(
                            p.picture,
                            height: 50,
                          ),
                          InkWell(
                              onTap: () {
                                helper.delete(p.id);
                                loadPictures();
                              },
                              child: Icon(Icons.delete, color: Colors.red))
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
