import 'package:flutter/material.dart';
import 'package:tugas_database/helper/dbhelper.dart';
import 'package:tugas_database/model/contact.dart';

class EntryForm extends StatefulWidget {
  final Contact? contact; // Bisa null jika tambah data baru

  EntryForm({this.contact});

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  TextEditingController namaKontakController = TextEditingController();
  TextEditingController nomorTeleponController = TextEditingController();
  int? contactId; // Menyimpan id untuk update

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      contactId = widget.contact!.id; // Simpan id
      namaKontakController.text = widget.contact!.namaKontak;
      nomorTeleponController.text = widget.contact!.nomorTelepon;
    }
  }

  void save() async {
    String name = namaKontakController.text;
    String phone = nomorTeleponController.text;

    Contact contact = Contact(
      id: contactId, // Penting! id harus diisi untuk update
      namaKontak: name,
      nomorTelepon: phone,
    );

    if (contactId == null) {
      // Insert data baru
      await DbHelper().insert(contact);
    } else {
      // Update data lama
      await DbHelper().update(contact);
    }

    Navigator.pop(context, true); // Kembali ke halaman Home dengan hasil true
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: contactId == null ? Text("Tambah Data") : Text("Ubah Data"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                controller: namaKontakController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Nama Kontak",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                controller: nomorTeleponController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Nomor Telepon",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: <Widget>[
                  // tombol simpan
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        save();
                      }, 
                      child: Text("Simpan"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                      ),
                    )
                  ),
                  Container(width: 5),
                  // tombol batal
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, 
                      child: Text("Batal"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
                      ),
                    )
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
