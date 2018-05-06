//--- display the window of input parameters when launching the script
#property script_show_inputs
extern string FileName        = "HD1.csv";

extern datetime StartDate     = 0;
extern datetime EndDate       = 0;

extern color BuyOrder         = Blue;
extern color SellOrder        = Red;
extern color OrderClose       = Green;

int OrderTypeColumn           = 2;
int OpenTimeColumn            = 4;
int OpenPriceColumn           = 5;
int CloseTimeColumn           = 6;
int ClosePriceColumn          = 7;


string s[10][10000];
int OrderOpenCounter          = 1;
int OrderCloseCounter         = 1;
int LineMarkCounter           = 1;


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int OnStart()
  {

   int row=0,col=0;
   int rowCnt,colCnt;
   int handle=FileOpen(FileName,FILE_CSV|FILE_READ,",");
   if(handle>0)
   {
     while(True)
     {
       string temp = FileReadString(handle);
       if(FileIsEnding(handle)) break;
       s[col][row]=temp;       
       if(FileIsLineEnding(handle))
       {
         colCnt = col;
         col = 0;
         row++;
       }
       else
       {
         col++;
       }
       rowCnt = row-1;
     }
     FileClose(handle);
     string lines = "  ";
     
     //seperateString(s[col][row]); 
     
     for(row=0; row<=rowCnt; row++)
        {
          for(col=0; col<=colCnt; col++)  
          {
            lines = lines + " " + s[col][row];
            //Alert("s: " + s[col][row]);
             seperateString(s[col][row]);
                
          }
          lines = lines + "\n";
      
        }
      //Comment(lines);
    
      
   }
   else
   {
     Comment("File "+FileName+" not found, the last error is ", GetLastError());
     return(false);
   }
   return(0);
  }
  
  void seperateString(string string_to_split)
     {
         
         //Alert("string_to_split: ",string_to_split);
         string to_split=string_to_split ;   // A string to split into substrings
         string sep=";";                     // A separator as a character
         ushort u_sep;                       // The code of the separator character
         string result[];                    // An array to get strings
         //--- Get the separator code
         u_sep=StringGetCharacter(sep,0);
         //--- Split the string to substrings
         int k=StringSplit(to_split,u_sep,result);
  
          string type = result[OrderTypeColumn];
          string OpenTime = StrToTime(result[OpenTimeColumn]);
          string OpenPrice = StrToDouble(result[OpenPriceColumn]);
          string CloseTime = StrToTime(result[CloseTimeColumn]);
          string ClosePrice = StrToDouble(result[ClosePriceColumn]);          


          if(type == "Long") 
          if(OpenTime >= StartDate  || StartDate == 0)
          if(CloseTime >= StartDate || StartDate == 0)
          if(OpenTime <= EndDate    || EndDate == 0)
          if(CloseTime <= EndDate   || EndDate == 0)

            {   
              // order open mark
                 string OrderOpenName = "OrderOpen" + DoubleToStr(OrderOpenCounter,0);
                 ObjectDelete(OrderOpenName);
                 ObjectCreate(OrderOpenName, OBJ_ARROW_UP, 0, OpenTime, OpenPrice, 0, 0, 0, 0);
                 ObjectSet(OrderOpenName, OBJPROP_COLOR, BuyOrder);
                 OrderOpenCounter ++;
              // order close mark
                 string OrderCloseName = "OrderClose" + DoubleToStr(OrderCloseCounter,0);
                 ObjectDelete(OrderCloseName);
                 ObjectCreate(OrderCloseName, OBJ_ARROW_CHECK, 0, CloseTime, ClosePrice, 0, 0, 0, 0);
                 ObjectSet(OrderCloseName, OBJPROP_COLOR, OrderClose);
                 OrderCloseCounter ++;
              // line mark
                 string LineMarkName = "LineMarkName" + DoubleToStr(LineMarkCounter,0);
                 ObjectDelete(LineMarkName);
                 ObjectCreate(LineMarkName, OBJ_TREND, 0, OpenTime, OpenPrice, CloseTime, ClosePrice, 0, 0);
                 ObjectSet(LineMarkName, OBJPROP_COLOR, BuyOrder);
                 ObjectSet(LineMarkName, OBJPROP_STYLE, STYLE_DOT);
                 ObjectSet(LineMarkName, OBJPROP_RAY, 0);
                 LineMarkCounter ++;                                  
            }
          
          if(type == "Short")
          if(OpenTime >= StartDate  || StartDate == 0)
          if(CloseTime >= StartDate || StartDate == 0)
          if(OpenTime <= EndDate    || EndDate == 0)
          if(CloseTime <= EndDate   || EndDate == 0)

            {   
              // order open mark
                OrderOpenName = "OrderOpen" + DoubleToStr(OrderOpenCounter,0);
                ObjectDelete(OrderOpenName);
                ObjectCreate(OrderOpenName, OBJ_ARROW_DOWN, 0, OpenTime, OpenPrice, 0, 0, 0, 0);
                ObjectSet(OrderOpenName, OBJPROP_COLOR, SellOrder);
                OrderOpenCounter ++;
              // order close mark
                OrderCloseName = "OrderClose" + DoubleToStr(OrderCloseCounter,0);
                ObjectDelete(OrderCloseName);
                ObjectCreate(OrderCloseName, OBJ_ARROW_CHECK, 0, CloseTime, ClosePrice, 0, 0, 0, 0);
                ObjectSet(OrderCloseName, OBJPROP_COLOR, OrderClose);
                OrderCloseCounter ++;
              // line mark
                LineMarkName = "LineMarkName" + DoubleToStr(LineMarkCounter,0);
                ObjectDelete(LineMarkName);
                ObjectCreate(LineMarkName, OBJ_TREND, 0, OpenTime, OpenPrice, CloseTime, ClosePrice, 0, 0);
                ObjectSet(LineMarkName, OBJPROP_COLOR, SellOrder);
                ObjectSet(LineMarkName, OBJPROP_STYLE, STYLE_DOT);
                ObjectSet(LineMarkName, OBJPROP_RAY, 0);
                LineMarkCounter ++;
            }

     }
