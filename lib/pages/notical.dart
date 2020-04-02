import 'package:flutter/material.dart';
import 'package:widgets/widgets/message_notification.dart';

class MessageNotificationPage extends StatefulWidget {
  @override
  _MessageNotificationPageState createState() =>
      _MessageNotificationPageState();
}

class _MessageNotificationPageState extends State<MessageNotificationPage> {
  int count = 0;

  @override
  void dispose() {
    MessageNotice.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Demo'),
      ),
      body: GestureDetector(
        onTap: () {
          count += 1;

          MessageNotice.show(
              context,
              MessageNoticeOptions(
                position: 'center',
                message: '你收到 $count 条消息',
                note:
                    'haskfv卡刷饭卡不舒服啦少部分拉萨办法啦部分拉萨部分拉萨部分拉萨办法啦不舒服haskfv卡刷饭卡不舒服啦少部分拉萨办法啦部分拉萨部分拉萨部分拉萨办法啦不舒服',
                avatar: NetworkImage(
                    'https://mvimg10.meitudata.com/5e82e7a403a5ewgw0fx4dv7873.jpg!thumb320'),
                noteLen: 1,
                avatarIcon: Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.live_tv,
                    size: 5,
                    color: Colors.redAccent,
                  ),
                ),
              ));
        },
        child: Center(
          child: Chip(
            backgroundColor: Colors.blue,
            avatar: CircleAvatar(
              child: Icon(
                Icons.message,
                color: Colors.blue,
                size: 15,
              ),
              // backgroundImage: AssetImage('assets/images/img-6.jpeg'),
              backgroundColor: Colors.white,
            ),
            label: Text(
              '哈哈哈哈',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
