# frozen_string_literal: true

module Kiqtock
  RSpec.describe Parser do
    let(:numbers)             { '0-10,11,12' }
    let(:numbers_with_spaces) { '0-10, 11, 12' }
    let(:days_with_spaces)    { 'sun-wednesday, friday' }
    let(:months_of_year)      { 'jan-3, may, sept, dec' }

    context 'with a string of numeric expressions' do
      it 'returns a list of values' do
        result = described_class.parse(:any, numbers)
        expect(result).to match_array(%w[0-10 11 12])
      end
    end

    context 'with a string of numeric expressions separated by spaces' do
      it 'returns a list of values' do
        result = described_class.parse(:any, numbers_with_spaces)
        expect(result).to match_array(%w[0-10 11 12])
      end
    end

    context 'with a string of day names' do
      it 'returns a list of values' do
        result = described_class.parse(:days_of_week, days_with_spaces)
        expect(result).to match_array(%w[0-3 5])
      end
    end

    context 'with a string of month names' do
      it 'returns a list of values' do
        result = described_class.parse(:months_of_year, months_of_year)
        expect(result).to match_array(%w[0-3 4 8 11])
      end
    end
  end
end
