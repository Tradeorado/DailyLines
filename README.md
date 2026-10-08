# Daily Lines

MetaTrader 5 indicator that draws key daily price levels on the chart: four levels from the previous day and three from the current day. Every line is labeled with its abbreviation and current price.

*Deutsche Beschreibung: [MQL5_Beschreibung.md](MQL5_Beschreibung.md) · English description: [MQL5_Description_EN.md](MQL5_Description_EN.md)*

## Levels

**Previous day** (dashed/dotted, extended to the right, calculated from M1 bars of the previous session)

| Label | Meaning |
|---|---|
| VTH | Previous day high |
| VTT | Previous day low |
| VTC | Previous day close |
| VTO | Previous day open |

**Current day** (solid, from session start to the current bar)

| Label | Meaning |
|---|---|
| O | Session open |
| TH | Running high of the day |
| TT | Running low of the day |

## Installation

1. In MetaTrader 5: `File → Open Data Folder → MQL5 → Indicators`.
2. Copy `DailyLines.mq5` into that folder.
3. Compile it in MetaEditor (F7) or restart MetaTrader.
4. Drag **DailyLines** from the Navigator onto a chart.

## Inputs

| Parameter | Default | Description |
|---|---|---|
| `InpColorVTH/VTT/VTC/VTO/O/TH/TT` | Orange / Aqua / Yellow / Fuchsia / White / Silver / Silver | Color per line |
| `InpLineWidth` | 1 | Line width |
| `InpHoursBack` | 2 | Previous day: hours before session end where lines start |
| `InpSessionHour` / `InpSessionMinute` | 08:00 | Session start (default: futures) |
| `InpSessionEndHour` / `InpSessionEndMinute` | 17:30 | Session end (default: XETRA close) |

## Notes

- Uses M1 data; falls back to D1 values if M1 is unavailable.
- Draws chart objects only (prefix `DL_`). No signals, alerts or buffers. Objects are removed with the indicator.
- Session times refer to broker server time.
- Not investment advice. Trading involves risk of loss.

## Links

[tradeorado.de](https://tradeorado.de) · [More indicators](https://tradeorado.de/indikatoren/)
