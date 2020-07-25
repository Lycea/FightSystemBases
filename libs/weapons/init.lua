local BASE = (...) .. '.'
assert(not BASE:match('%.init%.$'), "Invalid require path `"..(...).."' (drop the `.init').")


return{
    base_weapon =   require(BASE .. 'weapons'),
    ranged      =   require(BASW .. "ranged")
    }