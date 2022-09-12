// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:dictonaryapp/controller/dictionary_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, required this.title}) : super(key: key);
  final title;
  var count = 1;

  @override
  Widget build(BuildContext context) {
    DictionaryController dictionaryController = Get.put(DictionaryController());
    return Scaffold(
      appBar: AppBar(
        // title: Text(title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TextFormField(
                    onChanged: (String text) {
                      if (dictionaryController.debounce!.isActive) {
                        dictionaryController.debounce!.cancel();
                      }
                      dictionaryController.debounce =
                          Timer(const Duration(milliseconds: 1000), () {
                        dictionaryController.search();
                      });
                    },
                    controller: dictionaryController.dictionaryText,
                    decoration: const InputDecoration(
                      hintText: "Search Here.....",
                      contentPadding: EdgeInsets.only(left: 24.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    onPressed: () {
                      dictionaryController.search();
                    },
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: dictionaryController.stream,
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: Text("Enter a search word"),
                );
              } else if (snapshot.data == "isLoading") {
                return const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.green,
                    radius: 30,
                  ),
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: snapshot.data["definitions"].length > 1
                        ? Container(
                            height: 30,
                            width: 40,
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Center(
                                child: Text(
                              "${snapshot.data["definitions"].length}",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            )),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data["definitions"].length,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .25,
                                    width:
                                        MediaQuery.of(context).size.width * .85,
                                    child: snapshot.data["definitions"][index]
                                                ["image_url"] !=
                                            null
                                        ? Image.network(
                                            snapshot.data["definitions"][index]
                                                ["image_url"],
                                            fit: BoxFit.contain,
                                          )
                                        : Image.asset(
                                            "assets/no_image.jpeg",
                                            fit: BoxFit.contain,
                                          )),
                                const SizedBox(height: 15),
                                Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    dictionaryController.dictionaryText.text
                                            .trim() +
                                        "(" +
                                        snapshot.data["definitions"][index]
                                            ["type"] +
                                        ")"),
                                const SizedBox(height: 5),
                                const Text(
                                  "Definition",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data["definitions"]
                                      [index]["definition"]),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Pronunciation",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                snapshot.data["pronunciation"] != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${snapshot.data["pronunciation"]}"),
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 5),
                                const Text(
                                  "Example",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: snapshot.data["definitions"][index]
                                              ["example"] !=
                                          null
                                      ? Text(
                                          "${snapshot.data["definitions"][index]["example"]}")
                                      : const SizedBox.shrink(),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Emoji",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                snapshot.data["definitions"][index]["emoji"] !=
                                        null
                                    ? Text(
                                        "${snapshot.data["definitions"][index]["emoji"]}")
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
