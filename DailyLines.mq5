//+------------------------------------------------------------------+
//|  DailyLines.mq5                                                  |
//|  Tradeorado — Daily Lines                                        |
//|  Zeichnet Daily Lines: VTH, VTT, VTC, VTO, O, TH, TT              |
//+------------------------------------------------------------------+
//|  Beschreibung:                                                   |
//|  Dieser Indikator markiert täglich die wichtigsten Preisniveaus  |
//|  Tägliche Preisniveaus für den Intraday-Handel.                    |
//|                                                                  |
//|  Vortag-Levels (letzte N Stunden des Vortags, Label links):     |
//|  - VTH  Vortageshoch                                             |
//|  - VTT  Vortagestief                                             |
//|  - VTC  Vortages-Close (Close letzter M1-Bar vor SessionEnd)     |
//|  - VTO  Vortages-Open  (Open erster M1-Bar ab SessionStart)      |
//|                                                                  |
//|  Heute-Levels (ab konfigurierter Eröffnungszeit, Label rechts): |
//|  - O    Eröffnungskurs (Open des ersten M1-Bars ab SessionStart)  |
//|  - TH   Laufendes Tageshoch (ab SessionStart)                    |
//|  - TT   Laufendes Tagestief (ab SessionStart)                    |
//|                                                                  |
//|  Standard SessionStart: 08:00 (Futures) / SessionEnd: 17:30      |
//|  Konfigurierbar über InpSessionHour / InpSessionMinute.          |
//|                                                                  |
//|  Autor: tradeorado.de                                            |
//|  Weitere Indikatoren: https://tradeorado.de/indikatoren/         |
//+------------------------------------------------------------------+
#property copyright   "© 2026 tradeorado.de"
#property link        "https://tradeorado.de"
#property description "Zeichnet die wichtigsten Tagesniveaus für den Intraday-Handel:"
#property description "Vortag: VTH (Hoch), VTT (Tief), VTC (Close), VTO (Open)."
#property description "Heute: O (Eröffnung), TH (laufendes Hoch), TT (laufendes Tief)."
#property description "Session-Zeiten und Farben sind einstellbar."
#property version     "1.00"
#property indicator_chart_window
#property indicator_plots 0

//--- Inputs: Farben
input color InpColorVTH = clrOrange;    // VTH – Vortageshoch
input color InpColorVTT = clrAqua;      // VTT – Vortagestief
input color InpColorVTC = clrYellow;    // VTC – Vortages-Close
input color InpColorVTO = clrFuchsia;   // VTO – Vortages-Open
input color InpColorO   = clrWhite;     // O   – Eröffnungskurs (Session Open)
input color InpColorTH  = clrSilver;    // TH  – Tageshoch (laufend)
input color InpColorTT  = clrSilver;    // TT  – Tagestief (laufend)

//--- Inputs: Konfiguration
input int   InpLineWidth    = 1;        // Linienbreite
input int   InpHoursBack    = 2;        // Vortag: Stunden vor Tagesende für Linienstart
input int   InpSessionHour  = 8;        // Eröffnungszeit Stunde (Standard: 08 = Futures)
input int   InpSessionMinute    = 0;       // Eröffnungszeit Minute
input int   InpSessionEndHour   = 17;      // Session-End Stunde (Standard: 17 = XETRA-Schluss)
input int   InpSessionEndMinute = 30;      // Session-End Minute

//--- Prefix für alle Chart-Objekte dieses Indikators
string g_prefix = "DL_";

//+------------------------------------------------------------------+
//| Hilfsfunktion: Datum ohne Uhrzeit (Mitternacht)                  |
//+------------------------------------------------------------------+
datetime MidnightOf(datetime t)
{
   MqlDateTime s;
   TimeToStruct(t, s);
   s.hour = 0; s.min = 0; s.sec = 0;
   return StructToTime(s);
}

//+------------------------------------------------------------------+
//| Hilfsfunktion: Session-Open-Zeit für einen gegebenen Tag         |
//+------------------------------------------------------------------+
datetime SessionOpen(datetime day_midnight)
{
   MqlDateTime s;
   TimeToStruct(day_midnight, s);
   s.hour = InpSessionHour;
   s.min  = InpSessionMinute;
   s.sec  = 0;
   return StructToTime(s);
}

//+------------------------------------------------------------------+
//| Hilfsfunktion: Session-End-Zeit für einen gegebenen Tag          |
//+------------------------------------------------------------------+
datetime SessionEnd(datetime day_midnight)
{
   MqlDateTime s;
   TimeToStruct(day_midnight, s);
   s.hour = InpSessionEndHour;
   s.min  = InpSessionEndMinute;
   s.sec  = 0;
   return StructToTime(s);
}

