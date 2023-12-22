import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/components/tv/tv_screen.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:jendela_dbp/hive/models/hive_tv_category_model.dart';
import 'package:jendela_dbp/hive/models/hive_tv_model.dart';
import 'package:jendela_dbp/stateManagement/blocs/media_bloc.dart';
import 'package:jendela_dbp/stateManagement/events/media_event.dart';
import 'package:jendela_dbp/stateManagement/states/media_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TvCard extends StatefulWidget {
  const TvCard({
    Key? key,
    this.viewCount = 0,
    required this.tv,
  }) : super(key: key);

  // id: item.id,
  // title: item.title['rendered'],
  // body: item.content['rendered'],
  // href: item.links['self'][0]['href'].toString(),

  final int viewCount;
  final Tv tv;
  @override
  // ignore: library_private_types_in_public_api
  _VideoCard createState() => _VideoCard();
}

class _VideoCard extends State<TvCard> {
  Future<Media?>? media;
  Future<TvCategory?>? videoCategory;
  MediaBloc tvMediaBloc = MediaBloc();
  @override
  void initState() {
    tvMediaBloc.add(MediaFetchById(mediaId: widget.tv.featuredMedia));
    // videoBloc.add(VideoCategoriesFetch());
    media = widget.tv.getFeaturedMedia();
    super.initState();
  }

  @override
  void dispose() {
    tvMediaBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TvScreen(tv: widget.tv)),
            );
          },
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<MediaBloc, MediaState>(
                bloc: tvMediaBloc,
                builder: (context, data) {
                  if (data is MediaError) {
                    return Text(data.toString());
                  }
                  if (data is MediaLoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: data.media == null
                              ? const SizedBox()
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
                          parse(widget.tv.title!['rendered'])
                              .documentElement!
                              .text,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat('d MMM yyyy')
                              .format(widget.tv.date ?? DateTime.now()),
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
          )),
    );
  }
}
