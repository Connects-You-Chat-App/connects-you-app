import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/message.dart';
import '../../../controllers/auth_controller.dart';
import 'message_bubble_config.dart';

class ChatBubble extends GetView<AuthController> {
  const ChatBubble({required this.messageConfig, super.key});

  final MessageBubbleConfig messageConfig;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    print(
        'id: ${messageConfig.message.id}, isMine: ${messageConfig.isMine}, isGroupFirst: ${messageConfig.isGroupFirst}, isGroupLast: ${messageConfig.isGroupLast}, isDaysFirst: ${messageConfig.isDaysFirst}');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (messageConfig.isDaysFirst)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              messageConfig.message.createdAt.toLocal().toString(),
              // TODO: Format date
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 12.0,
              ),
            ),
          ),
        Container(
          width: mediaQuery.size.width,
          color: theme.colorScheme.secondaryContainer,
          child: FractionallySizedBox(
            alignment: messageConfig.messageAlignment,
            widthFactor: 0.85,
            child: Align(
              alignment: messageConfig.messageAlignment,
              child: Stack(
                children: [
                  if (!messageConfig.isMine &&
                      messageConfig.isGroupFirst &&
                      messageConfig.message.senderUser?.photoUrl != null)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 16.0,
                          backgroundImage: NetworkImage(
                            messageConfig.message.senderUser?.photoUrl ?? '',
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        left: messageConfig.isMine ? 0 : 48.0,
                        right: messageConfig.isMine ? 12.0 : 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                          messageConfig.isGroupFirst ? 24.0 : 12.0,
                        ),
                        topLeft: Radius.circular(
                          messageConfig.isGroupFirst ? 24.0 : 12.0,
                        ),
                        bottomLeft: Radius.circular(
                          messageConfig.isGroupLast ? 24.0 : 12.0,
                        ),
                        bottomRight: Radius.circular(
                          messageConfig.isGroupLast ? 24.0 : 12.0,
                        ),
                      ),
                      child: BubbleBackground(
                        colors: [
                          if (messageConfig.isMine) ...const <Color>[
                            Color(0xFF19B7FF),
                            Color(0xFF491CCB),
                          ] else ...const <Color>[
                            Color(0xFF6C7689),
                            Color(0xFF3A364B),
                          ],
                        ],
                        child: DefaultTextStyle.merge(
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  messageConfig.message.message,
                                ),
                                if (messageConfig.isMine)
                                  if (messageConfig.isRead)
                                    const Icon(
                                      Icons.done_all,
                                      color: Colors.greenAccent,
                                      size: 16.0,
                                    )
                                  else if (messageConfig.isDelivered)
                                    const Icon(
                                      Icons.done_all,
                                      color: Colors.white,
                                      size: 16.0,
                                    )
                                  else if (messageConfig.message.status ==
                                      MessageStatus.SENT)
                                    const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 16.0,
                                    )
                                  else if (messageConfig.message.status ==
                                      MessageStatus.PENDING)
                                    const Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BubbleBackground extends StatelessWidget {
  const BubbleBackground({
    required this.colors,
    super.key,
    this.child,
  });

  final List<Color> colors;
  final Widget? child;

  @override
  Widget build(final BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        scrollable: Scrollable.of(context),
        bubbleContext: context,
        colors: colors,
      ),
      child: child,
    );
  }
}

class BubblePainter extends CustomPainter {
  BubblePainter({
    required final ScrollableState scrollable,
    required final BuildContext bubbleContext,
    required final List<Color> colors,
  })  : _scrollable = scrollable,
        _bubbleContext = bubbleContext,
        _colors = colors,
        super(repaint: scrollable.position);

  final ScrollableState _scrollable;
  final BuildContext _bubbleContext;
  final List<Color> _colors;

  @override
  void paint(final Canvas canvas, final Size size) {
    final RenderBox scrollableBox =
        _scrollable.context.findRenderObject()! as RenderBox;
    final ui.Rect scrollableRect = Offset.zero & scrollableBox.size;
    final RenderBox bubbleBox = _bubbleContext.findRenderObject()! as RenderBox;

    final ui.Offset origin =
        bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    final ui.Paint paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        _colors,
        [0.0, 1.0],
        TileMode.clamp,
        Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
      );
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(final BubblePainter oldDelegate) {
    return oldDelegate._scrollable != _scrollable ||
        oldDelegate._bubbleContext != _bubbleContext ||
        oldDelegate._colors != _colors;
  }
}
