require 'rails_helper'
require 'support/factory_girl'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

describe 'Create user' do
 it 'add new user to the list' do
   FactoryGirl.create(:user)

   visit root_path
   expect(page).to have_content ('testname')
   expect(page).to have_content ('testsecondname')

   page.save_screenshot('create.png')
 end
end


describe 'Modify user' do
  it 'See modified user' do
    FactoryGirl.create(:user)
    visit root_path
    within(find(:xpath,"//tr[td//text()[contains(., 'testname')]]")) do
      click_link 'Edit'
    end

    fill_in 'user_firstName', with: 'Modify'
    fill_in 'user_secondName', with: 'ModifyModify'
    click_button 'Update User'

    expect(page).to have_content ('Modify')
    expect(page).to have_content ('ModifyModify')
    page.save_screenshot('modify.png')
  end
end

describe 'Destroy user' do
  it 'See user was destroyed' do
    FactoryGirl.create(:user)
    visit root_path

    within(find(:xpath,"//tr[td//text()[contains(., 'testname')]]")) do
      click_link 'Destroy'
    end

    expect(page).not_to have_content ('testname')
    expect(page).not_to have_content ('testsecondname')
    page.save_screenshot('destroy.png')
  end
end

describe "Can't create user with empty fields" do
  it 'Fail to create user with empty field' do
    visit new_user_path

    fill_in 'user_firstName', with: ''
    fill_in 'user_secondName', with: ''
    click_button 'Create User'

    expect(page).to have_content ("can't be blank")
    page.save_screenshot('create_empty.png')
  end
end

describe "Can't create duplicate user" do
  it 'Fail to create duplicate user' do
  visit new_user_path

  fill_in 'user_firstName', with: 'duplicateName'
  fill_in 'user_secondName', with: 'duplicateSecondName'
  click_button 'Create User'

  expect(page).to have_content ('duplicateName')
  expect(page).to have_content ('duplicateSecondName')

    visit new_user_path

    fill_in 'user_firstName', with: 'duplicateName'
    fill_in 'user_secondName', with: 'duplicateSecondName'
    click_button 'Create User'

    expect(page).to have_content ('has already been taken')
    page.save_screenshot('duplicate.png')
  end
end

describe "Random pair generator works property" do
  it 'Random pair generator working' do
    (1..6).each do |user|
      FactoryGirl.create(:user, firstName: "#{user}", secondName: "#{user}")
    end
    result = 0
    visit generate_pairs_users_path
    (1..120).each do
      user = all("tr td")[0].text
      if user == "1 1"
        result +=1
      end
      click_on('Generate')
    end
    p result
    result = (result/120.0).round(2)
    p result
    if result > 0.17 || result < 0.16
      raise Exception.new('Your pairs generator is very very very BAAAAAD!')
    end
    # visit generate_pairs_users_path
    # page.save_screenshot('1.png')
    #   click_on 'Generate'
    # page.save_screenshot('2.png')
  end
end
