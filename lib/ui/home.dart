import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tugas_database/ui/entryform.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void navigateToEntryForm(DocumentSnapshot? contact) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EntryForm(contact: contact,)),
    );
  }

  // fungsi hapus data
  void delete(String id) async {
    await FirebaseFirestore.instance.collection("contacts").doc(id).delete();

    ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Data berhasil dihapus')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Contact'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("contacts").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final data = snapshot.data!.docs;
          if (data.isEmpty) {
            return Center(child: Text("Belum ada data"));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final contact = data[index].data() as Map<String, dynamic>;
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.people),
                  ),
                  title: Text(contact["name"]),
                  subtitle: Text(contact["phone"]),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () async {
                      delete(data[index].id);
                    },
                  ),
                  onTap: () async {
                    navigateToEntryForm(data[index]);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToEntryForm(null); 
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
