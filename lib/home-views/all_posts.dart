import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:domestic_violence/home-views/comments.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'dart:typed_data' show Uint8List;

import '../MyEncrpytClass.dart';

class AllPosts extends StatefulWidget {
  @override
  _AllPostsState createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {

  Widget _buildPost(int index, name, time, Uint8List decry,caption){

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
                                    image:MemoryImage(decry, scale: 0.5),
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

                                      Text(
                                        caption,
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

    var a=[255, 216, 255, 225, 2, 168, 69, 120, 105, 102, 0, 0, 77, 77, 0, 42, 0, 0, 0, 8, 0, 8, 1, 0, 0, 3, 0, 0, 0, 1, 7, 152, 0, 0, 1, 16, 0, 2, 0, 0, 0, 13, 0, 0, 0, 110, 1, 1, 0, 3, 0, 0, 0, 1, 7, 152, 0, 0, 1, 15, 0, 2, 0, 0, 0, 7, 0, 0, 0, 123, 135, 105, 0, 4, 0, 0, 0, 1, 0, 0, 0, 150, 1, 18, 0, 3, 0, 0, 0, 1, 0, 0, 0, 0, 1, 50, 0, 2, 0, 0, 0, 20, 0, 0, 0, 130, 136, 37, 0, 4, 0, 0, 0, 1, 0, 0, 1, 97, 0, 0, 0, 0, 82, 101, 100, 109, 105, 32, 78, 111, 116, 101, 32, 53, 0, 88, 105, 97, 111, 109, 105, 0, 50, 48, 50, 49, 58, 48, 51, 58, 51, 48, 32, 49, 54, 58, 50, 56, 58, 50, 57, 0, 0, 11, 146, 145, 0, 2, 0, 0, 0, 7, 0, 0, 1, 32, 164, 3, 0, 3, 0, 0, 0, 1, 0, 0, 0, 0, 144, 4, 0, 2, 0, 0, 0, 20, 0, 0, 1, 39, 146, 10, 0, 5, 0, 0, 0, 1, 0, 0, 1, 59, 130, 154, 0, 5, 0, 0, 0, 1, 0, 0, 1, 67, 136, 39, 0, 3, 0, 0, 0, 1, 3, 32, 0, 0, 146, 9, 0, 3, 0, 0, 0, 1, 0, 16, 0, 0, 146, 144, 0, 2, 0, 0, 0, 7, 0, 0, 1, 75, 146, 146, 0, 2, 0, 0, 0, 7, 0, 0, 1, 82, 146, 8, 0, 4, 0, 0, 0, 1, 0, 0, 0, 0, 130, 157, 0, 5, 0, 0, 0, 1, 0];
    List<Widget> m=[_buildPost(0,'keizer','12:04 15th March',Uint8List.fromList(a),'caption'),
          ];

    FirebaseFirestore.
    instance.
    collection("image").
    get().
    then((value) {
      value.docs.forEach((result) async {
        print("-----DEBUG-----");
        String username=result.data()['uid'];
        String captioin=result.data()['caption'];
        String time= result.data()['time'];
        String url=result.data()['url'];

        print('$username, $captioin, $time, $url');
        var resp = await http.get(url);
        enc.Encrypted encc = enc.Encrypted(resp.bodyBytes);
        print("RESP = ${resp.bodyBytes}");

        List<int> decryptedData =
        MyEncrypt.myEncrypter.decryptBytes(encc, iv: MyEncrypt.myIv);
        Uint8List d = Uint8List.fromList(decryptedData);
        var decr = d;
        print("RESP = ${decryptedData}");
        m.add(_buildPost(0,username,time, decr,captioin) );
      });
    });

    print(m);
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
