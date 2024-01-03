import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/tv/tv_card.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/stateManagement/blocs/tv_bloc.dart';
import 'package:jendela_dbp/stateManagement/events/tv_event.dart';
import 'package:jendela_dbp/stateManagement/states/tv_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AllTvScreen extends StatefulWidget {
 const AllTvScreen({
    Key? key,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _AllTvScreen createState() => _AllTvScreen();
}

class _AllTvScreen extends State<AllTvScreen> {
  TvBloc tvBloc = TvBloc();
  final _scrollController = ScrollController();
  final int _perPage = 25;
  @override
  void initState() {
    super.initState();
    tvBloc.add(TvFetch(perPage: _perPage));
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        tvBloc.add(VideoFetchMore(perPage: _perPage));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    tvBloc.close();
    super.dispose();
  }

  DbpColor colors = DbpColor();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
    return Scaffold(
      backgroundColor: DbpColor().jendelaGreenBlue,
      appBar: AppBar(
        backgroundColor: DbpColor().jendelaGreenBlue,
        centerTitle: true,
        title:
            const Text('TV DBP', style:  TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        child: SizedBox(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: BlocBuilder<TvBloc, TvState>(
              bloc: tvBloc,
              builder: (context, state) {
                if (state is TvError) {
                  return Text(state.toString());
                }
                if (state is TvLoaded) {
                  List<Widget> listWidget = state.tv!.map<Widget>(
                    (item) {
                      return TvCard(
                        tv: item,
                        viewCount: 201,
                      );
                    },
                  ).toList();
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    child: Column(children: listWidget),
                  );
                }
                return SizedBox(
                  height: size.height,
                  child: Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: DbpColor().jendelaGray,
                      secondRingColor: DbpColor().jendelaGreen,
                      thirdRingColor: DbpColor().jendelaOrange,
                      size: 70.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
