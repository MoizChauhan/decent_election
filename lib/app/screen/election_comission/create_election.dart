import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decent_election/app/model/election_model.dart';
import 'package:decent_election/app/model/voters_model.dart';
import 'package:decent_election/app/screen/splash_screen.dart';
import 'package:decent_election/app/service/contract_linking.dart';
import 'package:decent_election/app/service/firebase_service.dart';
import 'package:decent_election/app/service/smart_contract_functions.dart';
import 'package:decent_election/app/utils/app_colors.dart';
import 'package:decent_election/app/utils/app_pref.dart';
import 'package:decent_election/app/utils/app_toast.dart';
import 'package:decent_election/app/utils/enums.dart';
import 'package:decent_election/app/utils/token_generator.dart';
import 'package:decent_election/app/widgets/app_bar.dart';
import 'package:decent_election/app/widgets/app_button.dart';
import 'package:decent_election/app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateElection extends StatefulWidget {
  const CreateElection(
      {super.key, required this.screenOps, required this.electionModel});
  // : assert(screenOps == ScreenOps.edit && electionModel == null);
  final ScreenOps screenOps;
  final ElectionModel? electionModel;

  @override
  State<CreateElection> createState() => _CreateElectionState();
}

class _CreateElectionState extends State<CreateElection> {
  final TextEditingController electionNameController = TextEditingController();
  final TextEditingController addCandidateController = TextEditingController();

