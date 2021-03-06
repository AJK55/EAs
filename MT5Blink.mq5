//+------------------------------------------------------------------+
//|                                                     MT5Blink.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2015, Dimitar Entchev"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
//#include <Expert\Expert.mqh>
//////--- available signals
//#include <Expert\Signal\SignalAC.mqh>
//////--- available trailing
//#include <Expert\Trailing\TrailingNone.mqh>
//////--- available money management
//#include <Expert\Money\MoneyFixedLot.mqh>
//#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
//--- inputs for expert
input string Expert_Title         ="MT5Blink"; // Document name
ulong        Expert_MagicNumber   =28506;      // 
bool         Expert_EveryTick     =false;      // 
//--- inputs for main signal
//input int    Signal_ThresholdOpen =10;         // Signal threshold value to open [0...100]
//input int    Signal_ThresholdClose=10;         // Signal threshold value to close [0...100]
//input double Signal_PriceLevel    =0.0;        // Price level to execute a deal
//input double Signal_StopLevel     =50.0;       // Stop Loss level (in points)
//input double Signal_TakeLevel     =50.0;       // Take Profit level (in points)
//input int    Signal_Expiration    =4;          // Expiration of pending orders (in bars)
//input double Signal_AC_Weight     =1.0;        // Accelerator Oscillator Weight [0...1.0]
////--- inputs for money
//input double Money_FixLot_Percent =10.0;       // Percent
//input double Money_FixLot_Lots    =0.1;        // Fixed volume

