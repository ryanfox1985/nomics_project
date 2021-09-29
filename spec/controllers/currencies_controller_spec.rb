# frozen_string_literal: true

RSpec.describe CurrenciesController do
  1.upto(4).each do |i|
    describe "task#{i}" do
      it 'not crashes' do
        expect { get "task#{i}" }.not_to raise_error
      end
    end
  end
end
