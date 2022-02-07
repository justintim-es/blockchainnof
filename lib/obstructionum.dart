import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:nofifty/constantes.dart';
import 'package:nofifty/gladiator.dart';
import 'package:nofifty/transaction.dart';
import 'package:nofifty/utils.dart';
import 'package:nofifty/gladiator.dart';
import 'package:nofifty/transaction.dart';
import 'package:hex/hex.dart';
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
enum Generare {
  INCIPIO,
  EFECTUS,
  CONFUSSUS,
}
extension GenerareFromJson on Generare {
  static fromJson(String name) {
    switch(name) {
      case 'INCIPIO': return Generare.INCIPIO;
      case 'EFECTUS': return Generare.EFECTUS;
      case 'CONFUSSUS': return Generare.CONFUSSUS;
    }
  }
}
class InterioreObstructionum {
  final Generare generare;
  int obstructionumDifficultas;
  int propterDifficultas;
  int transactionDifficultas;
  int indicatione;
  BigInt nonce;
  final BigInt summaObstructionumDifficultas;
  final List<int> obstructionumNumerus;
  final String defensio;
  final String producentis;
  final String priorProbationem;
  final Gladiator gladiator;
  final List<Transaction> liberTransactions;
  final List<Transaction> fixumTransactions;
  InterioreObstructionum({
    required this.generare,
    required this.obstructionumDifficultas,
    required this.propterDifficultas,
    required this.transactionDifficultas,
    required this.summaObstructionumDifficultas,
    required this.obstructionumNumerus,
    required this.defensio,
    required this.producentis,
    required this.priorProbationem,
    required this.gladiator,
    required this.liberTransactions,
    required this.fixumTransactions}): indicatione = DateTime.now().microsecondsSinceEpoch, nonce = BigInt.zero;

  InterioreObstructionum.incipio({ required this.producentis }):
      generare = Generare.INCIPIO,
      obstructionumDifficultas =  0,
      propterDifficultas = 0,
      transactionDifficultas = 0,
      indicatione = DateTime.now().microsecondsSinceEpoch,
      nonce = BigInt.zero,
      summaObstructionumDifficultas = BigInt.zero,
      obstructionumNumerus = [0],
      defensio = Utils.randomHex(1),
      priorProbationem = '',
      gladiator = Gladiator(null, GladiatorOutput(List<Propter>.from([Propter.incipio(InterioreRationem.incipio(producentis))])), Utils.randomHex(32)),
      liberTransactions = List<Transaction>.from([Transaction('', InterioreTransaction(true, 0, [], [TransactionOutput(producentis, Constantes.ObstructionumPraemium)], Utils.randomHex(32)))]),
      fixumTransactions = [];

  InterioreObstructionum.efectus({
    required this.obstructionumDifficultas,
    required this.propterDifficultas,
    required this.transactionDifficultas,
    required this.summaObstructionumDifficultas,
    required this.obstructionumNumerus,
    required this.producentis,
    required this.priorProbationem,
    required this.gladiator,
    required this.liberTransactions,
    required this.fixumTransactions
  }):
      generare = Generare.EFECTUS,
      indicatione = DateTime.now().microsecondsSinceEpoch,
      nonce = BigInt.zero,
      defensio = Utils.randomHex(1);

  mine() {
    indicatione = DateTime.now().microsecondsSinceEpoch;
    nonce += BigInt.one;
  }

  Map<String, dynamic> toJson() => {
    'generare': generare.name.toString(),
    'obstructionumDifficultas': obstructionumDifficultas,
    'propterDifficultas': propterDifficultas,
    'transactionDifficultas': transactionDifficultas,
    'indicatione': indicatione,
    'nonce': nonce.toString(),
    'summaObstructionumDifficultas': summaObstructionumDifficultas.toString(),
    'obstructionumNumerus': obstructionumNumerus,
    'defensio': defensio,
    'producentis': producentis,
    'priorProbationem': priorProbationem,
    'gladiator': gladiator,
    'liberTransactions': liberTransactions.map((e) => e.toJson()).toList(),
    'fixumTransactions': fixumTransactions.map((e) => e.toJson()).toList()
  };
  InterioreObstructionum.fromJson(Map<String, dynamic> jsoschon):
      generare = GenerareFromJson.fromJson(jsoschon['generare']),
      obstructionumDifficultas = jsoschon['obstructionumDifficultas'],
      propterDifficultas = jsoschon['propterDifficultas'],
      transactionDifficultas = jsoschon['transactionDifficultas'],
      indicatione = jsoschon['indicatione'],
      nonce = BigInt.parse(jsoschon['nonce']),
      summaObstructionumDifficultas = BigInt.parse(jsoschon['summaObstructionumDifficultas']),
      obstructionumNumerus = List<int>.from(jsoschon['obstructionumNumerus']),
      defensio = jsoschon['defensio'],
      producentis = jsoschon['producentis'],
      priorProbationem = jsoschon['priorProbationem'],
      gladiator = Gladiator.fromJson(jsoschon['gladiator']),
      liberTransactions = List<Transaction>.from(jsoschon['liberTransactions'].map((l) => Transaction.fromJson(l))),
      fixumTransactions = List<Transaction>.from(jsoschon['fixumTransactions'].map((f) => Transaction.fromJson(f)));
}


