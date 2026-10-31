# accountval.ash
A script for measuring the approximate value of your Kingdom of Loathing account, based on current market values

Uses [zlib](http://kolmafia.us/showthread.php?2072-ZLib-Zarqon-s-useful-function-library) and [CFStat](http://kolmafia.us/showthread.php?9947-ManageStore-and-CFStat-Weed-out-your-store)

# Installation
Run this command in the graphical CLI in KoLmafia:
<pre>
svn checkout https://github.com/soolar/accountval.ash/branches/release/
</pre>

# Usage
Run this command in the graphical CLI in KoLmafia:
<pre>
accountval.ash
</pre>

## Don Report v1 — fork-owned manual valuation probe

**Important:** this fork's `master` has no executable upstream accountval source or `release` branch at present. The new source-only `scripts/don_accountval_report.ash` is intentionally **independent** of the legacy ZLib/CFStat workflow; use `call don_accountval_report.ash item_value 1000000 --quiet` after installing it in a test KoLmafia profile. Without `--market` it computes local **autosell-only estimates**, **not** accurate market value or realized profit. Explicit `--market` allows up to 100 potentially slow mall-price lookups. The collector does not use the mall, buy/sell, send Kmail, write files, or enable hooks. `--diff` reports **KNOWN_UNKNOWN** without a prior verified snapshot. Canonical node/record syntax is governed by [Don KoLFix](https://github.com/donCannoli-burns/don_kolfix/blob/main/docs/don-report-v1.md); no automatic writer or relay listener is wired.

