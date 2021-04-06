import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:domestic_violence/home-views/comments.dart';

class AllPosts extends StatefulWidget {
  @override
  _AllPostsState createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {

  Widget _buildPost(int index, name, time, link,caption){

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
                            name,
                            style:TextStyle(
                              fontWeight:FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(time),

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
                                    image:AssetImage(link),
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
//                                            Navigator.pushNamed(context, "Comments",arguments: {"name" :
//                                            "Bijendra", "rollNo": 65210});
//                                              },
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) => Comments(postid:'abcd')));


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
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid;


    List<Widget> m=[_buildPost(0,'keizer','12:04 15th March','assets/.jpg','caption'),
          ];

    FirebaseFirestore.
    instance.
    collection("image").
    get().
    then((value) {
      value.docs.forEach((result) {
        print("-----DEBUG-----");
        String username=result.data()['uid'];
        String captioin=result.data()['caption'];
        String time= result.data()['time'];
        String url=result.data()['url'];
        print('$username, $captioin, $time, $url');
        m.add(_buildPost(0,username,time, 'assets/post1.jpg',captioin) );
      });
    });

    ListView l=ListView(
      physics:AlwaysScrollableScrollPhysics(),
      children: m,
    );
    return l;

//    return ListView(
//        physics:AlwaysScrollableScrollPhysics(),
//        children:[
//          _buildPost(0,'keizer','12:04 15th March','assets/post1.jpg','caption'),
//          _buildPost(1,'keizer','12:04 15th March','assets/post1.jpg','caption'),
//        ],
//    );

  }
}
