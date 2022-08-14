import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:forypldbauth/model/appuser.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../values/credentials.dart';

class SendEmailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SendEmailScreenState();
}

class _SendEmailScreenState extends State<SendEmailScreen>{

  String btnText;
  Combination combinationCurrent;

  Future<List<Appuser>> _getFriendAcceptedRequests(String idUser) async {
    var result = await fetchFriendsAcceptedRequest(idUser);
    return result;
  }

  @override
  Widget build(BuildContext context) {

    final Map args = ModalRoute.of(context).settings.arguments as Map;
    if (args != null) {
      combinationCurrent = args['combination'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Send email to...'),
        backgroundColor: Colors.amberAccent,
      ),
      body: FutureBuilder(
          future: _getFriendAcceptedRequests(context.read(userLogged).state.uid),
          builder: (ctx, snapshot){
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasData == null) {
              return Container(child: Center(child: Text('searching for accepted requests'),),);
            }else{
              List<Appuser> list = snapshot.data;
              if (snapshot.data == null ||list.length == 0) {return Center(child: Text('no accepted requests'),);}
              else{
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {

                    Appuser elementResult = snapshot.data[index];
                    return EmailCard(friend: elementResult, idCombination: combinationCurrent.idCombination,);
                  },
                );
              }
            }
          }
      ),
    );
  }
}

class EmailCard extends StatefulWidget {
  final Appuser friend;
  final int idCombination;

  EmailCard({Key key, this.friend, this.idCombination}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmailCardState();
}

class _EmailCardState extends State<EmailCard>{
  String btnText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: new Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: new EdgeInsets.all(20.0),
                child: Text('${widget.friend.name}', style: TextStyle(color: Colors.indigo, fontSize: 16),),
              ),

              FlatButton(
                  child: Text(btnText==null ? 'send': btnText, style: TextStyle(color: Colors.indigo),),
                  onPressed: () async{
                    final smtpServer = gmail(usernameSmtpServer, passwordSmtpServer);
                    final message = Message()
                      ..from = Address(usernameSmtpServer, 'YPL')
                      ..recipients.add(widget.friend.email)
                      ..subject = 'YPL please rate friend combination'
                      ..text = 'Hello! Please rate my combination at this link: http://deeplink.flutter.dev/${widget.idCombination}';

                    try {
                      final sendReport = await send(message, smtpServer);
                      print('Message sent: ' + sendReport.toString());
                      setState(() {btnText = 'sent';});
                    } on MailerException catch (e) {
                      print('Message not sent.');
                      for (var p in e.problems) {
                        print('Problem: ${p.code}: ${p.msg}');
                      }
                    }
                  })
            ],)
      ),
      onTap: (){
      },
    );
  }
}