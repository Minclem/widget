import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class MessageNoticeOptions {
    String message; // 提示信息
    String note;    // 描述内容
    Widget child;   // 弹框内容 
    Widget avatarIcon; // 头像右下角小图标

    Function onShow;  // 显示回调
    Function onHide;  // 隐藏回调

    int duration;     // 动画时长
    int timeout;      // 隐藏时间
    int noteLen;      // 描述内容显示行数

    Color bgColor;    // 背景色
    EdgeInsets padding; // 内边距
    int borderRadius;   // 圆角
    ImageProvider avatar; // 需要显示在左侧的头像
    CrossAxisAlignment crossAxisAlignment;  // 提示信息水平对齐方式

    double clearance;  // 左右间距

    /// [ top or buttom ]
    String position;  // 弹出位置

    MessageNoticeOptions({
      this.message,
      this.note,
      this.avatar,
      this.child,
      this.onShow,
      this.onHide,
      this.position,
      this.clearance,
      this.avatarIcon,
      this.noteLen = 2,
      this.duration = 300,
      this.timeout = 2500,
      this.borderRadius = 12,
      this.bgColor = const Color(0xffc2aaff),
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.padding = const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
    });
  }

/// 消息提示
class MessageNotice {
  static OverlayEntry _overlayEntry;
  static Function _onHide;
  static List<OverlayEntry> messageQueue = [];
  static GlobalKey<MessageNoticeState> noticeKeys = GlobalKey<MessageNoticeState>();

  static void show(
    BuildContext context,
    MessageNoticeOptions options
  ) async {

    void _show () {
      noticeKeys.currentState.show(options);
    }

    // 不进行重复创建，如果已经存在弹框则直接进行覆盖显示
    if (_overlayEntry == null) {
      OverlayState overlayState = Overlay.of(context);

      _overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return MessageNoticeElement(key: noticeKeys);
      });

      overlayState.insert(_overlayEntry);

      // 需要延迟确保创建组件完成后再进行显示
      Timer(Duration(milliseconds: 10), _show);
    } else {
      _show();
    }
  }

  // 关闭弹框
  static void close() async {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (_onHide != null) {
      _onHide();
    }
  }
}

/// 弹框模版组件
class MessageNoticeElement extends StatefulWidget {
  MessageNoticeElement({
    Key key,
  }) :super(key: key);

  @override
  MessageNoticeState createState() => MessageNoticeState();
}

class MessageNoticeState extends State<MessageNoticeElement> with SingleTickerProviderStateMixin {
  static MediaQueryData mediaQuery =  MediaQueryData.fromWindow(window);
  static MessageNoticeOptions _options = MessageNoticeOptions();
  static Timer _timer;

  Animation<Offset> animation;
  Animation<double> _animation;
  AnimationController animationController;

  @override
  initState() {
    super.initState();

    animationController = AnimationController(
      duration: Duration(milliseconds: _options.duration),
      vsync: this,
      value: 0,
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          if (_options.onHide != null) {
            _options.onHide();
          }
        } else if (status == AnimationStatus.completed) {
          if (_options.onShow != null) {
            _options.onShow();
          }
        }
      });

    _animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInCubic,
    );

    // 初始化时进行隐藏
    animation = Tween(begin: Offset(0, -2.5), end: Offset(0, -2.5)).animate(_animation);
  }

  @override
  void dispose() {
    directClosure();
    super.dispose();
  }

  /// 显示消息提示
  void show(MessageNoticeOptions options) {
    if (options.message == null && options.note == null && options.child == null) {
      options.message = '您收到一条消息';
    }

    if (options.position != 'top' && options.position != 'bottom') {
      options.position = 'top';
    }

    bool isTop = options.position == 'top';

    animation = Tween(
      begin: isTop ? Offset(0, -2.5) : Offset(0, 2.5),
      end: Offset(0, 0)
    ).animate(_animation);

    setState(() {
      _options = options;
    });

    animationController.forward();
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: _options.timeout), hide);
  }

  /// 关闭消息提示
  void hide() {
    animationController.reverse();
  }

  /// 直接关闭
  void directClosure () {
    _timer?.cancel();
    animationController.dispose();
    _animation = null;
    animation = null;
  }

  double $rem (num n) {
    return mediaQuery.size.width / 375 * n;
  }

  // 头像
  Widget buildAvatar() {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.all($rem(1)),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.4), shape: BoxShape.circle),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: $rem(18),
            backgroundColor: Color(0xfff7f7f7),
            backgroundImage: _options.avatar,
          ),
          if (_options.avatarIcon != null)
            Positioned(
              top: $rem(24),
              left: $rem(24),
              child: _options.avatarIcon,
            ),
        ],
      ),
    );
  }

  // 消息主体
  Widget buildTextContainer () {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (_options.message != null)
              Text(
                _options.message ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: $rem(16),
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  height: 22 / 16,
                ),
              ),
            if (_options.note != null)
              Text(
                _options.note,
                overflow: TextOverflow.ellipsis,
                maxLines: _options.noteLen,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: $rem(13),
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  height: 22 / 16,
                ),
              ),
          ],
          crossAxisAlignment: _options.crossAxisAlignment,
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: _options.avatar != null ? $rem(280) : $rem(325),
        maxHeight: $rem(400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top:  _options.position == 'top' ? mediaQuery.padding.top : null,
      bottom:  _options.position == 'bottom' ? mediaQuery.padding.bottom : null,
      left: $rem(_options.clearance ?? 8),
      child: GestureDetector(
        onTap: () {
          hide();
        },
        child: SlideTransition(
          position: animation,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  child: _options.child ?? Row(
                    children: <Widget>[
                      if (_options.avatar != null)
                        buildAvatar(),
                      buildTextContainer(),
                    ],
                  ),
                  constraints: BoxConstraints(
                    maxWidth: $rem(375 - (_options.clearance * 2)),
                    maxHeight: mediaQuery.size.height / 2,
                  ),
                  padding: _options.padding,
                  decoration: BoxDecoration(
                    color: _options.bgColor,
                    borderRadius: BorderRadius.circular($rem(_options.borderRadius)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}