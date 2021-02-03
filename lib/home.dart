import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool uploading = false;

  bool containerdisplay = true;

  String parsedtext = '';

  imagefromgallery() async {
    //pick an image
    final imagefile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 670, maxHeight: 970);

    setState(() {
      uploading = true;
    });

    //prepare the image
    var bytes = File(imagefile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    //send to api
    var url = 'https://api.ocr.space/parse/image';

    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};

    var headers = {"apikey": "88b1aaee2988957"};

    var post = await http.post(url, body: payload, headers: headers);

    //get result from api

    var result = jsonDecode(post.body);

    setState(() {
      uploading = false;
      containerdisplay = false;
      parsedtext = result['ParsedResults'][0]['ParsedText'];
    });
  }

  imagefromcamera(bool iscamera) async {
    //pick an image

    final imagefile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 670, maxHeight: 970);

    setState(() {
      uploading = true;
    });

    //prepare the image
    var bytes = File(imagefile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    //send to api
    var url = 'https://api.ocr.space/parse/image';

    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};

    var headers = {"apikey": "88b1aaee2988957"};

    var post = await http.post(url, body: payload, headers: headers);

    print(post);

    //get result from api

    var result = jsonDecode(post.body);

    setState(() {
      uploading = false;
      containerdisplay = false;
      parsedtext = result['ParsedResults'][0]['ParsedText'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  alignment: Alignment.center,
                  child: Text(
                    "OCR App",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () => imagefromgallery(),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.purple,
                    ),
                    child: Center(
                      child: Text(
                        "Upload an image",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () => imagefromcamera(true),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.purple,
                    ),
                    child: Center(
                      child: Text(
                        "Click a photo",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                uploading == false ? Container() : CircularProgressIndicator(),
                SizedBox(
                  height: 70,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Parsed Text is: ",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      containerdisplay == true
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(right: 30),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.purple),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                parsedtext,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
