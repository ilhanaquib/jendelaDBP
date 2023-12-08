import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:jendela_dbp/components/posts/error_card.dart';
import 'package:jendela_dbp/components/posts/post_card.dart';
import 'package:jendela_dbp/components/posts/post_not_found_card.dart';
import 'package:jendela_dbp/hive/models/hive_post_model.dart';
import 'package:jendela_dbp/stateManagement/blocs/post_bloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/connection_cubit.dart';
import 'package:jendela_dbp/stateManagement/events/post_event.dart';
import 'package:jendela_dbp/stateManagement/states/post_state.dart';

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
