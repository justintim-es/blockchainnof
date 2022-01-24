import 'dart:convert';
import 'package:hex/hex.dart';
import 'package:crypto/crypto.dart';
import 'dart:isolate';
import 'package:hex/hex.dart';
class TransactionInput {
  final int index;
  final String signature;
  final String transactionId;
  TransactionInput(this.index, this.signature, this.transactionId);
  Map<String, dynamic> toJson() => {
    'index': index,
    'signature': signature,
    'transactionId': transactionId
  };
  TransactionInput.fromJson(Map<String, dynamic> jsoschon):
      index = jsoschon['index'],
      signature = jsoschon['signature'],
      transactionId = jsoschon['transactionId'];
}
class TransactionOutput {
  final String publicKey;
  final BigInt nof;
  TransactionOutput(this.publicKey, this.nof);
  Map<String, dynamic> toJson() => {
    'publicKey': publicKey,
    'nof': nof.toString()
  };
  TransactionOutput.fromJson(Map<String, dynamic> jsoschon):
      publicKey = jsoschon['publicKey'],
      nof = BigInt.parse(jsoschon['nof']);
}


class InterioreTransaction {
  final bool liber;
  final int zeros;
  final List<TransactionInput> inputs;
  final List<TransactionOutput> outputs;
  final String random;
  final String id;
  BigInt nonce;
  InterioreTransaction(this.liber, this.zeros, this.inputs, this.outputs, this.random):
        nonce = BigInt.zero,
        id = HEX.encode(
            sha512.convert(
                utf8.encode(json.encode(inputs.map((e) => e.toJson()).toList())) +
                utf8.encode(json.encode(outputs.map((e) => e.toJson()).toList())) +
                utf8.encode(json.encode(random))
            ).bytes
        );
  mine() {
    nonce += BigInt.one;
  }
  Map<String, dynamic> toJson() => {
    'liber': liber,
    'inputs': inputs.map((i) => i.toJson()).toList(),
    'outputs': outputs.map((o) =>  o.toJson()).toList(),
    'random': random,
    'zeros': zeros,
    'id': id,
    'nonce': nonce.toString(),
  };
  InterioreTransaction.fromJson(Map<String, dynamic> jsoschon):
      liber = jsoschon['liber'],
      inputs = List<TransactionInput>.from(jsoschon['inputs'].map((i) => TransactionInput.fromJson(i))),
      outputs = List<TransactionOutput>.from(jsoschon['outputs'].map((o) => TransactionOutput.fromJson(o))),
      random = jsoschon['random'],
      zeros = jsoschon['zeros'],
      id = jsoschon['id'],
      nonce = BigInt.parse(jsoschon['nonce']);
}
class Transaction {
  late String probationem;
  final InterioreTransaction interioreTransaction;
  Transaction(this.probationem, this.interioreTransaction);
  Transaction.fromJson(Map<String, dynamic> jsoschon):
      probationem = jsoschon['probationem'],
      interioreTransaction = InterioreTransaction.fromJson(jsoschon['interioreTransaction']);
  static void quaestum(List<dynamic> argumentis) {
    InterioreTransaction interiore = argumentis[0];
    SendPort mitte = argumentis[1];
    String probationem = '';
    do {
      interiore.mine();
      probationem = HEX.encode(sha256.convert(utf8.encode(json.encode(interiore.toJson()))).bytes);
    } while(!probationem.startsWith('0' * interiore.zeros));
    mitte.send(Transaction(probationem, interiore));
  }
  Map<String, dynamic> toJson() => {
    'probationem': probationem,
    'interioreTransaction': interioreTransaction.toJson()
  };

}
