import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
   
    // make the manager
    Interactive.make( this );
   
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
     for(int c = 0; c < NUM_COLS; c++){
      buttons[r][c] = new MSButton(r,c);
     }
    }
   //Need to initialize mines list before using it 
   //Don't want to cause a null pointer exception
   mines = new ArrayList<MSButton>();
   
    setMines();
}
public void setMines()
{
    int mineCount = 0;
    while(mineCount < NUM_ROWS + NUM_COLS){
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row][col])){
      mines.add(buttons[row][col]);
      mineCount++;
    }  
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    for(int r =0; r < NUM_ROWS; r++){
     for(int c = 0; c < NUM_COLS; c++){
      MSButton button = buttons[r][c];
      if(!mines.contains(button) && !button.clicked){ // if a non mine cell is still 
      //                                                 hidden then game is not won
       return false; 
      }
     }
    }
    return true; // all non mine cells have been clicked
}
public void displayLosingMessage()
{
    // Reveal all mines
    for (MSButton mine : mines) {
        mine.setLabel("M");  // Mark all mines with m
        mine.clicked = true;
    }

    // Display "Game Over" on all non-mine buttons
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!mines.contains(buttons[r][c])) {
                buttons[r][c].setLabel("X");  // Mark non-mines with 'X'
            }
        }
    }
}
public void displayWinningMessage()
{
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c].setLabel(":)");  // Winning smiley face
        }
    }
}
public boolean isValid(int r, int c)
{
    if(r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0){
     return true; 
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for(int r = -1; r <= 1; r++){
     for(int c = -1; c <= 1; c++){
      int newRow = row + r;
      int newCol = col + c;
      if(!(r == 0 & c == 0)){
       if(isValid(newRow,newCol) && mines.contains(buttons[newRow][newCol])){
         numMines++;
       }
      }
     }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed ()
    {
        clicked = true;
        //your code here
        if(mouseButton == RIGHT){ // right click toggles the flag
         flagged = !flagged; 
         if(!flagged){clicked = false;} //if flag is removed also unclick
         return; // do nothing more if right clicked 
        }
        if(flagged){return;} //if it is flagged then ignore right clicks
        
        clicked = true;
        
        if(mines.contains(this)){
         displayLosingMessage(); //lose if presses on a mine
         return;
        }
        int numMines = countMines(myRow, myCol);
        if(numMines > 0){
         setLabel(numMines);  //shows neighbor mines #
        }
        else{
         for(int r = -1; r <=1; r++){
          for(int c = -1; c <=1; c++){
           int newRow = myRow + r;
           int newCol = myCol + c;
           if(isValid(newRow,newCol)){
            MSButton a = buttons[newRow][newCol];
            if(!a.clicked && !a.flagged){
             a.mousePressed(); //recursivley reveal
            }
           }
          }
         }
        }
    }
    public void draw ()
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) )
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
