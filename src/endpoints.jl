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
endpoint(::IndicesTopix) = JQUANTS_URI * "/indices/topix";
endpoint(::FinsStatements) = JQUANTS_URI * "/fins/statements";
endpoint(::FinsDividend) = JQUANTS_URI * "/fins/dividend";
endpoint(::FinsAnnouncement) = JQUANTS_URI * "/fins/announcement";
endpoint(::OptionIndexOption) = JQUANTS_URI * "/option/index_option";
