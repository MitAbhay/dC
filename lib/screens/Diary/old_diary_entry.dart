import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dear_canary/models/user_details.dart';

class OldDiaryEntry extends StatelessWidget {
  OldDiaryEntry({Key? key}) : super(key: key);

  List<String> oldDiaryEntries = [] ;
  List<DateTime> respectiveDiaryEntryDate = [];

  OldDiaryEntry.diaryEntry(
      this.oldDiaryEntries,
      this.respectiveDiaryEntryDate
  );

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Color(0xfff4f3f8),
          //color set to transperent or set your own color
          statusBarIconBrightness: Brightness.dark,
          //set brightness for icons, like dark background light icons
        )
    );

    return Scaffold(
      backgroundColor: const Color(0xfff4f3f8),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/images/reading.jpg"
              ),
            ),

            oldDiaryEntries.isNotEmpty ?
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10
                    ),
                    child: ListView.builder(
                      itemCount: oldDiaryEntries.length,
                      itemBuilder: (BuildContext context, int index){
                        return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 5,
                                    color: Colors.grey
                                )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15
                              ),
                              child: Column(
                                children: <Widget>[

                                  // Date and time
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(respectiveDiaryEntryDate[index])
                                      ),
                                      Text(
                                        "${respectiveDiaryEntryDate[index].hour}:${respectiveDiaryEntryDate[index].minute}"
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // Text
                                  Text(
                                    oldDiaryEntries[index],
                                    textAlign: TextAlign.justify,
                                  )
                                ],
                              ),
                            ),
                      );
                },
              ),
            ):
                const Center(
                  child: Text("No entry yet..."),
                )
          ],
        ),
      ),
    );
  }
}
