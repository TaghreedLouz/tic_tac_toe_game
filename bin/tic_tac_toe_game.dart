import 'dart:io'; // لإدخال وإخراج البيانات
import 'dart:math'; // لاستخدام ai

class TicTacToe {
  List<String> gameBoard = List.filled(9, " ");
  String humanPlayer = "X";
  String aiPlayer = "O";
  bool vsAI = true; // متغير لتحديد اللعبة ضد ai او لا
  late String currentPlayer; // لتتبع اللاعب الحالي

  void start() {
    print("Welcome to X-O game...");
    chooseMarker();
    choosePlayer(); // اختيار نمط اللعبة ضد ai أو لا
    currentPlayer = "X"; // نبدأ بـ X
    printBoard(); // طباعة اللوحة للعب

    while (true) {
      if (vsAI && currentPlayer == aiPlayer) {
        aiMove(); // دور ai
      } else {
        playerMove(); // دور اللاعب بشري
      }
      printBoard();

      if (checkWinner(currentPlayer)) {
        print("The player $currentPlayer win: )");
        break;
      } else if (isDraw()) {
        print("The game ended in a draw!");
        break;
      }

      switchPlayer(); // تبديل الدور
    }

    askReplay();
  }

  // يتيح للاعب اختيار X أو O في بداية
  void chooseMarker() {
    while (true) {
      stdout.write("Choose (X or O): ");
      String? input = stdin.readLineSync()?.toUpperCase();
      if (input == "X" || input == "O") {
        humanPlayer = input!;
        aiPlayer = (input == "X") ? "O" : "X";
        break;
      } else {
        print("Please choose X or O");
      }
    }
  }

  // بيسال المستخدم إذا كان يريد اللعب ضد ai أو ضد لاعب بشري؟
  void choosePlayer() {
    while (true) {
      stdout.write("Do you want to play against ai: ");
      String? input = stdin.readLineSync()?.toLowerCase();
      if (input == "yes" || input == "y") {
        vsAI = true;
        break;
      } else if (input == "no" || input == "n") {
        vsAI = false;
        break;
      } else {
        print("Please enter yes or no");
      }
    }
  }

  // دالة لطباعة لوحة اللعب
  void printBoard() {
    print("\n");
    for (int i = 0; i < 9; i += 3) {
      // طباعة ثلاثة عناصر في كل صف
      print(" ${gameBoard[i]} | ${gameBoard[i + 1]} | ${gameBoard[i + 2]} ");
      // طباعة فاصل بين الصفوف
      if (i < 6) print("---|---|---");
    }
    print("\n");
  }

  // داللة لتحقق من اجابات اللاعب ومواقعها في الخلية
  void playerMove() {
    int move;
    while (true) {
      stdout.write("Choose cell (9-1) $currentPlayer player: ");
      var input = stdin.readLineSync();

      if (input == null || int.tryParse(input) == null) {
        print("Enter an integer between 1 and 9");
        continue;
      }

      move = int.parse(input) - 1;

      if (move < 0 || move >= 9) {
        print("Enter an integer between 1 and 9");
      } else if (gameBoard[move] != " ") {
        print("This cell is filled, choose another cell");
      } else {
        gameBoard[move] = currentPlayer; //وضع العلامة في الخلية
        break;
      }
    }
  }

  // دالة حركة ai
  void aiMove() {
    print("ai thinking...");
    sleep(Duration(seconds: 1)); // تأخير لتقليد التفكير
    int move = getBestMove();
    gameBoard[move] = aiPlayer;
    print("Ai choose cell ${move + 1}");
  }

  // تحديد حركة لai باستخدام منطق بسيط
  int getBestMove() {
    // المحاولة للفوز
    for (int i = 0; i < 9; i++) {
      if (gameBoard[i] == " ") {
        gameBoard[i] = aiPlayer;
        if (checkWinner(aiPlayer)) {
          gameBoard[i] = " ";
          return i;
        }
        gameBoard[i] = " ";
      }
    }
    // محاولة منع اللاعب البشري من الفوز
    for (int i = 0; i < 9; i++) {
      if (gameBoard[i] == " ") {
        gameBoard[i] = humanPlayer;
        if (checkWinner(humanPlayer)) {
          gameBoard[i] = " ";
          return i;
        }
        gameBoard[i] = " ";
      }
    }
    // اختيار حركة عشوائية من المواقع المتاحة
    List<int> emptyCells = [];
    for (int i = 0; i < 9; i++) {
      if (gameBoard[i] == " ") emptyCells.add(i);
    }
    return emptyCells[Random().nextInt(emptyCells.length)];
  }

  // تبديل اللاعب الحالي
  void switchPlayer() {
    currentPlayer = (currentPlayer == "X") ? "O" : "X";
  }




  // التحقق إذا كان اللاعب الحالي فاز
  bool checkWinner(String player) {
    // قائمة بكل أنماط الفوز الممكنة (صفوف، أعمدة، أقطار)
    List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], //row
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // colum
      [0, 4, 8], [2, 4, 6] //diagonal
    ];

    for (var condition in winConditions) {
      if (gameBoard[condition[0]] == player &&
          gameBoard[condition[1]] == player &&
          gameBoard[condition[2]] == player) {
        return true;
      }
    }
    return false;
  }

  // دالة للتحقق من وجود تعادل (جميع الخانات ممتلئة ولم يتحقق اي نمط من انماط الفوز)
  bool isDraw() {
    return gameBoard.every((cell) => cell != " ");
  }

  // دالة لسؤال المستخدم اذا كان يريد إعادة اللعب مرة اخرى
  void askReplay() {
    stdout.write("Do you want to play again? (Yes/No)? ");
    var input = stdin.readLineSync()?.toLowerCase();
    if (input == "yes" || input == "y") {
      gameBoard = List.filled(9, " "); // تفريغ القائمة
      currentPlayer = "X";      // اعادة تعيين اللاعب  X
      start(); // بدء اللعبة من جديد
    } else {
      print("Thank you :)");

    }
  }
}

void main() {
  TicTacToe game = TicTacToe();
  game.start();
}