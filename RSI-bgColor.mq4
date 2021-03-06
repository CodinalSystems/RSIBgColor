//+------------------------------------------------------------------+
//|                                                  RSI-bgColor.mq4 |
//|                                                  Codinal Systems |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Codinal Systems"
#property link      "https://codinal-systems.com/"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_style1 DRAW_LINE
#property indicator_minimum  0      // サブウインドウ高さ最小値
#property indicator_maximum  100    // サブウインドウ高さ最大値


extern string bgColor_SETTING = ""; //-----背景色の設定-----
input color defaultColor = clrBlack; //変更前の背景色
input color changeColor = clrDarkBlue; //変更後の背景色

extern string margin1=""; //　
extern string RSI_SETTING = ""; //-----RSIの設定-----
input double Sell_Level = 70.0; //上のRSIレベル
input double Buy_Level = 30.0; //下のRSIレベル
input int RSI_PERIOD = 14; //RSIの期間
input ENUM_APPLIED_PRICE RSI_TYPE = PRICE_CLOSE; //RSIの適用価格
input color RSI_COLOR = clrRed; //RSIの色

extern string margin2=""; //　
extern string ALERT_SETTING = ""; //-----Alertの設定-----
input bool AlertON = true; //アラート
input string alertMessage = "RSI ALERT!!"; //アラートメッセージ


datetime AlertFlag;
double RSI_Buf[];

int OnInit()
  {
 
   SetIndexBuffer(0, RSI_Buf);
   SetIndexStyle(0, EMPTY, EMPTY, 1, RSI_COLOR);
   IndicatorSetInteger(INDICATOR_LEVELS,2);
   SetLevelValue(0,Sell_Level);
   SetLevelValue(1,Buy_Level);
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  
   int limit = rates_total - prev_calculated - 1;
   if(limit < 0) limit = 0;
   
   for(int icount = limit; icount >= 0; icount--){
      RSI_Buf[icount] = iRSI(Symbol(), Period(), RSI_PERIOD, RSI_TYPE, icount);
   }
  
   double RSI = iRSI(Symbol(), Period(), RSI_PERIOD, RSI_TYPE, 0);

   if (RSI <= Buy_Level || RSI >= Sell_Level){
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, changeColor);
      if (AlertON && AlertFlag != iTime(NULL,NULL,0)){
            Alert(Symbol()," ",alertMessage);
            AlertFlag = iTime(NULL,NULL,0);
      }
      
   }else{
      //条件を満たさない場合は、元にの色に戻すことを忘れずに
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, defaultColor);
   }
   
   return(rates_total);
  }
//+------------------------------------------------------------------+