  final TextEditingController contractAddressController =
      TextEditingController();
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200), () {
      if (ScreenOps.edit == widget.screenOps) {
        initFunctions();
      }
    });
    super.initState();
  }

  initFunctions() {
    votingStatus = widget.electionModel!.electionStatus;
    electionNameController.text = widget.electionModel!.electionName;
    contractAddressController.text = widget.electionModel!.contractAddress;
    voters = widget.electionModel!.voters == []
        ? [""]
        : widget.electionModel!.voters;
    setState(() {});
  }

  String? votingStatus = "1";
  List voters = [""];
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SimpleAppBar(
                  title: widget.screenOps == ScreenOps.add
                      ? "Create Election"
                      : "Edit Election"),
              SizedBox(height: Get.height * .02),
              SizedBox(
                height: 65,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: AppTextField(
                    controller: electionNameController,
                    keyboardType: TextInputType.emailAddress,
                    lableText: "Election Name",
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 65,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: AppTextField(
                    controller: contractAddressController,
                    keyboardType: TextInputType.visiblePassword,
                    lableText: "Contract Address",
                  ),
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38.0),
                  child: Text(
                    "Election Status",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text("Yet To Start"),
                      value: "1",
                      groupValue: votingStatus,
                      onChanged: (value) {
                        setState(() {
                          votingStatus = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text("On Going"),
                      value: "2",
                      groupValue: votingStatus,
                      onChanged: (value) {
                        setState(() {
                          votingStatus = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text("Completed"),
                      value: "3",
                      groupValue: votingStatus,
                      onChanged: (value) {
                        setState(() {
                          votingStatus = value.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Candidates",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (ScreenOps.edit == widget.screenOps)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 28),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: addCandidateController,
                          lableText: 'Enter Candidate Name',
                        ),
                      ),
                      AppButtonOutlined(
                        onPressed: () {
                          addCandidate(addCandidateController.text,
                              ContractLinking.ethClient!);
                          addCandidateController.text = "";
                          setState(() {});
                        },
                        buttonText: 'Add Candidate',
                      )
                    ],
                  ),
                ),
              if (ScreenOps.edit == widget.screenOps)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: Get.height * 0.25,
                      decoration: BoxDecoration(),
                      child: FutureBuilder<List>(
                        future: getCandidatesNum(ContractLinking.ethClient!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return snapshot.data != null
                                ? SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        for (int i = 0;
                                            i < snapshot.data![0].toInt();
                                            i++)
                                          FutureBuilder<List>(
                                              future: candidateInfo(i,
                                                  ContractLinking.ethClient!),
                                              builder:
                                                  (context, candidatesnapshot) {
                                                if (candidatesnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return ListTile(
                                                    title: Text(
                                                        'Name: ${candidatesnapshot.data![0][0]}'),
                                                    subtitle: Text(
                                                        'Votes: ${candidatesnapshot.data![0][1]}'),
                                                  );
                                                }
                                              })
                                      ],
                                    ),
                                  )
                                : Center(child: Text("No Data available"));
                          }
                        },
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 15),
              if (ScreenOps.edit == widget.screenOps)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Authorised Voters",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // IconButton(
                      //     onPressed: () {
                      //       // addVotersDialog();

                      //     },
                      //     icon: Icon(  Icons.add_circle_outline))
                    ],
                  ),
                ),
              if (ScreenOps.edit == widget.screenOps)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: Get.height * 0.25,
                      decoration: BoxDecoration(),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(FirebaseService.VOTER_DB)
                              // .where("uid",
                              //     whereIn: voters == [] ? [""] : voters)
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
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.length,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        VotersModel voter =
                                            VotersModel.fromJson(
                                                snapshot.data[index].data());

                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "    ${voter.email}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  voters.contains(voter.uid)
                                                      ? await FirebaseService
                                                          .removeVoterInElection(
                                                          electionId: widget
                                                              .electionModel!
                                                              .uid,
                                                          voter: voter.uid,
                                                        )
                                                      : await FirebaseService
                                                          .addVoterInElection(
                                                              electionId: widget
                                                                  .electionModel!
                                                                  .uid,
                                                              voter: voter.uid,
                                                              contractAddress:
                                                                  contractAddressController
                                                                      .text,
                                                              electionCommision:
                                                                  getPrefValue(Keys
                                                                      .USERNAME),
                                                              electionName:
                                                                  electionNameController
                                                                      .text);
                                                  authorizeVoter(
                                                      voter.walletAddress,
                                                      ContractLinking
                                                          .ethClient!);
                                                  voters = await FirebaseService
                                                      .getVotersListInElection(
                                                          electionId: widget
                                                              .electionModel!
                                                              .uid);
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                },
                                                icon: Icon(
                                                    voters.contains(voter.uid)
                                                        ? Icons.cancel_outlined
                                                        : Icons.add_circle))
                                          ],
                                        );
                                      },
                                    );
                            }
                          }),
                    ),
                  ),
                ),

              SizedBox(height: Get.height * .04),
              if (loading) loader(),
              if (!loading)
                AppButton(
                    onPressed: () {
                      createElection();
                    },
                    buttonText: widget.screenOps == ScreenOps.add
                        ? "Create Election"
                        : "Update Election"),
              // SizedBox(height: Get.height * .04),
              // SizedBox(height: Get.height * .02),
            ],
          ),
        ),
      ),
    );
  }

  // addVotersDialog() {
  //   Get.dialog(
  //     Dialog(
  //       backgroundColor: Colors.transparent,
  //       child: Container(
  //         height: Get.height * 0.25,
  //         width: Get.width,
  //         decoration: BoxDecoration(),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 0.0),
  //           child: Card(
  //             elevation: 5,
  //             shape: RoundedRectangleBorder(
  //               side: BorderSide(color: AppColors.black),
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "    Voters List",
  //                       style: TextStyle(
  //                         fontSize: 15,
  //                         color: AppColors.black,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     Align(
  //                       alignment: Alignment.centerRight,
  //                       child: IconButton(
  //                           onPressed: () {
  //                             Get.back();
  //                           },
  //                           icon: Icon(Icons.cancel_outlined)),
  //                     ),
  //                   ],
  //                 ),
  //                 StreamBuilder(
  //                     stream: FirebaseFirestore.instance
  //                         .collection(FirebaseService.VOTER_DB)
  //                         // .where("uid",
  //                         //     whereNotIn: voters == [] ? [""] : voters)
  //                         .snapshots()
  //                         .map((doc) {
  //                       return doc.docs;
  //                     }),
  //                     builder: (context, AsyncSnapshot<dynamic> snapshot) {
  //                       if (!snapshot.hasData) {
  //                         return Center(
  //                             child: CircularProgressIndicator(
  //                                 color: AppColors.primaryColor));
  //                       } else {
  //                         return snapshot.data.length == 0
  //                             ? Center(child: Text("No Data available"))
  //                             : ListView.builder(
  //                                 shrinkWrap: true,
  //                                 itemCount: snapshot.data.length,
  //                                 padding: EdgeInsets.symmetric(horizontal: 3),
  //                                 itemBuilder:
  //                                     (BuildContext context, int index) {
  //                                   VotersModel voter = VotersModel.fromJson(
  //                                       snapshot.data[index].data());

  //                                   return Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Text(
  //                                         "    ${voter.email}",
  //                                         style: TextStyle(
  //                                           fontSize: 15,
  //                                           color: AppColors.black,
  //                                           fontWeight: FontWeight.w500,
  //                                         ),
  //                                       ),
  //                                       IconButton(
  //                                           onPressed: () {},
  //                                           icon:
  //                                               Icon(Icons.add_circle_outline))
  //                                     ],
  //                                   );
  //                                 },
  //                               );
  //                       }
  //                     }),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<void> createElection() async {
    setState(() {
      loading = true;
    });
    ElectionModel electionModel = ElectionModel(
        electionName: electionNameController.text,
        electionStatus: votingStatus!,
        uid: getRandomString(10),
        contractAddress: contractAddressController.text,
        voters: []);
    try {
      setPrefValue(Keys.CONTRACT, electionModel.contractAddress);
      await startElection(
          electionModel.electionName, ContractLinking.ethClient!);
      await FirebaseService.createElection(electionModel: electionModel);
      setPrefValue(Keys.CONTRACT, electionModel.contractAddress);
      setState(() {
        loading = false;
      });
      Get.back();
    } catch (e) {
      print(e);
      longToastMessage("Try Again");
      setState(() {
        loading = false;
      });
    }
  }
}
