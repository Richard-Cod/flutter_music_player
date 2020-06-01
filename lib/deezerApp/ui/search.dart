import 'package:flutter/material.dart';
import 'package:richardmusic/constants.dart';
import 'package:richardmusic/model/DeezerR.dart';
import 'package:richardmusic/network/DeezerNetwork.dart';
import 'songplaying.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future _deezerR;
  DeezerNetwork _deezerNetwork = DeezerNetwork();
  bool _firstTime = true;
  Future _search(q) async {
    return DeezerNetwork.search(q);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: kBgColor,
//          appBar: AppBar(
//            backgroundColor: kBgColor,
//            title: Text("Recherche "),
//            centerTitle: true,
//          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                TextFormField(
                  onFieldSubmitted: (value) {
                    setState(() {
                      _deezerR = _search(value);
                    });
                    print(value);
                  },
                  style: TextStyle(color: kPrimaryTextColor),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: kSecondaryTextColor),
                    suffixIcon: Icon(
                      Icons.settings_input_svideo,
                      color: Colors.purple,
                    ),
                    hintText: 'Titre , artiste , etc ...',
                  ),
                  textAlign: TextAlign.center,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Le champ est vide';
                    }
                    return null;
                  },
                ),
                FutureBuilder(
                  future:
                      _deezerR, // a previously-obtained Future<String> or null
                  builder: (BuildContext context, snapshot) {
                    DeezerR value = snapshot.data;

                    if (snapshot.hasData) {
                      if (value.data == null) {
                        print("no data");
                        return Expanded(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Aucun résultat ",
                                  style: TextStyle(
                                    color: kPrimaryTextColor,
                                    fontSize: 40.0,
                                  ),
                                ),
                                Icon(
                                  Icons.not_interested,
                                  color: Colors.purple,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
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
                      if (_firstTime) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            child: Center(
                              child: Icon(
                                Icons.search,
                                color: Colors.purple,
                                size: 200,
                              ),
                            ),
                          ),
                        );
                      }
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
