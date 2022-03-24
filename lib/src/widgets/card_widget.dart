import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

class CardWidget extends StatelessWidget {
 
 final List<dynamic> movies;

  const CardWidget({ this.movies});



  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;


    return Container(
    padding: EdgeInsets.only(top: 20.0),
   // width: _screensize.width * 0.9,
   // height: _screensize.height * 0.3,
    child: new Swiper(
      layout: SwiperLayout.STACK,
      itemWidth: _screenSize.width * 0.7,
          itemHeight: _screenSize.height * 0.5,
      itemBuilder: (BuildContext context, int index) {
        return new Image.network("http://via.placeholder.com/350x150",
            fit: BoxFit.fill);
      },

      itemCount: 3,

     //  pagination: new SwiperPagination(),

      control: new SwiperControl(),
    ),
  );
  }
}