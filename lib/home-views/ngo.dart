import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:domestic_violence/home-views/emer_contact.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:domestic_violence/home-views/ngo_details.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domestic_violence/classes/language.dart';
import 'package:domestic_violence/localization/language_constants.dart';
import 'package:domestic_violence/main.dart';

class NGO extends StatefulWidget {
  @override
  _NGOState createState() => _NGOState();
}

_makingPhoneCall(num) async {
  var number=num.toString();
  var url = 'tel'+ number;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _NGOState extends State<NGO> {

  final CategoriesScroller categoriesScroller=CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  List<Widget> itemsData=[];

  void getPostsData() {
    List<dynamic> responseList = emer_cont;
    List<Widget> listItems = [];
    responseList.forEach((post){
    listItems.add(Container(
      height:150,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(20.0)
                ),
            gradient:LinearGradient(
                colors:[Colors.white,primaryColor],
                begin:Alignment.topLeft,
                end:Alignment.bottomRight
            ),
            boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: 10.0),
                ]
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Text(
                            post["title"],
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.call),
                                onPressed: (){
                                  _makingPhoneCall(post["contact"]);
                                } ,
                              ),
                              Text(
                                "${post["contact"]}",
                                style: const TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                              ),

                            ],
                          )

                      ],
                  ),

              ],
            ),
      )));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.40;
    return Scaffold(
        appBar:AppBar(
          title:Text(getTranslated(context, 'ngo-details')),
          backgroundColor: primaryColor,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<Language>(
                underline: SizedBox(),
                icon: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                onChanged: (Language language) {
                  _changeLanguage(language);
                },
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>(
                      (e) => DropdownMenuItem<Language>(
                    value: e,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          e.flag,
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(e.name)
                      ],
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
        body:Container(
          height:size.height,
          child:Column(

            children:[
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer?0:1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width,
                    alignment: Alignment.topCenter,
                    height: closeTopContainer?0:categoryHeight,
                    child: categoriesScroller),
              ),
              SizedBox(
                height:10,
              ),
              Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        double scale = 1.0;
                        if (topContainer > 0.5) {
                          scale = index + 0.5 - topContainer;
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }
                        return Opacity(
                          opacity: scale,
                          child: Transform(
                            transform:  Matrix4.identity()..scale(scale,scale),
                            alignment: Alignment.bottomCenter,
                            child: Align(
                                heightFactor: 0.7,
                                alignment: Alignment.topCenter,
                                child: itemsData[index]),
                          ),
                        );
                      })),
            ],
          ),

        ),
    );
  }
}

class CategoriesScroller extends StatelessWidget {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);


  final List<dynamic> ngoItems = NGO_data;
  CategoriesScroller();
  @override
  Widget build(BuildContext context) {
    final double categoryHeight=MediaQuery.of(context).size.height * 0.4;

    return ListView.builder(
        itemCount: ngoItems.length,
        physics:BouncingScrollPhysics(),
        scrollDirection:Axis.horizontal,
        itemBuilder:(context,index){

            return Container(
                margin: EdgeInsets.all(10.0),
                width:200,
                height:categoryHeight,
                decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: secondaryColor,
                      width: 5,
                  ),
                  color:Colors.white,
                  boxShadow:[
                    BoxShadow(
                      color:Colors.black,
                      blurRadius:8,
                      offset:Offset(0,4),
                    ),
                  ],
                ),
                child:Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(

                        children:[
                          SizedBox(height:10),
                          Center(
                            child: Text(
                              ngoItems[index]["name"],
                              style:TextStyle(fontSize: 25,color:Colors.black,fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height:10),
                          Row(

                            children: [
                              IconButton(
                                icon: const Icon(Icons.call),
                                onPressed: (){
                                 _makingPhoneCall(ngoItems[index]["contact"]);
                                } ,
                              ),
                              Text(
                                "${ ngoItems[index]["contact"]}",
                                style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                              ),

                            ],
                          ),
                          SizedBox(height:10),
                          Text(
                            ngoItems[index]["add"],
                            style:TextStyle(fontSize: 18,color:Colors.black),
                          ),
                        ]
                    ),
                  ),
                )
            );
          }

    );
  }
}
