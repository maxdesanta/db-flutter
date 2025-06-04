import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tugas_database/model/contact.dart';

class EntryForm extends StatefulWidget {
  final DocumentSnapshot? contact; // Gunakan DocumentSnapshot untuk update

  EntryForm({this.contact});

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  TextEditingController namaKontakController = TextEditingController();
  TextEditingController nomorTeleponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      final data = widget.contact!.data() as Map<String, dynamic>;
      namaKontakController.text = data['name'] ?? '';
      nomorTeleponController.text = data['phone'] ?? '';
    }
  }

  Future<void> save() async {
    String name = namaKontakController.text.trim();
    String phone = nomorTeleponController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data tidak boleh kosong')),
      );
      return;
    }

    try {
      if (widget.contact == null) {
        // Tambah data baru
        await FirebaseFirestore.instance.collection('contacts').add({
          'name': name,
          'phone': phone,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil disimpan')),
        );
      } else {
        // Update data existing
        await FirebaseFirestore.instance
            .collection('contacts')
            .doc(widget.contact!.id)
            .update({
          'name': name,
          'phone': phone,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil diperbarui')),
        );
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.contact != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(isEdit ? "Ubah Data" : "Tambah Data"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
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
                keyboardType: TextInputType.phone,
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
                      onPressed: save,
                      child: Text("Simpan"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.green),
                      ),
                    ),
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
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
