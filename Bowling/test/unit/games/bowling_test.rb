require File.expand_path(File.dirname(__FILE__) + '/../../test_helpers/bowling_test_helper')
require './app/models/games/bowling/game'
require './app/models/games/bowling/frame'
require './app/models/games/bowling/thrown'
require 'debugger'

module Games
  module Bowling

    class ThrownTest < ActiveSupport::TestCase

      def test_should_raise_error_if_no_argument_given
        assert_raises ArgumentError do
          Thrown.new
        end
      end

      def test_should_return_number_of_knocked_pins
        thrown = Thrown.new(3)
        assert_equal 3, thrown[:knocked]
      end

      def test_should_raise_error_if_numer_is_not_in_range_between_0_and_10
        assert_raises Games::Bowling::Thrown::InValidScore do
          Thrown.new(-1)
        end
        assert_raises Games::Bowling::Thrown::InValidScore do
          Thrown.new(11)
        end
      end

    end

    class FrameTest < ActiveSupport::TestCase

      setup do
        @thrown3 =  Thrown.new(3)
        @thrown10 = Thrown.new(10)
        @thrown0 =  Thrown.new(0)
      end

      def test_should_create_normal_freame_in_true_or_nothing_is_pass
        frame = Frame.new
        #{:type=>nil, :score=>0, :throwns=>[[], []]}
        assert_equal nil,     frame[:type]
        assert_equal 0,       frame[:score]
        assert_equal [],      frame[:throwns]
      end

     end

    class GameTest  < ActiveSupport::TestCase
      setup do
        @game     = Game.new
        @thrown0  = Thrown.new(0)
        @thrown1  = Thrown.new(1)
        @thrown2  = Thrown.new(2)
        @thrown3  = Thrown.new(3)
        @thrown4  = Thrown.new(4)
        @thrown5  = Thrown.new(5)
        @thrown6  = Thrown.new(6)
        @thrown7  = Thrown.new(7)
        @thrown8  = Thrown.new(8)
        @thrown9  = Thrown.new(9)
        @thrown10 = Thrown.new(10)
      end

      def test_should_create_game_with_normal_frame
        assert_equal [{:type=>nil, :score=>0, :throwns=>[]}],  Game.new
      end

      def test_game_should_be_instance_of_game
        #this is stupid :/ but just in case if i will make some othere structure with modules ...
        assert_equal Games::Bowling::Game, Game.new.class
      end

      # #thrown this should be in context to look nicer

      def test_should_save_thrown_number_to_game
        @game.knock(@thrown1)
        assert_equal [{:type=>nil, :score=>1, :throwns=>[1]}], @game
        @game.knock(@thrown3)
        assert_equal [{:type=>nil, :score=>4, :throwns=>[1, 3]}, {:type=>nil, :score=>0, :throwns=>[]}], @game
      end

      #creating new frames

      def test_should_create_new_frame_if_first_was_end
        @game.knock(@thrown1)
        assert_equal [{:type=>nil, :score=>1, :throwns=>[1]}], @game
        @game.knock(@thrown3)
        assert_equal [{:type=>nil, :score=>4, :throwns=>[1, 3]}, {:type=>nil, :score=>0, :throwns=>[]}], @game
        @game.knock(@thrown3)
        assert_equal [{:type=>nil, :score=>4, :throwns=>[1, 3]}, {:type=>nil, :score=>3, :throwns=>[3]}], @game
      end

      def test_should_set_type_to_strike_and_create_new_frame
        @game.knock(@thrown10)
        assert_equal [{:type=>"strike", :score=>10, :throwns=>[10]}, {:type=>nil, :score=>0, :throwns=>[]}], @game
      end

      def test_should_set_type_to_spare_and_create_new_frame
        @game.knock(@thrown7)
        assert_equal [{:type=>nil, :score=>7, :throwns=>[7]}], @game
        @game.knock(@thrown3)
        assert_equal [{:type=>"spare", :score=>10, :throwns=>[7, 3]}, {:type=>nil, :score=>0, :throwns=>[]}], @game
      end

      # calculation cases #1
      # the most points that can be scored in a single frame is 30 points (10 for the original strike, plus strikes in the two subsequent frames).

      # Frame 1, ball 1: 10 pins (strike)
      # Frame 2, ball 1: 3 pins
      # Frame 2, ball 2: 6 pins
      # The total score from these throws is:
      # Frame one: 10 + (3 + 6) = 19
      # Frame two: 3 + 6 = 9
      # TOTAL = 28

      def test_should_calculate_case_1
        @game.knock(@thrown10)
        assert_equal [{:type=>"strike", :score=>10, :throwns=>[10]}, {:type=>nil, :score=>0, :throwns=>[]}], @game
        @game.knock(@thrown3)
        assert_equal [{:type=>"strike", :score=>13, :throwns=>[10]}, {:type=>nil, :score=>3, :throwns=>[3]}], @game
        @game.knock(@thrown6)
        assert_equal [{:type=>"strike", :score=>19, :throwns=>[10]}, {:type=>nil, :score=>9, :throwns=>[3, 6]}, {:type=>nil, :score=>0, :throwns=>[]}], @game
        assert_equal 28, @game.total
      end

      # calculation for case #
      # Frame 1, ball 1: 7 pins
      # Frame 1, ball 2: 3 pins (spare)
      # Frame 2, ball 1: 4 pins
      # Frame 2, ball 2: 2 pins
      # The total score from these throws is:
      # Frame one: 7 + 3 + 4 (bonus) = 14
      # Frame two: 4 + 2 = 6
      # TOTAL = 20

      def test_should_calculate_case_2
        @game.knock(@thrown7)
        @game.knock(@thrown3)
        assert_equal [{:type=>"spare", :score=>10, :throwns=>[7, 3]}, {:type=>nil, :score=>0, :throwns=>[]}], @game
        @game.knock(@thrown4)                 
        assert_equal [{:type=>"spare", :score=>14, :throwns=>[7, 3]}, {:type=>nil, :score=>4, :throwns=>[4]}], @game
        @game.knock(@thrown2)
        assert_equal [{:type=>"spare", :score=>14, :throwns=>[7, 3]}, {:type=>nil, :score=>6, :throwns=>[4, 2]}, {:type=>nil, :score=>0, :throwns=>[]}], @game
        assert_equal 20, @game.total
      end

      # calculation for case 4
      # Frame 1, ball 1: 10 pins (Strike)
      # Frame 2, ball 1: 10 pins (Strike)
      # Frame 3, ball 1: 9 pins
      # Frame 3, ball 2: 0 pins (recorded as a dash '-' or '0' on the scoresheet)
      # The total score from these throws is:
      # Frame one: 10 + (10 + 9) = 29
      # Frame two: 10 + (9 + 0) = 19
      # Frame three: 9 + 0 = 9
      # TOTAL = 57

      def test_should_calculate_case_3
        @game.knock(@thrown10)
        assert_equal [{:type=>"strike", :score=>10, :throwns=>[10]}, {:type=>nil, :score=>0, :throwns=>[]}], @game
        assert_equal 10, @game.total
        @game.knock(@thrown10)
        assert_equal [{:type=>"strike", :score=>20, :throwns=>[10]}, {:type=>"strike", :score=>10, :throwns=>[10]}, {:type=>nil, :score=>0, :throwns=>[]}], @game
        assert_equal 30, @game.total
        @game.knock(@thrown9)
        assert_equal [{:type=>"strike", :score=>29, :throwns=>[10]}, {:type=>"strike", :score=>19, :throwns=>[10]}, {:type=>nil, :score=>9, :throwns=>[9]}], @game
        assert_equal 57, @game.total
        @game.knock(@thrown0)
        assert_equal [{:type=>"strike", :score=>29, :throwns=>[10]}, {:type=>"strike", :score=>19, :throwns=>[10]}, {:type=>nil, :score=>9, :throwns=>[9, 0]}, {:type=>nil, :score=>0, :throwns=>[]}], @game
        assert_equal 57, @game.total
      end

      def test_should_check_300_case
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          assert_equal 300, @game.total
      end

      def test_check_spare_end
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown10)
          @game.knock(@thrown9)
          @game.knock(@thrown1)
          assert_equal 269, @game.total
      end

      def test_should_raise_error_if_more_then_10_pins_are_knocked
        @game.knock(@thrown8)
        assert_raises Games::Bowling::Game::PinNumberExceeded do
          @game.knock(@thrown3)
        end
      end

    end
  end
end

