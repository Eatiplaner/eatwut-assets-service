require 'rails_helper'

RSpec.describe MediaTracking do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:media_type) }
    it { is_expected.to validate_presence_of(:resource_type) }
    it { is_expected.to validate_presence_of(:resource_id) }
    it { is_expected.to validate_presence_of(:access_url) }

    describe 'uniqueness' do
      subject { build(:media_tracking, s3_key: '1232abd') }

      it { is_expected.to validate_uniqueness_of(:s3_key) }
    end

    describe 'acceptance' do
      context 'resource_type' do
        it { is_expected.to allow_value('user').for(:resource_type) }
        it { is_expected.to allow_value('plan').for(:resource_type) }

        it { is_expected.not_to allow_value('test').for(:resource_type) }
      end

      context 'media_type' do
        it { is_expected.to allow_value('avatar').for(:media_type) }
      end
    end
  end

  describe 'settings' do
    it do
      values = {
        inprogress: 'inprogress',
        completed: 'completed',
      }

      expect(subject).to define_enum_for(:status).with_values(values).backed_by_column_of_type(:string).with_prefix
    end
  end
end
