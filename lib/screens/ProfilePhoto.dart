import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:souqnagran/classes/CityClass.dart';
import 'package:souqnagran/screens/signin.dart';

import '../FragmentSouqNajran.dart';

class ProfilePhoto extends StatefulWidget {
  List<String> imageUrls;
  ProfilePhoto(this.imageUrls);
  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
              //color: Colors.grey[200],
//          width: 300,
//          height: 200,
              child: widget.imageUrls == null
                  ? SpinKitThreeBounce(
                      size: 35,
                      color: const Color(0xff171732),
                    )
                  : Swiper(
                      loop: true,
                      duration: 1000,
                      autoplay: true,
                      autoplayDelay: 15000,
                      itemCount: widget.imageUrls.length,
                      pagination: new SwiperPagination(
                        margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        builder: new DotSwiperPaginationBuilder(
                            color: Colors.grey,
                            activeColor: const Color(0xff171732),
                            size: 8.0,
                            activeSize: 8.0),
                      ),
                      control: new SwiperControl(),
                      viewportFraction: 1,
                      scale: 0.1,
                      outer: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(widget.imageUrls[index],
                            fit: BoxFit.contain, loadingBuilder:
                                (BuildContext context, Widget child,
                                    ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SpinKitThreeBounce(
                            color: const Color(0xff171732),
                            size: 35,
                          );
                        });
                      },
                    )),
          Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 65.0,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: 20,
                    height: 20,
                    child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                  ),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff171732),
                ),
              ),
              Transform.translate(
                offset: Offset(0.0, -42.0),
                child:
                // Adobe XD layer: 'logoBox' (shape)
                Center(
                  child: Container(
                    width: 166.0,
                    height: 60.0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'بوابة نجران',
                        style: TextStyle(
                          fontFamily: 'Estedad-Black',
                          fontSize: 40,
                          color: const Color(0xffffffff),
                          height: 0.7471466064453125,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: const Color(0xff171732),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
