require 'rails_helper'

RSpec.feature "SignIns", type: :feature do
  scenario 'user cannot sign in if not registered' do
    signin('example@example.com', 'password')
    expect(page).to have_content 'Invalid'
  end

  scenario 'user can sign in with valid credentials' do
    user = create(:user)
    signin(user.email, user.password)
    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'user cannot sign in with invalid email' do
    user = create(:user)
    signin('invalid@email.com', user.password)
    expect(page).to have_content 'Invalid email or password'
  end

  scenario 'user cannot sign in with invalid password' do
    user = create(:user)
    signin(user.email, 'invalidpassword')
    expect(page).to have_content 'Invalid email or password'
  end
end
