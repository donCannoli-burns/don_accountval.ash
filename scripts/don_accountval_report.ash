// Don Accountval v1: independent, explicitly invoked read-only valuation probe.
// Unlike legacy accountval, this does not import CFStat/zlib or fetch account pages.
// No file writes, Kmail, purchases, item movement or automatic relay capture.
// call don_accountval_report.ash item_value 1000000 [--market] [--quiet|--print|--diff]
//
// --market explicitly opts into potentially slow KoLmafia mall price queries.
// Without --market values are AUT OSELL-ONLY, not market worth or realized profit.

void main(string args)
{
  string [int] parts = split_string(args, " ");
  string action = parts[0];
  if(action == "" || action == "help")
  {
    print("Don Accountval: item_value <minimum-meat> [--market] [--quiet|--print|--diff]");
    print("Read-only estimated prices. No relay hook, recording, purchases or transfers.");
    return;
  }
  if(action != "item_value" && action != "status")
  {
    print("Don Accountval: unsupported command; no action taken.", "red");
    return;
  }
  if(action == "status")
  {
    print("Don Accountval v1: manual cached/market valuation; source recording OFF.");
    return;
  }
  if(parts[1] != "" && to_string(to_int(parts[1])) != parts[1])
  {
    print("Minimum value must be a nonnegative integer.", "red");
    return;
  }
  int threshold = to_int(parts[1]);
  if(threshold < 0)
  {
    print("Minimum value must not be negative.", "red");
    return;
  }
  boolean useMarket = index_of(args, "--market") >= 0;
  boolean quiet = index_of(args, "--quiet") >= 0 && index_of(args, "--print") < 0;
  boolean diff = index_of(args, "--diff") >= 0;
  if(diff)
    print("KNOWN_UNKNOWN: no prior scoped item-value snapshot for comparison.", "orange");
  if(useMarket)
    print("Explicit --market: mall price lookups may cause network requests and take time.", "orange");
  string prefix = "donstate:v1:" + my_id() + ":" + today_to_string() +
    ":" + my_ascensions();
  int inspected = 0;
  int matches = 0;
  int quotes = 0;
  foreach it in $items[]
  {
    int qty = item_amount(it) + closet_amount(it) + storage_amount(it) +
      display_amount(it) + equipped_amount(it) + shop_amount(it);
    if(qty <= 0)
      continue;
    inspected += 1;
    int unitPrice = autosell_price(it);
    if(useMarket && it.tradeable && quotes < 100)
    {
      int market = mall_price(it);
      quotes += 1;
      if(market > 0)
        unitPrice = market;
    }
    if(unitPrice < 0)
      continue;
    // Guard integer overflow by checking upper bound before multiplication.
    if(unitPrice > 0 && qty > 2147483647 / unitPrice)
    {
      print("KNOWN_UNKNOWN: valuation overflow for item id " + to_int(it), "orange");
      continue;
    }
    int estimated = qty * unitPrice;
    if(estimated < threshold)
      continue;
    matches += 1;
    if(!quiet)
      print(prefix + ":economy:item/" + to_int(it) +
        ":estimated_meat = " + estimated + " (" + qty + "x " + it +
        ", " + (useMarket ? "mixed market/autosell" : "autosell-only") + ")");
  }
  print("Don Accountval observed " + inspected + " owned types; " + matches +
    " met minimum " + threshold + " Meat. " +
    (useMarket ? quotes + " market quotes (capped at 100)." : "No market requests."));
  print("Estimates are NOT realized profit or an account transaction receipt.");
}
