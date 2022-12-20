# encoding : utf-8

MoneyRails.configure do |config|
  config.default_currency = :usd
  config.rounding_mode = BigDecimal::ROUND_HALF_UP

  I18n.locale = :en
  Money.locale_backend = :i18n
end
