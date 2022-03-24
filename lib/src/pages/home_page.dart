import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movies_model.dart';
import 'package:movies_app/src/Utils/movies_utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: Colors.blue[200],
        body: Container(
          padding: EdgeInsetsDirectional.only(top: 52),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Hello, what do you want to watch?',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    _inputSearch()
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                height: queryData.size.height - 287,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'RECOMMENDED FOR YOU',
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            Text('See All',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: queryData.size.height - 600,
                        child: _Listmovies(context, 'top'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'TOP RATED',
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            Text('See All',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: queryData.size.height - 600,
                        child: _Listmovies(context, ''),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

Widget _inputSearch() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.white24),
    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
    //padding: EdgeInsets.symmetric(vertical: 30),
    height: 45,
    // color: Colors.black38,
    child: TextField(
      textAlign: TextAlign.justify,
      style: TextStyle(color: Colors.black),
      autofocus: false,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          //counter: Text('data 0'),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          hintText: 'Buscar',
          suffixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          border: null),
    ),
  );
}

Widget _Listmovies(context, type) {
  MediaQueryData queryData;
  queryData = MediaQuery.of(context);
  MoviesProvider movies = new MoviesProvider();
  return FutureBuilder(
    future: type == 'top' ? movies.getPopulares() : movies.getMovies(),
    initialData: [],
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active:
          return Container();
        case ConnectionState.waiting:
          return CircularProgressIndicator();
        case ConnectionState.none:
          return Center(
            child: Text("Don`t found movies."),
          );
        case ConnectionState.done:
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _cardMovies(snapshot.data),
            ),
          );
      }
    },
  );
}

List<Widget> _cardMovies(List<Movie> snapshot) {
  List<Widget> movies = [];

  snapshot.forEach((element) {
    final temp = Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            'https://image.tmdb.org/t/p/original' + element.backdropPath,
            fit: BoxFit.cover,
            height: 150,
            width: 120,
          ),
        ),
        Text(
          element.title,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        SmoothStarRating(
          rating: element.voteAverage / 2,
          isReadOnly: false,
          size: 25,
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          defaultIconData: Icons.star_border,
          starCount: 5,
          allowHalfRating: true,
          spacing: 2.0,
          color: Colors.yellow,
        )
      ],
    );
    movies
      ..add(temp)
      ..add(SizedBox(
        width: 15,
      ));
  });
  return movies;
}
