# Daily Lines – Tagesniveaus für den Intraday-Handel

**Autor:** tradeorado.de
**Website:** https://tradeorado.de
**Plattform:** MetaTrader 5 (Indikator, Chartfenster)
**Version:** 1.00

## Kurzbeschreibung

Daily Lines zeichnet die wichtigsten Tagesniveaus als horizontale Linien in den Preischart: vier Niveaus des Vortags und drei Niveaus des laufenden Tages. Jede Linie trägt ein Label mit Kürzel und aktuellem Preis.

## Vortag-Levels

Berechnet aus den M1-Bars zwischen Session-Start und Session-Ende des Vortags. Die Linien sind gestrichelt bzw. gepunktet und nach rechts verlängert.

| Kürzel | Bedeutung | Berechnung |
|---|---|---|
| VTH | Vortageshoch | Höchstes High der Vortags-Session |
| VTT | Vortagestief | Tiefstes Low der Vortags-Session |
| VTC | Vortages-Close | Close des letzten M1-Bars vor Session-Ende |
| VTO | Vortages-Open | Open des ersten M1-Bars ab Session-Start |

Die Linien beginnen eine einstellbare Zahl von Stunden vor dem Session-Ende des Vortags.

## Heute-Levels

Durchgezogene Linien vom heutigen Session-Start bis zum aktuellen Bar.

| Kürzel | Bedeutung |
|---|---|
| O | Eröffnungskurs (Open des ersten M1-Bars ab Session-Start) |
| TH | Laufendes Tageshoch seit Session-Start |
| TT | Laufendes Tagestief seit Session-Start |

## Einstellungen

| Parameter | Standard | Bedeutung |
|---|---|---|
| Farben (VTH, VTT, VTC, VTO, O, TH, TT) | siehe Indikator | Farbe je Linie |
| InpLineWidth | 1 | Linienbreite |
| InpHoursBack | 2 | Vortag: Stunden vor Session-Ende für den Linienstart |
| InpSessionHour / InpSessionMinute | 08:00 | Session-Start (Standard: Futures) |
| InpSessionEndHour / InpSessionEndMinute | 17:30 | Session-Ende (Standard: XETRA-Schluss) |

## Hinweise

- Die Berechnung nutzt M1-Daten. Fehlen diese, greift der Indikator auf Tageswerte (D1) zurück.
- Der Indikator zeichnet nur Chart-Objekte (Prefix `DL_`). Er liefert keine Signale, Alerts oder Indikatorpuffer.
- Beim Entfernen werden alle eigenen Objekte gelöscht.
- Die Session-Zeiten beziehen sich auf die Serverzeit des Brokers.
- Kein Anlageratschlag. Handel mit Finanzinstrumenten ist mit Verlustrisiko verbunden.

## Mehr von tradeorado.de

Weitere Indikatoren: https://tradeorado.de/indikatoren/