class Obstructionum {
  final InterioreObstructionum interioreObstructionum;
  late String probationem;
  Obstructionum(this.interioreObstructionum, this.probationem);
  Obstructionum.incipio(this.interioreObstructionum):
        probationem = HEX.encode(sha512.convert(utf8.encode(json.encode(interioreObstructionum.toJson()))).bytes);
  static Future efectus(List<dynamic> args) async {
    InterioreObstructionum interioreObstructionum = args[0];
    SendPort mitte = args[1];
    String probationem = '';
    do {
      interioreObstructionum.mine();
      probationem = HEX.encode(sha512.convert(utf8.encode(json.encode(interioreObstructionum.toJson()))).bytes);
    } while (!probationem.startsWith('0' * interioreObstructionum.obstructionumDifficultas));
    mitte.send(Obstructionum(interioreObstructionum, probationem));
  }
  Map<String ,dynamic> toJson() => {
    'interioreObstructionum': interioreObstructionum.toJson(),
    'probationem': probationem
  };
  Obstructionum.fromJson(Map<String, dynamic> jsoschon):
      interioreObstructionum = InterioreObstructionum.fromJson(jsoschon['interioreObstructionum']),
      probationem = jsoschon['probationem'];

  Future salvareIncipio(Directory dir) async {
        File file = await File(dir.path + Constantes.FileNomen + dir.listSync().length.toString() + '.txt').create( recursive: true );
        interioreSalvare(file);
  }
  Future salvare(Directory dir) async {
    File file = File(dir.path + Constantes.FileNomen + (dir.listSync().length-1).toString() + '.txt');
      if (await Utils.fileAmnis(file).length-1 >= Constantes.MaximeCaudicesFile) {
        file = await File(dir.path + Constantes.FileNomen + (dir.listSync().length).toString()  + '.txt').create( recursive: true );
        interioreSalvare(file);
      } else {
        interioreSalvare(file);
      }
  }
  void interioreSalvare(File file) {
    var sink = file.openWrite(mode: FileMode.append);
    sink.write(json.encode(toJson()) + '\n');
    sink.close();
  }
  static Future<int> utDifficultas(Directory directory) async {
    List<Obstructionum> caudices = [];
    List<GladiatorInput?> gladiatorInitibus = [];
    List<GladiatorOutput?> gladiatorOutputs = [];
    for (int i = 0; i < directory.listSync().length; i++) {
         caudices.addAll(await Utils.fileAmnis(File(directory.path + '/caudices_' + i.toString() + '.txt')).map((b) => Obstructionum.fromJson(json.decode(b))).toList());
    }
    caudices.forEach((obstructionum) {
      gladiatorInitibus.add(obstructionum.interioreObstructionum.gladiator.input);
    });
    caudices.forEach((obstructionum) {
      if (gladiatorInitibus.map((gi) => gi?.gladiatorId).any((gi) => gi != obstructionum.interioreObstructionum.gladiator.id)) {
        gladiatorOutputs.add(obstructionum.interioreObstructionum.gladiator.output);
      }
    });
    return gladiatorOutputs.length;
  }
  static Future<BigInt> utSummaDifficultas(Directory directory) async {
    BigInt total = BigInt.zero;
    for (int i = 0; i < directory.listSync().length; i++) {
      await Utils.fileAmnis(File(directory.path + '/caudices_' + i.toString() + '.txt')).map((b) => Obstructionum.fromJson(json.decode(b))).forEach((obstructionum) {
          total += BigInt.from(obstructionum.interioreObstructionum.obstructionumDifficultas);
      });
    }
    return total;
  }
  static Future<List<int>> utObstructionumNumerus(Directory directory) async {
    Obstructionum obstructionum = await Utils.priorObstructionum(directory);
    final int priorObstructionumNumerus = obstructionum.interioreObstructionum.obstructionumNumerus[obstructionum.interioreObstructionum.obstructionumNumerus.length-1];
    if (priorObstructionumNumerus < Constantes.MaximeCaudicesFile) {
      obstructionum.interioreObstructionum.obstructionumNumerus[obstructionum.interioreObstructionum.obstructionumNumerus.length-1]++;
    } else if (priorObstructionumNumerus == Constantes.MaximeCaudicesFile) {
        obstructionum.interioreObstructionum.obstructionumNumerus.add(0);
    }
    return obstructionum.interioreObstructionum.obstructionumNumerus;
  }

}
