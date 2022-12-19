import 'package:decent_election/app/utils/constants.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class ContractLinking {
  static Client? httpClient;
  static Web3Client? ethClient;

  static init() {
    httpClient = Client();
    ethClient = Web3Client(crypt_url, httpClient!);
  }
}
