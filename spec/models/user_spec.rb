# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe '.create!' do
    let(:params) do
      {
        email: FFaker::Internet.safe_email,
        password: FFaker::Internet.password
      }
    end

    it 'return user object' do
      expect(User.create!(params)).to be_a(User)
    end

    it 'change users counter' do
      expect { User.create!(params) }.to change { User.count }.by(1)
    end

    context 'Bad arguments' do
      it 'raise an exception ActiveRecord::RecordInvalid' do
        expect { User.create! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'columns' do
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string).with_options(null: false) }
  end
end
