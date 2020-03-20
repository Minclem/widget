import 'package:flutter/material.dart';
import 'package:widgets/widgets/message_notification.dart';

class MessageNotificationPage extends StatelessWidget {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Demo'),
      ),
      body: GestureDetector(
        onTap: () {
          count += 1;
          MessageNotice.show(context, MessageNoticeOptions(
            clearance: 0,
            position: 'center',
            message: '你收到 $count 条消息',
            note: 'haskfv卡刷饭卡不舒服啦少部分拉萨办法啦部分拉萨部分拉萨部分拉萨办法啦不舒服haskfv卡刷饭卡不舒服啦少部分拉萨办法啦部分拉萨部分拉萨部分拉萨办法啦不舒服',
            avatar: NetworkImage('http://stage.meitudata.com/xiuxiu-photo/dWyAjlytaG67GG532eLFBmAWX18zG.jpg'),
            noteLen: 1,
            avatarIcon: Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.live_tv, size: 5, color: Colors.redAccent,),
            ),
          ));
        },
        child: Container(width: double.infinity, height: 50.0, color: Colors.blueAccent),
      ),
    );
  }
}