import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:jendela_dbp/components/posts/errorCard.dart';
import 'package:jendela_dbp/components/posts/postCard.dart';
import 'package:jendela_dbp/components/posts/postNotFoundCard.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/postBloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/connectionCubit.dart';
import 'package:jendela_dbp/stateManagement/events/postEvent.dart';
import 'package:jendela_dbp/stateManagement/states/postState.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final ScrollController scrollController = ScrollController();
  PostBloc latestPostBloc = PostBloc();
  ConnectionCubit connectionCubit = ConnectionCubit();

  @override
  void initState() {
    latestPostBloc.add(PostFetch());
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
        title: TextButton(
          onPressed: () {
            scrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
          child: const Text(
            'Posts',
            style: TextStyle(
                color: Colors.black,
                fontSize: 21,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          connectionCubit.checkConnection(context);
          latestPostBloc.add(PostFetch());
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            const SliverAppBar(
              floating: true,
              snap: true,
              elevation: 0.0,
              toolbarHeight: 0.01,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
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
                        return ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
