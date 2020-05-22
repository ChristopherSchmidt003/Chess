import processing.net.*;

Server myServer;

color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
int row1, col1, row2, col2;
boolean qkey, bkey, rkey, kkey;

char grid[][] = {
  {'R', 'B', 'N', 'Q', 'K', 'N', 'B', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'b', 'n', 'q', 'k', 'n', 'b', 'r'}
};

void setup() {
  size(800, 800);
  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");

  firstClick = true;

  myServer = new Server(this, 1234);

  textSize(25);
  textAlign(CENTER, CENTER);
  fill(0);
}  

void draw() {
  drawBoard();
  drawPieces();
  receiveMove();
  pawnUpgrade();
}

void receiveMove() {
  Client myClient = myServer.available();
  if (myClient != null) {
    String incoming = myClient.readString();
    int r1 = int (incoming.substring(0, 1));
    int c1 = int (incoming.substring(2, 3));
    int r2 = int (incoming.substring(4, 5));
    int c2 = int (incoming.substring(6, 7));
    grid[r2][c2] = grid[r1][c1];
    grid[r1][c1] = ' ';
  }
}

void drawBoard() {
  noStroke();
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if ( (c%2) == (r%2) ) { 
        fill(lightbrown);
      } else { 
        fill(darkbrown);
      }
      rect(c*100, r*100, 100, 100);
    }
  }
}

void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'R') image(brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image(bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image(bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image(bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image(bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image(bpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'r') image(wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image(wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image(wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image(wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image(wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image(wpawn, c*100, r*100, 100, 100);
    }
  }
}

void pawnUpgrade() {
  for (int c = 0; c < 8; c++) {
    if (grid[0][c] == 'p') {
      fill(0);
      textSize(25);
      text("Choose your upgrade", width/2, height/2-190);
      textSize(20);
      text("Q = Queen ", width/2, height/2-165);
      text("R = Rook  ", width/2, height/2-145);
      text("B = Bishop", width/2, height/2-125);
      text("K = Knight", width/2, height/2-105);
      
      if (qkey) grid[0][c] = 'q';
      if (rkey) grid[0][c] = 'r';
      if (bkey) grid[0][c] = 'b';
      if (kkey) grid[0][c] = 'n';
    }
    if (grid[7][c] == 'P') {
      fill(0);
      textSize(25);
      text("Choose your upgrade", width/2, height/2-190);
      textSize(20);
      text("Q = Queen ", width/2, height/2-165);
      text("R = Rook  ", width/2, height/2-145);
      text("B = Bishop", width/2, height/2-125);
      text("K = Knight", width/2, height/2-105);
      
      if (qkey) grid[7][c] = 'Q';
      if (rkey) grid[7][c] = 'R';
      if (bkey) grid[7][c] = 'B';
      if (kkey) grid[7][c] = 'N';
    }
  }
}

void mouseReleased() {
  if (firstClick) {
    col1 = mouseX/100;
    row1 = mouseY/100;
    firstClick = false;
  } else {
    col2 = mouseX/100;
    row2 = mouseY/100;
    if (!(row2 == row1 && col2 == col1)) {
      grid[row2][col2] = grid[row1][col1];
      grid[row1][col1] = ' ';
      myServer.write(row1 + "," + col1 + "," + row2 + "," + col2);
      firstClick = true;
    }
  }
}

void keyPressed() {
  if (key == 'Q' || key == 'q' ) qkey = true;
  if (key == 'R' || key == 'r' ) rkey = true;
  if (key == 'B' || key == 'b' ) bkey = true;
  if (key == 'K' || key == 'k' ) kkey = true;
}

void keyReleased() {
  if (key == 'Q' || key == 'q' ) qkey = false;
  if (key == 'R' || key == 'r' ) rkey = false;
  if (key == 'B' || key == 'b' ) bkey = false;
  if (key == 'K' || key == 'k' ) kkey = false;
}
