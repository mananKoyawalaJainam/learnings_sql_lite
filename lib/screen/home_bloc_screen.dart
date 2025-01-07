import 'package:flutter/material.dart';
import 'package:sql_lite/Package/Utils.dart';
import 'package:sql_lite/models/picture.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite/Package/Text_Button.dart';
import 'package:sql_lite/Package/TextFormField.dart';
import 'package:sql_lite/screen/profile_screen.dart';
import 'package:sql_lite/bloc/home_screen/home_bloc.dart';
import 'package:sql_lite/bloc/home_screen/home_event.dart';
import 'package:sql_lite/bloc/home_screen/home_state.dart';

class HomeBlocScreen extends StatelessWidget
    with text_with_button, utils, formField {
  const HomeBlocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadPictures()),
      child: Scaffold(
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
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is PictureLoading) {
              const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is PictureLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(LoadPictures());
                },
                child: state.pictures.isEmpty
                    ? Center(child: Text("There is no Picture to show"))
                    : ListView.builder(
                        itemCount: state.pictures.length,
                        itemBuilder: (context, index) {
                          Picture p = state.pictures[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.memory(p.picture)),
                              InkWell(
                                  onTap: () {
                                    context
                                        .read<HomeBloc>()
                                        .add(DeletePicture(id: p.id));
                                  },
                                  child: Icon(Icons.delete, color: Colors.red))
                            ],
                          );
                        },
                      ),
              );
            }
            return Center(
                child: Text("Something went wrong, try again later."));
          },
        ),
      ),
    );
  }
}
