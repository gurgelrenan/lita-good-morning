module Lita
  module Handlers
    class GoodMorning < Handler
      MESSAGES = [
        'Bom dia galera!',
        'Goodie Goodie Morning pessoal!',
        'Que esse dia seja produtivo e delicioso! Bom dia amigos!',
        'Bom dia.. e alegria.. vamos sorrir e cantar! Dia galera!',
        'DIAAAAAAAAA',
        'Bão dia fi!',
        'Bom Bom Bom Bom diaaaaaaaaaa!',
        'Woof Woof! Bom dia!',
        'Good morning america!',
        "A quem chega, bom dia! Let's get to work!",
        "Let's do it to it pessoal! Bom Dia!",
        'Bundinha! Quer dizer.. Bom dia!',
        'Dia rapeizee!',
        'Dia dia dia diiiiaaa!',
        'Mais um dia começando, que esse seja ótimo galera!',
        'Vai dar certo mah!',
        'Bom dia, rapaziada!'
      ]

      on :connected, :check_if_its_hello_time

      #route(/channel id/, :channel_id, command: true, help: 'Retorna o ID do canal')

      def initialize(*args)
        log.info 'Handler de bom dia inicializado!'
        @room = Lita::Source.new(room: 'C04TRPZDW') # General
        super
      end

      # def channel_id(response)
      #   response.reply_with_mention response.message.source.room
      # end

      def check_if_its_hello_time(*)
        every(50) do
          set_time_zone # Needed since this will run in another thread.
          send_good_morning_message if right_time? && weekday?
        end
      end

      private

      def set_time_zone
        Time.zone = 'Brasilia'
      end

      # Send messages at 10 o'clock.
      def right_time?
        Time.zone.now.strftime('%H:%M') == '10:00'
      end

      # Send messages only on weekdays.
      def weekday?
        !Date.today.strftime('%A').match?(/sunday|saturday/i)
      end

      def send_good_morning_message
        # Only one good morning per day :)
        return if message_sent?

        robot.send_message(@room, MESSAGES.sample)

        set_message_sent
      end

      def set_message_sent
        redis.set 'gave_good_morning', true
        redis.expire 'gave_good_morning', 60
      end

      def message_sent?
        redis.get 'gave_good_morning'
      end
    end

    Lita.register_handler(GoodMorning)
  end
end
