function endpoint(::Any)
    error("endpoint not implemented for this type")
end

endpoint(::TokenAuthUser) = JQUANTS_URI * "/token/auth_user";
endpoint(::TokenAuthRefresh) = JQUANTS_URI * "/token/auth_refresh";
endpoint(::ListedInfo) = JQUANTS_URI * "/listed/info";
endpoint(::PricesDailyQuotes) = JQUANTS_URI * "/prices/daily_quotes";
endpoint(::PricesAM) = JQUANTS_URI * "/prices/prices_am";
endpoint(::MarketsTradeSpec) = JQUANTS_URI * "/markets/trades_spec";
endpoint(::MarketsWeeklyMarginInterest) = JQUANTS_URI * "/markets/weekly_margin_interest";
endpoint(::MarketsShortSelling) = JQUANTS_URI * "/markets/short_selling";
endpoint(::MarketsBreakdown) = JQUANTS_URI * "/markets/breakdown";
endpoint(::TradingCalendar) = JQUANTS_URI * "/markets/trading_calendar";
endpoint(::Indices) = JQUANTS_URI * "/indices";
endpoint(::IndicesTopix) = JQUANTS_URI * "/indices/topix";
endpoint(::FinsStatements) = JQUANTS_URI * "/fins/statements";
endpoint(::FinsDividend) = JQUANTS_URI * "/fins/dividend";
endpoint(::FinsAnnouncement) = JQUANTS_URI * "/fins/announcement";
endpoint(::FinsDetails) = JQUANTS_URI * "/fins/fs_details";
endpoint(::OptionIndexOption) = JQUANTS_URI * "/option/index_option";



function jsonkeyname(::Any)
    error("jsonkeyname not implemented for this type")
end

jsonkeyname(::ListedInfo) = "info";
jsonkeyname(::PricesDailyQuotes) = "daily_quotes";
jsonkeyname(::PricesAM) = "prices_am";
jsonkeyname(::MarketsTradeSpec) = "trades_spec";
jsonkeyname(::MarketsWeeklyMarginInterest) = "weekly_margin_interest";
jsonkeyname(::MarketsShortSelling) = "short_selling";
jsonkeyname(::MarketsBreakdown) = "breakdown";
jsonkeyname(::TradingCalendar) = "trading_calendar";
jsonkeyname(::Indices) = "indices";
jsonkeyname(::IndicesTopix) = "topix";
jsonkeyname(::FinsStatements) = "statements";
jsonkeyname(::FinsDividend) = "dividend";
jsonkeyname(::FinsAnnouncement) = "announcement";
jsonkeyname(::FinsDetails) = "fs_details";
jsonkeyname(::OptionIndexOption) = "index_option";
