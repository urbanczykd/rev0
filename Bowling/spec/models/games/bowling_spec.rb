require "spec_helper"

module Games
  module Bowling

      describe Thrown do
        context "errors" do
          it "should raise ArgumentError if no argument given" do
            expect{ Thrown.new }.to raise_error(ArgumentError)
          end

          it "should raise error if knock number > 10" do
            expect{ Thrown.new(11) }.to raise_error(Games::Bowling::Thrown::InValidScore)
          end

          it "should raise error if knock number > 0" do
            expect{ Thrown.new(-1) }.to raise_error(Games::Bowling::Thrown::InValidScore)
          end

        end

        context "valid thrown" do
          let(:thrown1) {Thrown.new(1)}

          it "should return object form Thrown class" do
            expect(thrown1.class).to eq(Games::Bowling::Thrown)
          end

          it "should return number of knocked pins" do
            expect(thrown1[:knocked]).to eq(1)
          end

        end

      end

  end
end