input   bool   configOpenBuyMarket = false; 
input   bool   configOpenBuyLimit = false; 
input   bool   configOpenBuyStop = false; 
input   bool   configOpenSellMarket = false; 
input   bool   configOpenSellLimit = false; 
input   bool   configOpenSellStop = false; 
input   double   configVolume = 0.01; 
//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+
//CExpert ExtExpert;
//+------------------------------------------------------------------+
//| Initialization function of the expert                            |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
   string symbol= Symbol();
   double bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   //double bid = Bid;
   //double ask = SYMBOL_ASK;
   double ask =NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double point = SymbolInfoDouble(_Symbol,SYMBOL_POINT);
   //double point  = Point;
   //int    digits = Digits;
   int digits = SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   
   
   //double spread = MarketInfo(symbol, MODE_SPREAD);
   //double spread = ask-bid;
   int spread = SymbolInfoInteger(symbol, SYMBOL_SPREAD);
   
   //double minstoplevel=MarketInfo(symbol,MODE_STOPLEVEL);
   
   int minstoplevel= SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL);
   double price = 0.0;
   double stopLoss = 0.0;
   double takeProfit = 0.0;
   double volume = configVolume;
   int orderBuyMarket=0;
   int orderBuyLimit=0;
   int orderBuyStop=0;
   int orderSellMarket=0;
   int orderSellLimit=0;
   int orderSellStop=0;
   bool   Result;

   
   MqlTradeRequest request     = {0};
   MqlTradeResult  result      = {0};
   MqlTick tick;

   
   // MARKET OPEN BUY
   if(configOpenBuyMarket)
   {
     
      request.action              = TRADE_ACTION_DEAL;            // setting a pending order
      request.magic               = Expert_MagicNumber;                  // ORDER_MAGIC
      request.symbol = symbol;
      request.volume = volume;
      request.sl                  = 0;                          
      request.tp                  = 0; 
      request.type = ORDER_TYPE_BUY;
      request.price  = ask;  
      request.deviation           = 5;                            // Slippage
      //orderBuyMarket=OrderSend(_Symbol,ORDER_TYPE_BUY,volume,price,0,stopLoss,takeProfit,"market buy",255,0,CLR_NONE);
      orderBuyMarket=OrderSend(request, result);
      

   }
      
      
   // MARKET OPEN BUY LIMIT
   if(configOpenBuyLimit)
   {
      price = NormalizeDouble(ask-minstoplevel*point,digits);
      //stopLoss=NormalizeDouble(price-2*spread*point,digits);
      //takeProfit = NormalizeDouble(price+2*spread*point, digits);
      //stopLoss=NormalizeDouble(price+2*spread*point,digits);
      //takeProfit = NormalizeDouble(price-2*spread*point, digits);
      request.action              = TRADE_ACTION_PENDING;            // setting a pending order
      request.magic               = Expert_MagicNumber;                  // ORDER_MAGIC
      request.symbol = symbol;
      request.volume = volume;
      request.sl                  = 0;                          
      request.tp                  = 0; 
      request.type = ORDER_TYPE_BUY_LIMIT;
      request.price  = price; 
      //orderBuyLimit=OrderSend(_Symbol,ORDER_TYPE_BUY_LIMIT,volume,price,0,stopLoss,takeProfit,"limit buy",255,0,CLR_NONE);
      orderBuyLimit=OrderSend(request, result);
    
   }
   
   
   // MARKET OPEN BUY STOP
   if(configOpenBuyStop)
   {
      price = NormalizeDouble(ask+minstoplevel*point,digits);
      //stopLoss=NormalizeDouble(price-2*spread*point,digits);
      //takeProfit = NormalizeDouble(price+2*spread*point, digits);
      request.action              = TRADE_ACTION_PENDING;            // setting a pending order
      request.magic               = Expert_MagicNumber;                  // ORDER_MAGIC
      request.symbol = symbol;
      request.volume = volume;
      request.sl                  = 0;                          
      request.tp                  = 0; 
      request.type = ORDER_TYPE_BUY_STOP;
      request.price  = price; 
      //orderBuyStop=OrderSend(_Symbol,OP_BUYSTOP,volume,price,0,stopLoss,takeProfit,"stop buy",255,0,CLR_NONE);
      orderBuyStop=OrderSend(request, result);
      
   }
    
   // MARKET OPEN SELL
   if(configOpenSellMarket)
   {
      price = bid;
      //stopLoss=NormalizeDouble(price+2*spread*point,digits);   
      //takeProfit = NormalizeDouble(price-2*spread*point, digits);
      stopLoss = 0.000;
      takeProfit = 0.000;
      request.action              = TRADE_ACTION_DEAL;            // setting a pending order
      request.magic               = Expert_MagicNumber;                  // ORDER_MAGIC
      request.symbol = symbol;
      request.volume = volume;
      request.sl                  = 0;                          
      request.tp                  = 0; 
      request.type = ORDER_TYPE_SELL;
      request.price  = price;
      request.deviation           = 5;                            // Slippage
      orderSellMarket=OrderSend(request, result);
      
      //orderSellMarket=OrderSend(_Symbol,OP_SELL,volume,price,0,stopLoss,takeProfit,"market sell",255,0,CLR_NONE);
   }
   
   
   // MARKET OPEN SELL LIMIT
   if(configOpenSellLimit)
   {
      price = NormalizeDouble(bid+minstoplevel*point,digits);
      stopLoss=NormalizeDouble(price+2*spread*point,digits);   
      takeProfit = NormalizeDouble(price-2*spread*point, digits);
      
      request.action              = TRADE_ACTION_PENDING;            // setting a pending order
      request.magic               = Expert_MagicNumber;                  // ORDER_MAGIC
      request.symbol = symbol;
      request.volume = volume;
      request.sl                  = stopLoss;                          
      request.tp                  = takeProfit; 
      request.type = ORDER_TYPE_SELL_LIMIT;
      request.price  = price; 
      orderSellLimit=OrderSend(request, result);
      //orderSellLimit=OrderSend(_Symbol,OP_SELLLIMIT,volume,price,0,stopLoss,takeProfit,"limit sell",255,0,CLR_NONE);
   }

   // MARKET OPEN SELL STOP
   if(configOpenSellStop)
   {
      price = NormalizeDouble(bid-minstoplevel*point,digits);
      stopLoss=NormalizeDouble(price+2*spread*point,digits);   
      takeProfit = NormalizeDouble(price-2*spread*point, digits);
      request.action              = TRADE_ACTION_PENDING;            // setting a pending order
      request.magic               = Expert_MagicNumber;                  // ORDER_MAGIC
      request.symbol = symbol;
      request.volume = volume;
      request.sl                  = stopLoss;                          
      request.tp                  = takeProfit; 
      request.type = ORDER_TYPE_SELL_STOP;
      request.price  = price; 
      orderSellStop=OrderSend(request, result);
      //orderSellStop=OrderSend(Symbol(),OP_SELLSTOP,volume,price,0,stopLoss,takeProfit,"stop sell",255,0,CLR_NONE);
   }
   
   /*
   // CLOSE BUY AT MARKET
   if(configCloseBuyMarket && (orderBuyMarket != -1))
   {
      Result=OrderClose(orderBuyMarket,volume,bid,1000,CLR_NONE);
   }
   
   
   // CLOSE SELL AT MARKET
   if(configCloseSellMarket && (orderSellMarket != -1))
   {
      Result=OrderClose(orderSellMarket,volume,ask,1000,CLR_NONE);
   }
   */
}
//+------------------------------------------------------------------+