//+------------------------------------------------------------------+
//| Hilfsfunktion: Linie zeichnen                                    |
//+------------------------------------------------------------------+
void DrawLine(string name, datetime t1, double p1, datetime t2, double p2,
              color clr, ENUM_LINE_STYLE style, int width, bool ray_right = false)
{
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_TREND, 0, t1, p1, t2, p2);

   ObjectSetInteger(0, name, OBJPROP_TIME,      0, t1);
   ObjectSetDouble (0, name, OBJPROP_PRICE,     0, p1);
   ObjectSetInteger(0, name, OBJPROP_TIME,      1, t2);
   ObjectSetDouble (0, name, OBJPROP_PRICE,     1, p2);
   ObjectSetInteger(0, name, OBJPROP_COLOR,     clr);
   ObjectSetInteger(0, name, OBJPROP_STYLE,     style);
   ObjectSetInteger(0, name, OBJPROP_WIDTH,     width);
   ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, ray_right);
   ObjectSetInteger(0, name, OBJPROP_RAY_LEFT,  false);
   ObjectSetInteger(0, name, OBJPROP_BACK,      true);
}

//+------------------------------------------------------------------+
//| Hilfsfunktion: Text-Label zeichnen                               |
//+------------------------------------------------------------------+
void DrawLabel(string name, datetime t, double price, string txt,
               color clr, ENUM_ANCHOR_POINT anchor)
{
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_TEXT, 0, t, price);

   ObjectSetInteger(0, name, OBJPROP_TIME,     t);
   ObjectSetDouble (0, name, OBJPROP_PRICE,    price);
   ObjectSetString (0, name, OBJPROP_TEXT,     txt);
   ObjectSetInteger(0, name, OBJPROP_COLOR,    clr);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
   ObjectSetInteger(0, name, OBJPROP_ANCHOR,   anchor);
   ObjectSetInteger(0, name, OBJPROP_BACK,     false);
}

//+------------------------------------------------------------------+
//| Alle Objekte dieses Indikators löschen                          |
//+------------------------------------------------------------------+
void DeleteAllObjects()
{
   int total = ObjectsTotal(0);
   for(int i = total - 1; i >= 0; i--)
   {
      string name = ObjectName(0, i);
      if(StringFind(name, g_prefix) == 0)
         ObjectDelete(0, name);
   }
}

