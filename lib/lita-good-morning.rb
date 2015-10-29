require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]
require 'active_support'
require 'active_support/core_ext'
require "lita/handlers/good_morning"

Lita::Handlers::GoodMorning.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
