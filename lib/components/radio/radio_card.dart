import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:jendela_dbp/hive/models/hive_radio_category_model.dart';
import 'package:jendela_dbp/hive/models/hive_radio_model.dart' as radio_model;
import 'package:jendela_dbp/stateManagement/blocs/media_bloc.dart';
import 'package:jendela_dbp/stateManagement/events/media_event.dart';
import 'package:jendela_dbp/stateManagement/states/media_state.dart';
import 'package:jendela_dbp/view/pages/radio_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RadioCard extends StatefulWidget {
  const RadioCard({
    Key? key,
    this.viewCount = 0,
    this.mediaHeight = 100.0,
    this.mediaWidth = 250.00,
    this.titleColor,
    required this.radio,
  }) : super(key: key);

  final int viewCount;
  final radio_model.Radio radio;
  final double mediaHeight;
  final double mediaWidth;
  final Color? titleColor;
  @override
  // ignore: library_private_types_in_public_api
  _RadioCard createState() => _RadioCard();
}

class _RadioCard extends State<RadioCard> {
  Future<Media?>? media;
  Future<RadioCategory>? videoCategory;
  MediaBloc radioMediaBloc = MediaBloc();
  @override
  void initState() {
    radioMediaBloc.add(MediaFetchById(mediaId: widget.radio.featuredMedia));
    // videoBloc.add(VideoCategoriesFetch());
    media = widget.radio.getFeaturedMedia();
    super.initState();
  }

  @override
  void dispose() {
    radioMediaBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.maybeOf(context).size;
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RadioScreen(radio: widget.radio)),
          );
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocBuilder<MediaBloc, MediaState>(
                bloc: radioMediaBloc,
                builder: (context, data) {
                  if (data is MediaError) {
                    return Center(child: Text(data.toString()));
                  }
                  if (data is MediaLoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: data.media == null
                              ? SizedBox(
                                  width: widget.mediaWidth,
                                  height: widget.mediaHeight,
                                )
                              : AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    data.media!.getMediumImage() ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          parse(widget.radio.title!['rendered'])
                              .documentElement!
                              .text,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: widget.titleColor ?? Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat('d MMM yyyy')
                              .format(widget.radio.date ?? DateTime.now()),
                          style: const TextStyle(
                              color: Colors.white,
                              textBaseline: TextBaseline.alphabetic),
                        ),
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
          ],
        ),
      ),
    );
  }
}
