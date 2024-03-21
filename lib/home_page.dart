import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  //create : add a new note
  Future<void> addNotes(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  //Read : get notes from database
  Stream<QuerySnapshot> getNotes() {
    final noteStream = notes.orderBy('timestamp', descending: true).snapshots();
    return noteStream;
  }

  //update : update notes
  Future<void> updatenotes(String DocId, String newNote) {
    return notes
        .doc(DocId)
        .update({'note': newNote, 'timestamp': Timestamp.now()});
  }
//delete: delete notes
  Future<void> deleteNote(String DocId){
    return  notes.doc(DocId).delete();
  }
  final textController = TextEditingController();

  void openNoteBox({String? docId}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: "Divyesh"
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    if (docId == null) {
                      addNotes(textController.text);
                    } else {
                      updatenotes(docId, textController.text);
                    }
                    textController.clear();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.done))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("HomePage"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(),
        child: Icon(Icons.add),
      ),

      body: StreamBuilder(
        stream: getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;
            //display as a list
            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                //get each individual doc
                DocumentSnapshot documentSnapshot = noteList[index];
                String docId = documentSnapshot.id;
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                String noteText = data['note'];
                //display as a list tile
                return ListTile(
                  title: Text(noteText),
                  trailing: IconButton(onPressed: (){
                    openNoteBox(docId: docId);
                  },icon: Icon(Icons.edit)),
                  leading: IconButton(onPressed: (){
                    deleteNote(docId);
                  },icon: Icon(Icons.delete),),
                );
              },
            );
          } else {
            return Center(child: Text("Notes Not found"));
          }
        },
      ),
    );
  }
}
