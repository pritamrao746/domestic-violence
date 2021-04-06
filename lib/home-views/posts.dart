import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:domestic_violence/home-views/comments.dart';
import 'package:domestic_violence/home-views/savedposts.dart';
import 'package:domestic_violence/home-views/myposts.dart';
import 'package:domestic_violence/home-views/all_posts.dart';
import 'package:domestic_violence/home-views/newposts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:domestic_violence/classes/language.dart';
import 'package:domestic_violence/localization/language_constants.dart';
import 'package:domestic_violence/main.dart';



class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  int _currentIndex=0;

  final List<Widget> _children =[
    AllPosts(),
    MyPosts(),
    SavedPosts(),
    NewPosts(),

  ];

  Widget _buildPost(int index){
    return Padding(
      padding:EdgeInsets.symmetric(horizontal: 10.0,vertical:5.0),
      child:Container(
          margin:EdgeInsets.symmetric(vertical:10),
          width:double.infinity,
          height:500.0,
          decoration:BoxDecoration(
            color: Colors.white,
            borderRadius:BorderRadius.circular(25.0),
          ),
          child:Column(
              children:<Widget>[
                Padding(
                    padding:EdgeInsets.symmetric(vertical:10),
                    child:Column(
                      children:[
                        ListTile(
                          leading:Container(
                            margin:EdgeInsets.all(10),
                            width:50,
                            height:50,
                            decoration:BoxDecoration(
                              shape:BoxShape.circle,
                              boxShadow:[
                                BoxShadow(
                                  color:Colors.black45,
                                  offset:Offset(0,2),
                                  blurRadius:6.0,
                                ),
                              ],
                            ),
                            child:CircleAvatar(
                              child:ClipOval(
                                child:Image(
                                  height:50.0,
                                  width:50.0,
                                  image:AssetImage('assets/profile.png'),
                                  fit:BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          title:Text(
                            'Mahipal',
                            style:TextStyle(
                              fontWeight:FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('12:04 15th March'),

                        ),
                        InkWell(
                          onTap:(){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Comments()));
                          },
                          child: Container(
                              margin:EdgeInsets.all(10.0),
                              width:double.infinity,
                              height:325,
                              decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black45,
                                      offset:Offset(0,4),
                                      blurRadius:8,
                                    ),
                                  ],
                                  image:DecorationImage(
                                    image:AssetImage('assets/post1.jpg'),
                                    fit:BoxFit.fitWidth,
                                  )
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              Row(
                                children:[
                                  Row(
                                    children:[
                                      IconButton(
                                        icon:Icon(Icons.favorite_border),
                                        iconSize:30,
                                        onPressed:(){

                                        },
                                      ),
                                      Text(
                                        '10',
                                        style:TextStyle(
                                          fontSize:14.0,
                                          fontWeight:FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width:20),
                                  Row(
                                      children:[
                                        IconButton(
                                          icon:Icon(Icons.chat),
                                          iconSize:30,
                                          onPressed:(){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) => Comments()));
                                          },
                                        ),
                                        Text(
                                          '2',
                                          style:TextStyle(
                                            fontSize:14.0,
                                            fontWeight:FontWeight.w600,
                                          ),
                                        ),
                                      ]
                                  ),
                                ],
                              ),
                              IconButton(
                                  icon:Icon(Icons.share),
                                  iconSize:30,
                                  onPressed:(){

                                  }
                              )
                            ],
                          ),
                        )
                      ],
                    )
                )
              ]
          )
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text(getTranslated(context, 'posts')),
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
      backgroundColor:Color(0xFFEDF0F6),
      body:_children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type:BottomNavigationBarType.fixed,
          selectedFontSize: 20,
          unselectedFontSize: 15,
          backgroundColor: primaryColor,
          items:[
            BottomNavigationBarItem(
              icon:Icon(Icons.account_circle,color: Colors.white,),
              title:Text(getTranslated(context, 'all_posts'),style:TextStyle(color:Colors.white)),
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.account_circle,color: Colors.white,),
              title:Text(getTranslated(context, 'my_posts'),style:TextStyle(color:Colors.white)),
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.favorite_border_outlined,color: Colors.white),
              title:Text(getTranslated(context, 'saved_posts'),style:TextStyle(color:Colors.white)),
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.add_box_outlined,color: Colors.white),
              title:Text(getTranslated(context, 'new_posts'),style:TextStyle(color:Colors.white)),
            ),
          ],
        onTap: (index){
          setState(() {
            _currentIndex=index;
          });
        },
      ),
    );
  }
}

