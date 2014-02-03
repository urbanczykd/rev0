module Games
  module Bowling
    class Game < Array
      class FramsNumberExceeded < StandardError; end
      class UnknownStructure    < StandardError; end
      class PinNumberExceeded   < StandardError; end

      MAX_FRAMES = 10
      MAX_PINS   = 10

      def initialize
        push(::Games::Bowling::Frame.new)
      end

      def push(value)
        super(value) if valid?(value)
      end

      def knock(value)
        if last_strike?
          if last[:throwns].first == 10
            # 300 score strike
            last.knock(value) if last[:throwns].count < 3
          else
            raise PinNumberExceeded.new("You can't thrown more then 10 pins") if last.calc + value[:knocked] > 10
            last.knock(value) if last[:throwns].count < 2
          end
        else
          raise PinNumberExceeded.new("You can't thrown more then 10 pins") if last.calc + value[:knocked] > 10
          last.knock(value)
        end
        push(::Games::Bowling::Frame.new) if create_new_frame?
        recalculate_scores
      end

      def total
        map{|frame| frame[:score]}.inject(:+)
      end

      private

      def last_frame?
        count == 10
      end

      def last_strike?
        last[:throwns].first == 10
      end

      def recalculate_scores
        frames = reject{|frame| frame[:throwns].blank?}.last(3)
        frames.each_with_index do |frame, index|
          balls = frames[index..-1].map{|fr| fr[:throwns]}.flatten
          if frame.strike? || frame.spare?
            frame[:score] = balls.take(3).inject(:+)
          end
        end
      end

      def create_new_frame?
        if (last.thrown == 2) && pins_left?
          true
        elsif !pins_left? && size < MAX_FRAMES
          true
        else
          false
        end
      end

      def pins_left?
        last.calc < MAX_PINS
      end

      def valid?(value)
        raise UnknownStructure.new("Game works only with Frame structure") if !is_frame?(value)
        true
      end

      def is_frame?(value)
        value.is_a?(::Games::Bowling::Frame)
      end

    end
  end
end

#game = ::Games::Bowling::Game.new; k = ::Games::Bowling::Thrown.new(3); game.knock(k)
#k = ::Games::Bowling::Thrown.new(4); game.knock(k)

# the most points that can be scored in a single frame is 30 points (10 for the original strike, plus strikes in the two subsequent frames).