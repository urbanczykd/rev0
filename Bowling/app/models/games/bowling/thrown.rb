module Games
  module Bowling
    class Thrown < Hash
      class InValidScore < StandardError; end
      def initialize(knocked)
        valid?(knocked)
        self[:knocked] = knocked
      end

      def valid?(knocked)
        raise InValidScore.new("Knocked should be between 0 and 10") unless (0..10).include?(knocked)
        true
      end
    end
  end
end