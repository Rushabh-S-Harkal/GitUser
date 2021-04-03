import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BookmarkUserList extends StatefulWidget {

   List<String> favoriteItems = [];
  BookmarkUserList({this.favoriteItems});
  @override
  _BookmarkUserListState createState() => _BookmarkUserListState();
}
List<String> bookMarkUsers = [];



class _BookmarkUserListState extends State<BookmarkUserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: ListView.separated(

        itemCount: widget.favoriteItems.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        
        itemBuilder: (BuildContext context, int index) {
           String user = widget.favoriteItems[index];
           // bool isSaved = bookMarkUsers.contains(user);
           return ListTile(
          title: Text(widget.favoriteItems[index]),
          // trailing: Icon(
          //     isSaved ? Icons.bookmark : Icons.bookmark_border,
          //     color: isSaved ? Colors.red : null,
          //   ),
          //     onTap: () {
          //     setState(() {
          //       if (isSaved) {
          //         bookMarkUsers.remove(user);
               
          //       } else {
          //         bookMarkUsers.add(user);
                 
          //       }
          //     });
          //   },
        );
        }
        
        
        
       
      ),
    );
  }
}