import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tugas_database/helper/dbhelper.dart';
import 'package:tugas_database/model/contact.dart';
import 'package:tugas_database/ui/entryform.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts = [];
  DbHelper dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() async {
    List<Contact> x = await dbHelper.getContactList();
    setState(() {
      contacts = x;
    });
  }

  void deleteContact(int id) async {
    await dbHelper.delete(id);
    refreshList();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data berhasil dihapus')));
  }

  void navigateToEntryForm(Contact? contact) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryForm(contact: contact),
      ),
    );
    if (result == true) {
      refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Contact'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          Contact c = contacts[index];
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.people),
              ),
              title: Text(c.namaKontak),
              subtitle: Text(c.nomorTelepon),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () async {
                  deleteContact(c.id!);
                },
              ),
              onTap: () async {
                navigateToEntryForm(c);
              },
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToEntryForm(null); // null berarti tambah data baru
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
