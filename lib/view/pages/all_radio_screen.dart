// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/radio/radio_card.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/stateManagement/blocs/radio_bloc.dart';
import 'package:jendela_dbp/stateManagement/events/radio_event.dart';
import 'package:jendela_dbp/stateManagement/states/radio_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AllRadioScreen extends StatefulWidget {
  const AllRadioScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AllRadiosScreen createState() => _AllRadiosScreen();
}

class _AllRadiosScreen extends State<AllRadioScreen> {
  RadioBloc radioBloc = RadioBloc();
  final _scrollController = ScrollController();
  final int _perPage = 25;
  @override
  void initState() {
    super.initState();
    radioBloc.add(RadioFetch(perPage: _perPage));
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        // Reach the bottom.
        radioBloc.add(RadioFetchMore(perPage: _perPage));
      }
    });
  }

  @override
  void dispose() {
    radioBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
    return Scaffold(
      backgroundColor: DbpColor().jendelaDarkGreenBlue,
        appBar: AppBar(
          backgroundColor: DbpColor().jendelaDarkGreenBlue,
          centerTitle: true,
          title: const Text('Radio DBP', style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          child: Container(
            color: DbpColor().jendelaDarkGreenBlue,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<RadioBloc, RadioState>(
                bloc: radioBloc,
                builder: (context, state) {
                  if (state is RadioError) {
                    return Text(state.toString());
                  }
                  if (state is RadioLoaded) {
                    List<Widget> listWidget = state.radios!.map<Widget>(
                      (item) {
                        return SizedBox(
                          child: RadioCard(
                            mediaHeight: 200,
                            mediaWidth: size.width,
                            radio: item,
                            viewCount: 201,
                          ),
                        );
                      },
                    ).toList();
                    return Container(
                      width: size.width,
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(children: listWidget),
                    );
                  }
                  return Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: DbpColor().jendelaGray,
                      secondRingColor: DbpColor().jendelaGreen,
                      thirdRingColor: DbpColor().jendelaOrange,
                      size: 70.0,
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
