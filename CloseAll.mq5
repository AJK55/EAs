//+------------------------------------------------------------------+
//|                                            CloseAllPositions.mq4 |
//|                                Copyright © 2014, Dimitar Entchev |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2014, Dimitar Entchev"
#property link      "http://www.mql4.com"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
      Close_All_Orders();
      Close_All_Positions();

  }
//+------------------------------------------------------------------+

int Close_All_Orders()
   {
   bool   Result;
   int    i,Pos,Error,Total;
   CTrade *trade = new CTrade;
   ulong ticket;
   Total=OrdersTotal();
   //PositionsTotal
   if(Total>0)
      {
      for(i=Total-1; i>=0; i--) 
         {
         ticket = OrderGetTicket(i);
         if(ticket > 0)
            {
             Result =  trade.OrderDelete(ticket);
             //Result =  trade.PositionClose(ticket,-1);
               //Result=OrderClose(OrderGetTicket(),OrderLots(),Bid,1000,CLR_NONE);
               //else
               //Result=OrderClose(OrderGetTicket(),OrderLots(),Ask,1000,CLR_NONE);
               if(Result!=true) 
                  { 
                  Error=GetLastError(); 
                  Print("LastError = ",Error); 
                  }
               else Error=0;
               }
            }
         }
     
   return 0;
   }


int Close_All_Positions()
   {
   bool   Result;
   int    i,Pos,Error,Total;
   CTrade *trade = new CTrade;
   ulong ticket;
   Total=PositionsTotal();
   if(Total>0)
      {
      for(i=Total-1; i>=0; i--) 
         {
         ticket = PositionGetTicket(i);
         if(ticket > 0)
            {
             
             Result =  trade.PositionClose(ticket,-1);
               //Result=OrderClose(OrderGetTicket(),OrderLots(),Bid,1000,CLR_NONE);
               //else
               //Result=OrderClose(OrderGetTicket(),OrderLots(),Ask,1000,CLR_NONE);
               if(Result!=true) 
                  { 
                  Error=GetLastError(); 
                  Print("LastError = ",Error); 
                  }
               else Error=0;
               }
            }
         }
     
   return 0;
   }
