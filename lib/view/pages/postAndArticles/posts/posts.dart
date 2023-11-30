import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:jendela_dbp/components/posts/errorCard.dart';
import 'package:jendela_dbp/components/posts/postCard.dart';
import 'package:jendela_dbp/components/posts/postNotFoundCard.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/postBloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/connectionCubit.dart';
import 'package:jendela_dbp/stateManagement/events/postEvent.dart';
import 'package:jendela_dbp/stateManagement/states/postState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Siaran',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        BlocBuilder<PostBloc, PostState>(
          bloc: latestPostBloc,
          builder: (context, data) {
            if (data is PostLoaded) {
              List<Post> posts = data.listOfPost?.toList() ?? [];
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
                  color: DbpColor().jendelaGray,
                  secondRingColor: DbpColor().jendelaGreen,
                  thirdRingColor: DbpColor().jendelaOrange,
                  size: 70.0,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
