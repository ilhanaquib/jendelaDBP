import 'package:flutter/material.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:jendela_dbp/hive/models/hive_tv_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerCard extends StatelessWidget {
  const YoutubePlayerCard({super.key, required this.tv, required this.media});
  final Tv tv;
  final Media media;
  // YoutubePlayerController? _controller;

  @override
  Widget build(BuildContext context) {
    // _controller = YoutubePlayerController(
    //   initialVideoId: getVideoIdFromUrl(video.meta!.edbpYoutubeUrl),
    //   flags: YoutubePlayerFlags(
    //     autoPlay: true,
    //     mute: false,
    //   ),
    // );
    Size size = MediaQuery.maybeOf(context)!.size;
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.dataFromString(
          '<iframe style="width:100%;height:100%" src="https://www.youtube.com/embed/${getVideoIdFromUrl(tv.meta!.edbpYoutubeUrl)}?controls=1" frameborder="0"  allowfullscreen></iframe>',
          mimeType: 'text/html'));
    // return Container(
    //   color: Colors.black,
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadiusGeometry.lerp(
    //           BorderRadius.circular(1), BorderRadius.circular(1), 20)),
    // );
    return GestureDetector(
      onTap: () {
        // print('press');
        // Navigator.push(
        //     context,
        //     FlutterYoutube.playYoutubeVideoByUrl(
        //         apiKey: GlobalVar.YoutubeApiKey,
        //         videoUrl: this.video.meta == null
        //             ? ''
        //             : this.video.meta!.edbpYoutubeUrl,
        //         autoPlay: true, //default falase
        //         fullScreen: true //default false
        //         ));
      },
      child: Container(
        width: size.width,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.3,
            blurRadius: 7,
            offset: const Offset(5, 5), // changes position of shadow
          ),
        ]),
        //   child: Stack(
        //     alignment: Alignment.center,
        //     children: [
        //       Row(
        //         children: [
        //           Expanded(
        //             child: ClipRRect(
        //               borderRadius: BorderRadius.circular(5.0),
        //               child: Image.network(
        //                 this.media.getMediumImage() ?? '',
        //                 // height: 200,
        //                 fit: BoxFit.cover,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       Row(children: [
        //         Expanded(
        //             child: Icon(Icons.play_arrow_rounded,
        //                 color: Colors.white, size: 60))
        //       ]),
        //     ],
        //   ),
        // ),
        child: Column(
          children: [
            Container(
              color: const Color(0xFF0E3311).withOpacity(0.1),
              width: size.width,
              height: 200,
              child: Center(
                child: WebViewWidget(
                  controller: controller,
                ),
              ),
            )
            // YoutubePlayer(
            //   controller:
            //       _controller ?? YoutubePlayerController(initialVideoId: ''),
            //   showVideoProgressIndicator: true,
            //   progressIndicatorColor: Colors.amber,
            //   onReady: () {
            //     _controller!.addListener(() {
            //       print('listen');
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  String getVideoIdFromUrl(url) {
    String path = Uri.parse(url).pathSegments[0];
    if (path == 'watch') {
      return Uri.parse(url).queryParameters['v'] ?? '';
    }
    return path;
  }
}
