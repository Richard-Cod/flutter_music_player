import 'package:flutter/material.dart';
import 'package:richardmusic/constants.dart';
import 'songplaying.dart';

class MyPlaylist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: kBgColor,
            appBar: AppBar(
              backgroundColor: kBgColor,
              title: Text("My Playlist"),
              centerTitle: true,
            ),
            body: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, d) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SongPlaying()),
                        );
                      },
                      child: Card(
                        color: kSecondBgColor,
                        elevation: 15.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gettyimages-1172315172.jpg?crop=1.00xw:0.735xh;0,0.0512xh&resize=480:*"),
                          ),
                          title: Text(
                            "Toosie Slide",
                            style: TextStyle(
                              color: kPrimaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            "Drake",
                            style: TextStyle(
                              color: kSecondaryTextColor,
                            ),
                          ),
                          trailing: Text(
                            "4:07",
                            style: TextStyle(
                              color: kSecondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ))),
      ),
    );
  }
}
