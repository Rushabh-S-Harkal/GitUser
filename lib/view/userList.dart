import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:github_user/controller/global.dart';
import 'package:github_user/controller/networkCall.dart';
import 'package:github_user/model/gituser.dart';
import 'package:github_user/view/bookmarkUser.dart';
import 'package:flutter_offline/flutter_offline.dart';
class GitUserList extends StatefulWidget {
  @override
  _GitUserListState createState() => _GitUserListState();
}
bool isUserApiCallDone = false;
networkLayer api = networkLayer();
List users = [];
List<Users> gitUserDetails = [];
var userLoginName;
var userProfileUrl;
var model;
var userid;
List<String> savedUsers = [];

class _GitUserListState extends State<GitUserList> {
List<Users> filterList;
  String query = '';
  void getUserList() {
    api.getGitUser().then((value) {
//print('=========$value');
      if (value == 0) {
        setState(() {
                  isUserApiCallDone = false;
                });
        //Server error
      } else {
        users = value;
        users
            .map((e) => {
// print('==========$e'),
                  userLoginName = e['login'],
                  userProfileUrl = e['avatar_url'],
                  userid = e['id'],
                  model =
                      Users(avatarUrl: userProfileUrl, login: userLoginName,id: userid),
                  gitUserDetails.add(model)
                })
            .toList();
        setState(() {
           filterList = gitUserDetails;
          isUserApiCallDone = true;
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  // getUserList();
  }

  int page = 1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        
        appBar: AppBar(
           bottom: TabBar(  
              tabs: [  
                Tab(icon: Icon(Icons.people), text: "Users"),  
                Tab(icon: Icon(Icons.bookmark_border_sharp), text: "BookMark List")  
              ],  
            ), 
          title: Text('Git Users'),
          backgroundColor: Colors.orange[400],
          actions: [
               Badge(
              badgeContent: Text('${savedUsers.length}'),
              toAnimate: false,
              position: BadgePosition.topStart(top: 0, start: 0),
              child: IconButton(
                icon: Icon(Icons.bookmark),
                onPressed: (){
                   print(savedUsers);
                  pushToFavoriteusersRoute(context);
                 
                } 
              ),
            ),
          ],
        ),
        body: Builder(builder:(BuildContext context){
          return OfflineBuilder(  connectivityBuilder: (BuildContext context,
                ConnectivityResult connectivity, Widget child) {
              bool connected = connectivity != ConnectivityResult.none;
              if (connected) {
                //call api and set bool value true
                // numberOfNeedyPeople.text = "1";
                if (isUserApiCallDone) {
                } else {
                 getUserList();
                }
              } else {
                Container();
              }
              return Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    height: 32.0,
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        color:
                            connected ? Colors.transparent : Color(0xFFEE4400),
                        child: connected
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Internet Connection Not Available",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  SizedBox(
                                    child: Icon(Icons.cloud_off),
                                  ),
                                ],
                              )),
                  ),
                ],
              );
            
            },
            child: TabBarView(children: [userList(),BookmarkUserList(favoriteItems: savedUsers,)],),
            
            );

        }
        
         ),
      ),
    );
  }

  Column userList() {
    return Column(
        children: <Widget>[
          SearchWidget(hintText: 'Search by user name',onChanged: searchBook,text: 'Hey ',),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              // ignore: missing_return
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                // getUserList();
                  // start loading data
                  setState(() {
                    isLoading = true;
                  });
                }
              },
             
              child:filterList == null ? CircularProgressIndicator(): ListView.builder(
                itemCount: filterList.length,
                itemBuilder: (context, index) {
                  String user = filterList[index].login; // model cause some issue here
                  String userImg = filterList[index].avatarUrl;
                  model = filterList[index];
                   bool isSaved = savedUsers.contains(user);
                  
                  return Container(
                    height: 100,
                    child: Card(
                      child: Center(
                        child: ListTile(

                          title: Text('${model.login}'),
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(model.avatarUrl),
                            backgroundColor: Colors.transparent,
                          ),
                          trailing: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? Colors.red : null,
            ),
             onTap: () {
              setState(() {
                if (isSaved) {
                  savedUsers.remove(user);
               
                } else {
                  savedUsers.add(user);
                 
                }
              });
            },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Container(
          //   height: isLoading ? 50.0 : 0,
          //   color: Colors.transparent,
          //   child: Center(
          //     child: new CircularProgressIndicator(),
          //   ),
          // ),
        ],
      );
  }
    Future pushToFavoriteusersRoute(BuildContext context) {
      print('if you want to navigate to new screen uncomment this code');
    // return Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => BookmarkUserList(
    //       favoriteItems: savedUsers,
    //     ),
    //   ),
    // );
  }

   void searchBook(String query) {
    final filterList = gitUserDetails.where((book) {
      final titleLower = book.login.toLowerCase();
     // final authorLower = book.author.toLowerCase();
      final searchLower = query.toLowerCase();
    print("====== search$titleLower");
      return titleLower.contains(searchLower) ;
      //||authorLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.filterList = filterList;
    });
  }
}
