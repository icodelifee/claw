import 'package:cached_network_image/cached_network_image.dart';
import 'package:claw/common/extensions/cupertino_text_style.dart';
import 'package:claw/common/misc/reusables.dart';
import 'package:claw/common/models/post.dart';
import 'package:claw/di/injection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
    required this.post,
  });

  final Post post;

  void launchPage(String url) {
    final uri = Uri.parse(url);
    launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: border8,
      color: CupertinoColors.darkBackgroundGray,
      child: InkWell(
        customBorder: const RoundedRectangleBorder(borderRadius: border8),
        onTap: () => launchPage(post.url),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: border8,
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: post.title,
                          style: context.textStyleFromTheme.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              getIt<Logger>().d("PostItem", "Title tapped");
                            },
                        ),
                      ),
                      const SizedBox(height: 8),
                      _ScoreCommentsCountRow(
                        comments: post.commentCount,
                        score: post.score,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 24,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 4),
                          itemBuilder: ((context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: CupertinoTheme.of(context)
                                    .primaryColor
                                    .withAlpha((0.3 * 255).toInt()),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    post.tags[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoTheme.of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          itemCount: post.tags.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (post.description.isNotEmpty)
                        Flexible(
                          child: Text(
                            post.descriptionPlain,
                            style: const TextStyle(
                              fontSize: 12,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '$lobstersUrl/${post.submitterUser.avatarUrl}',
                                  placeholder: (context, url) => BoringAvatars(
                                    name: post.submitterUser.username,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      BoringAvatars(
                                          name: post.submitterUser.username),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 400),
                                  fadeInDuration:
                                      const Duration(milliseconds: 400),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            RichText(
                              text: TextSpan(
                                text: 'Submitted by ',
                                style: context.textStyleFromTheme
                                    .copyWith(fontSize: 12),
                                children: [
                                  TextSpan(
                                    style: context.textStyleFromTheme.copyWith(
                                      fontSize: 12,
                                      color: CupertinoTheme.of(context)
                                          .primaryColor
                                          .withAlpha((1 * 255).toInt()),
                                    ),
                                    text: post.submitterUser.username,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => launchPage(
                                          post.submitterUser.username),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreCommentsCountRow extends StatelessWidget {
  const _ScoreCommentsCountRow({
    Key? key,
    required this.comments,
    required this.score,
  }) : super(key: key);

  final int comments;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          CupertinoIcons.heart_fill,
          size: 12,
          color: CupertinoTheme.of(context).primaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          score.toString(),
          style: context.textStyleFromTheme.copyWith(
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          CupertinoIcons.chat_bubble_2_fill,
          size: 14,
          color: CupertinoTheme.of(context).primaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          comments.toString(),
          style: context.textStyleFromTheme.copyWith(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
