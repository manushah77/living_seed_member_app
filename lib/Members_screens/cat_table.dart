import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_seed_member/Members_screens/Models/records.dart';

class CAtDetail extends StatefulWidget {
  CAtDetail({
    super.key,
    required this.data,
  });

  List<RecordsData> data;

  @override
  State<CAtDetail> createState() => _CAtDetailState();
}

class _CAtDetailState extends State<CAtDetail> {
  List<RecordsData> NewRecordData = [];

  double sum = 0;
  List a = [];

  ss() {
    for (int i = 0; i < widget.data.length; i++) {
      //print(widget.data[i].ammount);
      sum = sum + double.parse(widget.data[i].ammount!);
      //print(sum);
      a.add(sum);
    }
    print(a);
  }

  //getdata
  Future getData() async {
    for (var element in widget.data) {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('NewRecord')
          .where('Parentid', isEqualTo: element.parentID)
          .where('Transaction Category', isEqualTo: element.category)
          .get();
      if (snap.docs.isNotEmpty) {
        NewRecordData = snap.docs
            .map((e) => RecordsData.fromMap(e.data() as Map<String, dynamic>))
            .toList();

        for (var items in widget.data) {
          //amount += double.parse(items.ammount.toString());
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    ss();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            '${widget.data.first.category}',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel_presentation_sharp),
                color: Colors.black)
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: DataTable(border: TableBorder.all(),
                    columnSpacing: 35,
                    columns: [
                  DataColumn(
                      label: Text(
                    'Date',
                    style: TextStyle(fontSize: 12),
                  )),
                  DataColumn(
                      label: Text(
                    'Credit(+)',
                    style: TextStyle(fontSize: 12),
                  )),
                  DataColumn(
                      label: Text(
                    'Debit(-)',
                    style: TextStyle(fontSize: 12),
                  )),
                  DataColumn(
                      label: Text(
                    'Balance',
                    style: TextStyle(fontSize: 12),
                  )),
                ], rows: [
                  ...List.generate(
                      widget.data.length,
                      (index) => DataRow(cells: [
                            DataCell(Text(
                                '${DateFormat('d-M-yy').format(widget.data[index].date!.toDate())}')),
                            DataCell(Text(
                                '${widget.data[index].transtype == 'Credit' ? widget.data[index].ammount : ''}')),
                            DataCell(Text(
                                '${widget.data[index].transtype == 'Debit' ? widget.data[index].ammount : ''}')),
                            DataCell(Text('${a[index]}')),
                          ]))
                ]),
              ),
            ],
          ),
        ));
  }
}
