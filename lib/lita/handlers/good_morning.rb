module Lita
  module Handlers
    class GoodMorning < Handler
      route(/^echo\s+(.+)/, :echo, help: { "echo TEXT" => "Retorna de volta TEXT." })

      def echo(response)
        response.reply(response.matches)
      end
    end

    Lita.register_handler(GoodMorning)
  end
end
