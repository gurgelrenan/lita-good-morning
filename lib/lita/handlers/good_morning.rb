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
          'A quem chega, bom dia! Let\'s get to work!',
          'Let\'s do it to it pessoal! Bom Dia!',
          'Bundinha! Quer dizer.. Bom dia!',
          'Dia rapeizee!',
          'Dia dia dia diiiiaaa!',
          'Mais um dia começando, que esse seja ótimo galera!']

        on :connected, :check_if_its_hello_time

        route(/channel id/, :channel_id, command: true, help: 'Retorna o ID do canal')

        def initialize(*args)
          log.info 'Handler de bom dia inicializado!'
          @room = Lita::Source.new(room: 'C04TRPZDW') # General
          super
        end

        def channel_id(response)
          response.reply_with_mention response.message.source.room
        end

        def check_if_its_hello_time(*_)
          every(50) do |_|
            Time.zone = 'Brasilia' # Needed since this will run in another thread..

            # Todo dia de semana as 10 da manha...
            send_good_morning_message if Time.zone.now.strftime('%H:%M') == '10:00' &&
                                         ![0, 6].include?(Time.zone.now.wday)
          end
        end

        private

        def send_good_morning_message
          # Only one good morning per day :)
          return if redis.get 'gave_good_morning'

          robot.send_message(@room, MESSAGES.sample)

          redis.set 'gave_good_morning', true
          redis.expire 'gave_good_morning', 60
        end
    end

    Lita.register_handler(GoodMorning)
  end
end
