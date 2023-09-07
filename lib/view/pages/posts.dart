import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/posts/errorCard.dart';
import 'package:jendela_dbp/components/posts/postCard.dart';
import 'package:jendela_dbp/components/posts/postNotFoundCard.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/postBloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/connectionCubit.dart';
import 'package:jendela_dbp/stateManagement/events/postEvent.dart';
import 'package:jendela_dbp/stateManagement/states/postState.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'dart:math';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> with TickerProviderStateMixin {
  //-----custom refresh indicator----

  static const _circleSize = 70.0;

  static const _defaultShadow = [
    BoxShadow(blurRadius: 10, color: Colors.black26)
  ];

  double _progress = 0.0;

  late AnimationController _controller;

  //-----custom refresh indicator----
  PostBloc latestPostBloc = PostBloc();
  ConnectionCubit connectionCubit = ConnectionCubit();

  void _handleRefresh() async {
    connectionCubit.checkConnection(context);
    latestPostBloc.add(PostFetch());
    return null;
  }

  @override
  void initState() {
    latestPostBloc.add(PostFetch());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Set the duration as needed
    );
    super.initState();
  }

  @override
  void dispose() {
    latestPostBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Posts'),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0.0,
            toolbarHeight: 0.01,
          ),
          SliverFillRemaining(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  connectionCubit.checkConnection(context);
                  latestPostBloc.add(PostFetch());
                },
                child: _latestPostWidget(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _latestPostWidget(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0.0,
          toolbarHeight: 0.01,
        ),
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                BlocBuilder<PostBloc, PostState>(
                  bloc: latestPostBloc,
                  builder: (context, data) {
                    if (data is PostLoaded) {
                      List<Post> posts =
                          data.listOfPost?.take(10).toList() ?? [];
                      if (posts.isEmpty) {
                        return const SizedBox(
                          height: 300,
                          child: Center(
                            child: PostNotFoundCard(),
                          ),
                        );
                      }
                      return GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 8.0,
                        children: List.generate(
                          posts.length,
                          (index) => PostCard(
                            post: posts[index],
                          ),
                        ),
                      );
                    }
                    if (data is PostError) {
                      return ErrorCard(
                        message: data.message ?? '',
                      );
                    }
                    return SizedBox(
                      height: 300,
                      child: Center(
                        child: LoadingAnimationWidget.discreteCircle(
                          color: const Color.fromARGB(255, 123, 123, 123),
                          secondRingColor:
                              const Color.fromARGB(255, 144, 191, 63),
                          thirdRingColor:
                              const Color.fromARGB(255, 235, 127, 35),
                          size: 70.0,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BookPainter extends CustomPainter {
  final Color strokeColor;
  final double progress;

  BookPainter({
    required this.strokeColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final double maxAngle = pi / 6; // Maximum angle for book closing
    final double angle = maxAngle * progress;
    final double offsetX = 20.0 * progress; // Offset for book closing

    final Path path = Path()
      ..moveTo(offsetX, size.height)
      ..lineTo(offsetX, 0)
      ..quadraticBezierTo(size.width * 0.5, -40, size.width - offsetX, 0)
      ..lineTo(size.width - offsetX, size.height)
      ..close();

    // Rotate the path to simulate book closing
    final Matrix4 matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // Perspective
      ..rotateX(angle);
    path.transform(matrix.storage);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
