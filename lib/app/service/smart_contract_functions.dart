import 'package:decent_election/app/utils/app_pref.dart';
import 'package:decent_election/app/utils/app_toast.dart';
import 'package:decent_election/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  // String abi = await rootBundle.loadString("contracts/contracts/Election.json");
  String abi = await rootBundle.loadString("assets/abi.json");
  String contractAddress = getPrefValue(Keys.CONTRACT);
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(String funcname, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funcname);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  return result;
}

Future<String> startElection(String name, Web3Client ethClient) async {
  var response =
      await callFunction('startElection', [name], ethClient, owner_private_key);
  debugPrint('Election started successfully');
  return response;
}

Future<String> addCandidate(String name, Web3Client ethClient) async {
  var response =
      await callFunction('addCandidate', [name], ethClient, owner_private_key);
  debugPrint('Candidate added successfully');
  return response;
}

Future<String> authorizeVoter(String address, Web3Client ethClient) async {
  var response = await callFunction('authorizeVoter',
      [EthereumAddress.fromHex(address)], ethClient, owner_private_key);
  debugPrint('Voter Authorized successfully');
  return response;
}

Future<List> getCandidatesNum(Web3Client ethClient) async {
  List<dynamic> result = await ask('getNumCandidates', [], ethClient);
  return result;
}

Future<List> getTotalVotes(Web3Client ethClient) async {
  List<dynamic> result = await ask('getTotalVotes', [], ethClient);
  return result;
}

Future<List> candidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> result =
      await ask('candidateInfor', [BigInt.from(index)], ethClient);
  return result;
}

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future vote(int candidateIndex, Web3Client ethClient) async {
  try {
    var response = await callFunction("vote", [BigInt.from(candidateIndex)],
        ethClient, getPrefValue(Keys.PRIVATEKEY));
    print("Vote counted successfully");
    setPrefValue(Keys.VOTED, "done");
    return response;
  } catch (e) {
    setPrefValue(Keys.VOTED, "done");
    print(e);
    longToastMessage("You have casted you vote wait for result!!");
  }
}
