import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/radio/youtube_radio_card.dart';
import 'package:jendela_dbp/hive/models/hive_radio_model.dart' as radio_model;

import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/components/radio/radio_card.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:jendela_dbp/stateManagement/blocs/media_bloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/radio_bloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/auth_cubit.dart';
import 'package:jendela_dbp/stateManagement/events/media_event.dart';
import 'package:jendela_dbp/stateManagement/events/radio_event.dart';
import 'package:jendela_dbp/stateManagement/states/media_state.dart';
import 'package:jendela_dbp/stateManagement/states/radio_state.dart';
import 'package:jendela_dbp/view/pages/all_radio_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key, required this.radio}) : super(key: key);

  final radio_model.Radio radio;

  @override
  // ignore: library_private_types_in_public_api
  _RadioScreen createState() => _RadioScreen();
}

class _RadioScreen extends State<RadioScreen> {
  RadioBloc relatedRadioBloc = RadioBloc();
  MediaBloc featuredMediaBloc = MediaBloc();
  late AuthCubit _authCubit;

  @override
  void initState() {
    relatedRadioBloc.add(RadioFetch());
    featuredMediaBloc.add(MediaFetchById(mediaId: widget.radio.featuredMedia));
    super.initState();
  }

  @override
  void dispose() {
    relatedRadioBloc.close();
    featuredMediaBloc.close();
    _authCubit.setHideNavigationBar(hideNavBar: false);
    super.dispose();
  }

  DbpColor colors = DbpColor();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _authCubit.setHideNavigationBar(hideNavBar: true);
    Uri uri = Uri.parse(
        widget.radio.guid?['rendered'] ?? "https://{GlobalVar.BaseURLDomain}");
    Map<String, dynamic> queryParam = uri.queryParameters
        .map((key, value) => MapEntry(key, value.toString()));
    queryParam.addAll({'_fromApp': 'y'});
    // return WebviewScaffold(
    //   url:
    //       Uri.parse(uri.origin).replace(queryParameters: queryParam).toString(),
    //   supportMultipleWindows: true,
    //   appBar: AppBar(
    //     elevation: 0,
    //     title: Text(
    //       widget.radio.title?['rendered'] ?? '',
    //       // textAlign: TextAlign.center,
    //       overflow: TextOverflow.ellipsis,
    //       maxLines: 1,
    //       style: TextStyle(
    //         fontSize: 20.0,
    //         color: Colors.black.withOpacity(0.7),
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     iconTheme: IconThemeData(color: Colors.black),
    //     backgroundColor: colors.bgPrimaryColor,
    //   ),
    //   withJavascript: true,
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.radio.title!['rendered'] ?? '',
            style: const TextStyle(color: Colors.black)),
      ),

      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<MediaBloc, MediaState>(
                bloc: featuredMediaBloc,
                builder: (context, state) {
                  if (state is MediaError) {
                    return Text(state.toString());
                  }
                  if (state is MediaLoaded) {
                    return Column(
                      children: [
                        SizedBox(
                          child: Align(
                            alignment: Alignment.center,
                            child: FittedBox(
                                fit: BoxFit.fill,
                                child: YoutubePlayerCardForRadio(
                                    radio: widget.radio,
                                    media: state.media ?? Media())),
                          ),
                        ),
                        // Container(
                        //   decoration: BoxDecoration(boxShadow: [
                        //     BoxShadow(
                        //       color: Colors.grey.withOpacity(0.5),
                        //       spreadRadius: 0.3,
                        //       blurRadius: 7,
                        //       offset: Offset(5, 5), // changes position of shadow
                        //     ),
                        //   ]),
                        //   width: size.width,
                        //   height: 200,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(5.0),
                        //     child: state.media == null
                        //         ? SizedBox(
                        //             // width: 200,
                        //             height: 100,
                        //           )
                        //         : Image.network(
                        //             state.media.getFullImage(),
                        //             // width: 200.0,
                        //             height: 100,
                        //             fit: BoxFit.cover,
                        //           ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          parse(widget.radio.title!['rendered'])
                              .documentElement!
                              .text,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: size.width,
                          child: Text(
                            DateFormat('d MMM yyyy, HH:mm')
                                .format(widget.radio.date ?? DateTime.now()),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 0.2,
                          height: 10,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          parse(widget.radio.content!['rendered']).body!.text,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 0.2,
                          height: 10,
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Lagi Menarik',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const AllRadioScreen(),
                                  );
                                },
                                child: const Text(
                                  'Lihat Semua',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 205, 204, 204)),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 220,
                          child: BlocBuilder<RadioBloc, RadioState>(
                            bloc: relatedRadioBloc,
                            builder: (context, data) {
                              if (data is RadioError) {
                                return Center(child: Text(data.toString()));
                              }
                              if (data is RadioLoaded) {
                                List<Widget> listWidget =
                                    data.radios!.map<Widget>(
                                  (item) {
                                    return RadioCard(
                                      radio: item,
                                      viewCount: 212,
                                      mediaHeight: 100,
                                      mediaWidth: 200,
                                    );
                                  },
                                ).toList();
                                if (listWidget.isEmpty) {
                                  return const Center(
                                    child: Text('Maaf, pautan tidak dijumpai.'),
                                  );
                                }
                                return ListView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: listWidget,
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
                        const SizedBox(height: 10.0),
                      ],
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
          )),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: colors.bgPrimaryColor,
      //   onPressed: () {},
      //   tooltip: 'Kongsi',
      //   child: Icon(
      //     CupertinoIcons.share,
      //     color: colors.textPrimaryColor,
      //   ),
      // ),
    );
  }
}
