import 'package:decent_election/app/screen/splash_screen.dart';
import 'package:decent_election/app/service/contract_linking.dart';
import 'package:decent_election/app/service/smart_contract_functions.dart';
import 'package:decent_election/app/utils/app_colors.dart';
import 'package:decent_election/app/utils/app_pref.dart';
import 'package:decent_election/app/utils/app_routes.dart';
import 'package:decent_election/app/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoterHomeScreen extends StatelessWidget {
  const VoterHomeScreen({super.key});

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
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.account_circle,
                        size: 35,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        AppRoutes.navigateToVoterProfile();
                      }),
                ),
                SizedBox(height: 10),
                getPrefValue(Keys.CONTRACT) == ""
                    ? Center(
                        child: Text(
                            "You do not have any active election running....."))
                    : Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Election Name:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightForFinite(
                                      width: Get.width * 0.50),
                                  child: Text(
                                    getPrefValue(Keys.ELNAME),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Election Commission:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Flexible(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints.tightForFinite(
                                        width: Get.width * 0.49),
                                    child: Text(
                                      getPrefValue(Keys.ECNAME),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Divider(color: AppColors.black),
                            SizedBox(height: 20),
                            Text(
                              "Candidate List:",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder<List>(
                                  future: getCandidatesNum(
                                      ContractLinking.ethClient!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return snapshot.data != null
                                          ? ListView.builder(
                                              itemCount:
                                                  snapshot.data![0].toInt(),
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return FutureBuilder(
                                                    future: candidateInfo(
                                                        index,
                                                        ContractLinking
                                                            .ethClient!),
                                                    builder: (context, snap) {
                                                      if (snap.connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      } else {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Card(
                                                            elevation: 10,
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      12.0,
                                                                  horizontal:
                                                                      8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    snap.data![
                                                                            0]
                                                                            [0]
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: AppColors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      vote(
                                                                          index,
                                                                          ContractLinking
                                                                              .ethClient!);
                                                                    },
                                                                    child:
                                                                        ClipRect(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.2),
                                                                          borderRadius:
                                                                              BorderRadius.circular(49.0),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 22.0,
                                                                              vertical: 6),
                                                                          child:
                                                                              Text(
                                                                            'Vote',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: AppColors.black,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                            softWrap:
                                                                                false,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    });
                                              },
                                            )
                                          : Center(
                                              child: Text(
                                                  "No Candidates Available"),
                                            );
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
