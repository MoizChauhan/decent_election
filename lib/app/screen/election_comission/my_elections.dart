import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decent_election/app/model/ec_model.dart';
import 'package:decent_election/app/model/election_model.dart';
import 'package:decent_election/app/screen/splash_screen.dart';
import 'package:decent_election/app/service/firebase_service.dart';
import 'package:decent_election/app/utils/app_colors.dart';
import 'package:decent_election/app/utils/app_pref.dart';
import 'package:decent_election/app/utils/app_routes.dart';
import 'package:decent_election/app/utils/enums.dart';
import 'package:decent_election/app/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class MyElections extends StatelessWidget {
  const MyElections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 20),
                SimpleAppBar(title: "My Elections"),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: IconButton(
                //       icon: Icon(
                //         Icons.account_circle,
                //         size: 35,
                //         color: AppColors.primaryColor,
                //       ),
                //       onPressed: () {
                //         AppRoutes.navigateToVoterProfile();
                //       }),
                // ),
                SizedBox(height: 10),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Election Name:",
                //       style: TextStyle(
                //         fontSize: 18,
                //         color: AppColors.primaryColor,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //     ConstrainedBox(
                //       constraints: BoxConstraints.tightForFinite(
                //           width: Get.width * 0.50),
                //       child: Text(
                //         "Prime Minister's Election",
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //           fontSize: 18,
                //           color: AppColors.black,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 20),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Election Commission:",
                //       style: TextStyle(
                //         fontSize: 18,
                //         color: AppColors.primaryColor,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //     Flexible(
                //       child: ConstrainedBox(
                //         constraints: BoxConstraints.tightForFinite(
                //             width: Get.width * 0.49),
                //         child: Text(
                //           "Prime Minister's Election",
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             fontSize: 18,
                //             color: AppColors.black,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 20),
                // Divider(color: AppColors.black),
                // SizedBox(height: 20),
                // Text(
                //   "My Elections:",
                //   style: TextStyle(
                //     fontSize: 18,
                //     color: AppColors.black,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(FirebaseService.EC_DB)
                          .doc(getPrefValue(Keys.AUTH_TOKEN))
                          .collection(FirebaseService.ELECTION_DB)
                          // .where("uid", whereIn: [])
                          .snapshots()
                          .map((doc) {
                        return doc.docs;
                      }),
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primaryColor));
                        } else {
                          return snapshot.data.length == 0
                              ? Center(child: Text("No Data available"))
                              : ListView.builder(
                                  itemCount: snapshot.data.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    ElectionModel election =
                                        ElectionModel.fromJson(
                                            snapshot.data[index].data());

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () async {
                                          await setPrefValue(Keys.CONTRACT,
                                              election.contractAddress);
                                          AppRoutes.navigatetoCreateElection(
                                              screenOps: ScreenOps.edit,
                                              electionModel: election);
                                        },
                                        child: Card(
                                          elevation: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  election.electionName,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                InkWell(
                                                  child: ClipRect(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: getColor(election
                                                            .electionStatus),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(49.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    22.0,
                                                                vertical: 6),
                                                        child: Text(
                                                          getStatus(election
                                                              .electionStatus),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                AppColors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          softWrap: false,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getStatus(value) {
    switch (value) {
      case "1":
        return "Yet To Start";
      case "2":
        return "On Going";
      case "3":
        return "Completed";
      default:
        return "Yet To Start";
    }
  }

  Color getColor(value) {
    switch (value) {
      case "1":
        return AppColors.googleColor.withOpacity(0.2);
      case "2":
        return AppColors.greenColor.withOpacity(0.2);
      case "3":
        return AppColors.facebookColor.withOpacity(0.2);
      default:
        return AppColors.googleColor.withOpacity(0.2);
    }
  }
}
