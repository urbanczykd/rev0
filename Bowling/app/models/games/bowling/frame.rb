module Games
  module Bowling
    class Frame < Hash

      def initialize
        self[:type]    = nil
        self[:score]   = 0
        self[:throwns] = []
      end

      def knock(thrown)
        self[:throwns].push(thrown[:knocked])
        self[:type]  = type(thrown[:knocked])
        self[:score] = calc 
      end

      def thrown
        self[:throwns].count
      end

      def calc
       self[:throwns].inject(:+) || 0
      end

      def spare?
        self[:type] == "spare"
      end

      def strike?
        self[:type] == "strike"
      end

      private

      def type(val)
        if calc == 10 && self[:throwns].count == 2
          "spare"
        elsif val == 10 && self[:throwns].count == 1
          "strike"
        end
      end


    end

  end
end