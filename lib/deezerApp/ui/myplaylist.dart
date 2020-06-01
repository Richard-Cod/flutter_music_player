import 'package:flutter/material.dart';
import 'package:richardmusic/constants.dart';
import 'package:richardmusic/model/DeezerR.dart';
import 'package:richardmusic/network/DeezerNetwork.dart';
import 'songplaying.dart';

class MyPlaylist extends StatefulWidget {
  @override
  _MyPlaylistState createState() => _MyPlaylistState();
}

class _MyPlaylistState extends State<MyPlaylist> {
  Future _deezerR;
  DeezerNetwork _deezerNetwork = DeezerNetwork();
  Future _getList() async {
    return DeezerNetwork.getList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deezerR = _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: kBgColor,
          appBar: AppBar(
            backgroundColor: kBgColor,
            title: Text("Ma playlist"),
            centerTitle: true,
            actions: <Widget>[
              AppBarActions(
                icon: Icon(
                  Icons.search,
                  color: kSecondaryTextColor,
                ),
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              FutureBuilder(
                future:
                    _deezerR, // a previously-obtained Future<String> or null
                builder: (BuildContext context, snapshot) {
                  DeezerR value = snapshot.data;

                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.data.length,
                          itemBuilder: (context, index) => CardItem(
                                data: value.data[index],
                              )),
                    );
                  } else if (snapshot.hasError) {
                    return Column(
                      children: <Widget>[
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Error: ${snapshot.error}'),
                        )
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting result...'),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final Data data;

  CardItem({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SongPlaying(
                    song: Song.fromData(data),
                  )),
        );
      },
      child: Card(
        color: kSecondBgColor,
        elevation: 15.0,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage("${data.album.cover}"),
          ),
          title: Text(
            data.title,
            style: TextStyle(
              color: kPrimaryTextColor,
            ),
          ),
          subtitle: Text(
            "${data.artist.name}",
            style: TextStyle(
              color: kSecondaryTextColor,
            ),
          ),
          trailing: Text(
            "${(data.duration / 100).toString().replaceAll(".", ":")}",
            style: TextStyle(
              color: kSecondaryTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