//+------------------------------------------------------------------+
//| Hauptberechnungsfunktion                                         |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double   &open[],
                const double   &high[],
                const double   &low[],
                const double   &close[],
                const long     &tick_volume[],
                const long     &volume[],
                const int      &spread[])
{
   if(rates_total < 2) return 0;
   if(prev_calculated > 0 && prev_calculated == rates_total) return rates_total;

   DeleteAllObjects();

   //--- Vortag: Daily OHLC ---
   datetime midnight_yesterday    = iTime(Symbol(), PERIOD_D1, 1);
   datetime midnight_today        = iTime(Symbol(), PERIOD_D1, 0);
   datetime session_open_yesterday = SessionOpen(midnight_yesterday);
   datetime session_end_yesterday  = SessionEnd(midnight_yesterday);

   double vth = 0.0;
   double vtt = 0.0;
   double vto = 0.0;
   double vtc = 0.0;

   // VTO = Open des ersten M1-Bars ab Session-Start Vortag
   double vto_arr[];
   if(CopyOpen(Symbol(), PERIOD_M1, session_open_yesterday, session_open_yesterday + 60, vto_arr) > 0)
      vto = vto_arr[0];
   else
      vto = iOpen(Symbol(), PERIOD_D1, 1);

   // VTH/VTT = High/Low aller M1-Bars zwischen SessionStart und SessionEnd Vortag
   double vth_arr[], vtt_arr[];
   int vth_bars = CopyHigh(Symbol(), PERIOD_M1, session_open_yesterday, session_end_yesterday, vth_arr);
   int vtt_bars = CopyLow (Symbol(), PERIOD_M1, session_open_yesterday, session_end_yesterday, vtt_arr);
   if(vth_bars > 0) vth = vth_arr[ArrayMaximum(vth_arr)];
   if(vtt_bars > 0) vtt = vtt_arr[ArrayMinimum(vtt_arr)];
   // Fallback
   if(vth == 0.0) vth = iHigh(Symbol(), PERIOD_D1, 1);
   if(vtt == 0.0) vtt = iLow (Symbol(), PERIOD_D1, 1);

   // VTC = Close des letzten M1-Bars vor Session-End Vortag
   double vtc_arr[];
   if(CopyClose(Symbol(), PERIOD_M1, session_end_yesterday - 60, session_end_yesterday, vtc_arr) > 0)
      vtc = vtc_arr[ArraySize(vtc_arr) - 1];
   else
      vtc = iClose(Symbol(), PERIOD_D1, 1);

   //--- Heute: Session-Eröffnungszeit ---
   datetime session_open_today = SessionOpen(midnight_today);

   // O = Open des ersten M1-Bars ab SessionStart (konfigurierbare Session-Zeit)
   // TH/TT = High/Low aller Bars ab SessionStart
   double ek = 0.0;
   double th = 0.0;
   double tt = 0.0;
   datetime t_now = time[rates_total - 1];

   // O = Open des ersten M1-Bars ab SessionStart
   double o_arr[];
   if(CopyOpen(Symbol(), PERIOD_M1, session_open_today, session_open_today + 60, o_arr) > 0)
      ek = o_arr[0];
   else
      ek = iOpen(Symbol(), PERIOD_D1, 0);  // Fallback

   // TH/TT aus M1-Bars ab SessionStart bis jetzt
   double th_arr[], tt_arr[];
   int m1_bars = CopyHigh(Symbol(), PERIOD_M1, session_open_today, t_now, th_arr);
   int m1_bars2 = CopyLow (Symbol(), PERIOD_M1, session_open_today, t_now, tt_arr);
   if(m1_bars > 0)
   {
      th = th_arr[ArrayMaximum(th_arr)];
      tt = tt_arr[ArrayMinimum(tt_arr)];
   }
   else
   {
      th = ek;
      tt = ek;
   }

   //--- VORTAG-LINIEN: letzte N Stunden des Vortags ---
   // Vortag-Linien: InpHoursBack Stunden vor Session-End bis Session-End
   datetime vt_line_start = session_end_yesterday - (datetime)(InpHoursBack * 3600);
   if(vt_line_start < session_open_yesterday)
      vt_line_start = session_open_yesterday;

   // VTH
   DrawLine(g_prefix+"VTH_line", vt_line_start, vth, session_end_yesterday, vth,
            InpColorVTH, STYLE_DASH, InpLineWidth, true);
   DrawLabel(g_prefix+"VTH_lbl", t_now, vth,
             "VTH "+DoubleToString(vth, _Digits), InpColorVTH, ANCHOR_LEFT);

   // VTT
   DrawLine(g_prefix+"VTT_line", vt_line_start, vtt, session_end_yesterday, vtt,
            InpColorVTT, STYLE_DASH, InpLineWidth, true);
   DrawLabel(g_prefix+"VTT_lbl", t_now, vtt,
             "VTT "+DoubleToString(vtt, _Digits), InpColorVTT, ANCHOR_LEFT);

   // VTC
   DrawLine(g_prefix+"VTC_line", vt_line_start, vtc, session_end_yesterday, vtc,
            InpColorVTC, STYLE_DOT, InpLineWidth, true);
   DrawLabel(g_prefix+"VTC_lbl", t_now, vtc,
             "VTC "+DoubleToString(vtc, _Digits), InpColorVTC, ANCHOR_LEFT);

   // VTO
   DrawLine(g_prefix+"VTO_line", vt_line_start, vto, session_end_yesterday, vto,
            InpColorVTO, STYLE_DOT, InpLineWidth, true);
   DrawLabel(g_prefix+"VTO_lbl", t_now, vto,
             "VTO "+DoubleToString(vto, _Digits), InpColorVTO, ANCHOR_LEFT);

   //--- HEUTE-LINIEN: ab SessionStart bis aktuellem Bar ---

   // O (fix auf Session-Open-Niveau)
   DrawLine(g_prefix+"O_line", session_open_today, ek, t_now, ek,
            InpColorO, STYLE_SOLID, InpLineWidth);
   DrawLabel(g_prefix+"O_lbl", t_now, ek,
             "O  "+DoubleToString(ek, _Digits), InpColorO, ANCHOR_LEFT);

   // TH (laufendes Hoch ab SessionStart)
   DrawLine(g_prefix+"TH_line", session_open_today, th, t_now, th,
            InpColorTH, STYLE_SOLID, InpLineWidth);
   DrawLabel(g_prefix+"TH_lbl", t_now, th,
             "TH "+DoubleToString(th, _Digits), InpColorTH, ANCHOR_LEFT);

   // TT (laufendes Tief ab SessionStart)
   DrawLine(g_prefix+"TT_line", session_open_today, tt, t_now, tt,
            InpColorTT, STYLE_SOLID, InpLineWidth);
   DrawLabel(g_prefix+"TT_lbl", t_now, tt,
             "TT "+DoubleToString(tt, _Digits), InpColorTT, ANCHOR_LEFT);

   ChartRedraw(0);
   return rates_total;
}

//+------------------------------------------------------------------+
//| Aufräumen beim Entfernen                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   DeleteAllObjects();
   ChartRedraw(0);
}
//+------------------------------------------------------------------+