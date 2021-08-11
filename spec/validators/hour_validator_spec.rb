# frozen_string_literal: true

module KiqTock
  module Validators
    RSpec.describe HourValidator do
      context 'with hours of the day' do
        it 'returns true if value is within range' do
          expect(described_class.valid?(0)).to be true
          expect(described_class.valid?(23)).to be true
        end

        it 'returns false if value is out of range' do
          expect(described_class.valid?(-1)).to be false
          expect(described_class.valid?(24)).to be false
        end

        it 'returns error if value is not an integer' do
          expect { described_class.valid?('abc') }
            .to(
              raise_error(KiqTock::Error::InvalidHourError)
              .with_message("'abc' is not a valid hour")
            )

          expect { described_class.valid?(-1.0) }
            .to raise_error(KiqTock::Error::InvalidHourError)
        end
      end
    end
  end
end
