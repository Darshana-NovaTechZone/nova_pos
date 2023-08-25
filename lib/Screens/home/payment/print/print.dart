import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nova_pos/class/model/list_item_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../color/colors.dart';
import '../../oders/add_transaction/add_transaction.dart';

class Print extends StatefulWidget {
  Print({super.key, required this.total, required this.payment, required this.rest, required this.summery, required this.change, required this.rId});
  final String rId;
  final String total;
  final String payment;
  final String rest;
  final List<ListItem> summery;
  bool change;
  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  final pdf = pw.Document();
  String formattedDate = "";
  Key key = Key("1");
  data() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('d E MMM yyyy mm:ss a').format(now);
    setState(() {
      formattedDate;
    });
    print(formattedDate);
  }

  @override
  void initState() {
    data();
    // TODO: implement initState
    super.initState();
  }

  back() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return back();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff93dc8a),
          leading: IconButton(
              onPressed: () {
                back();
              },
              icon: Icon(Icons.arrow_back)),
          title: Text(
            "Receipt",
            style: TextStyle(fontSize: 17.sp, color: Color(0xff1a6216), fontWeight: FontWeight.normal),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Printer",
                //   style: TextStyle(fontSize: 15.sp, color: Color(0xff1a6216), fontWeight: FontWeight.normal),
                // ),
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.indigoAccent),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Icon(Icons.print),
                //       SizedBox(
                //         width: 5,
                //       ),
                //       Text(
                //         "None",
                //         style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.normal),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Preview",
                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: h - 160,
                  child: PdfPreview(
                    key: key,
                    canChangePageFormat: true,
                    previewPageMargin: EdgeInsets.symmetric(vertical: 0),
                    onShared: (context) {},
                    initialPageFormat: PdfPageFormat.a3,
                    pdfPreviewPageDecoration: BoxDecoration(color: white),
                    padding: EdgeInsets.all(0),
                    loadingWidget: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                    build: (context) => makePdf(),
                    canChangeOrientation: false,
                    canDebug: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    final ByteData bytes = await rootBundle.load('assets/r.PNG');
    final Uint8List byteList = bytes.buffer.asUint8List();
    pdf.addPage(pw.Page(
        margin: const pw.EdgeInsets.all(10),
        build: (context) {
          return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            //   pw.Header(text: "About Cat", level: 1),
            //   pw.Image(pw.MemoryImage(byteList), fit: pw.BoxFit.fitHeight, height: 100, width: 100)
            // ]),
            pw.Divider(borderStyle: pw.BorderStyle.dashed),
            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text(
                "Date: $formattedDate",
                style: pw.TextStyle(fontSize: 15.sp, fontWeight: pw.FontWeight.normal),
              ),
            ),
            pw.Divider(borderStyle: pw.BorderStyle.dashed),
            pw.Container(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.ListView.builder(
                    itemCount: widget.summery.length,
                    itemBuilder: (context, index) {
                      print(widget.summery[index]);
                      return pw.Container(
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              widget.summery[index].pName,
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15.sp),
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "${widget.summery[index].qnt.toString()} pcs",
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 15.sp),
                                ),
                                pw.Text(
                                  "${widget.summery[index].pcs}.00",
                                  style: pw.TextStyle(fontSize: 9.sp, fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.FittedBox(
                                    child: pw.Text(
                                      "${widget.summery[index].cartP.toString()}.00",
                                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  pw.Divider(borderStyle: pw.BorderStyle.dashed),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 8),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "Subtotal",
                          style: pw.TextStyle(fontSize: 13.sp, fontWeight: pw.FontWeight.normal),
                        ),
                        pw.Text(
                          "\$${widget.total.toString()}",
                          style: pw.TextStyle(fontSize: 13.sp, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "Grandtotal",
                          style: pw.TextStyle(fontSize: 15.sp, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          "\$${widget.total.toString()}",
                          style: pw.TextStyle(fontSize: 15.sp, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "Payment",
                          style: pw.TextStyle(fontSize: 15.sp, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          "\$${widget.payment.toString()}",
                          style: pw.TextStyle(fontSize: 15.sp, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          widget.change ? "change" : "Due",
                          style: pw.TextStyle(fontSize: 15.sp, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          "\$${widget.rest.toString()}",
                          style: pw.TextStyle(fontSize: 15.sp, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text(
                      widget.change ? "PAID" : "UNSETTLED",
                      style: pw.TextStyle(fontSize: 23.sp, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    "Nova-Pos/${widget.rId}-lk",
                    style: pw.TextStyle(fontSize: 15.sp, fontWeight: pw.FontWeight.normal),
                  ),
                  pw.Text(
                    "$formattedDate",
                    style: pw.TextStyle(fontSize: 15.sp, fontWeight: pw.FontWeight.normal),
                  ),
                ],
              ),
            ),
          ]);
        }));
    return pdf.save();
  }
}
