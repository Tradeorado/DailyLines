# Daily Lines – Key Daily Price Levels for Intraday Trading

**Author:** tradeorado.de
**Website:** https://tradeorado.de
**Platform:** MetaTrader 5 (indicator, chart window)
**Version:** 1.00

## Summary

Daily Lines draws the most important daily price levels as horizontal lines on the price chart: four levels from the previous day and three levels from the current day. Each line carries a label with its abbreviation and current price.

## Previous-Day Levels

Calculated from the M1 bars between session start and session end of the previous day. Lines are dashed or dotted and extended to the right.

| Label | Meaning | Calculation |
|---|---|---|
| VTH | Previous day high | Highest high of the previous session |
| VTT | Previous day low | Lowest low of the previous session |
| VTC | Previous day close | Close of the last M1 bar before session end |
| VTO | Previous day open | Open of the first M1 bar from session start |

The lines start a configurable number of hours before the previous day's session end.

## Current-Day Levels

Solid lines from today's session start to the current bar.

| Label | Meaning |
|---|---|
| O | Session open (open of the first M1 bar from session start) |
| TH | Running high of the day since session start |
| TT | Running low of the day since session start |

## Inputs

| Parameter | Default | Description |
|---|---|---|
| Colors (VTH, VTT, VTC, VTO, O, TH, TT) | see indicator | Color per line |
| InpLineWidth | 1 | Line width |
| InpHoursBack | 2 | Previous day: hours before session end where lines start |
| InpSessionHour / InpSessionMinute | 08:00 | Session start (default: futures) |
| InpSessionEndHour / InpSessionEndMinute | 17:30 | Session end (default: XETRA close) |

## Notes

- Calculation uses M1 data. If M1 data is unavailable, the indicator falls back to daily (D1) values.
- The indicator only draws chart objects (prefix `DL_`). It provides no signals, alerts or indicator buffers.
- All of its objects are removed when the indicator is removed.
- Session times refer to the broker's server time.
- Not investment advice. Trading financial instruments involves risk of loss.

## More from tradeorado.de

More indicators: https://tradeorado.de/indikatoren/
