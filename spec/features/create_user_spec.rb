describe 'Students management test' do

  before do
      page.driver&.basic_authorize('admin','admin')
  end

  let!(:user) { User.create(first_name: 'testname1',  last_name: 'testLast name1') }

  context 'Test CRUD functionality' do

      it 'Add new user to the list' do
        visit "/"
        assert page.has_content?("All Users")
        find(:xpath,"//A[@class='btn btn-primary'][text()='New User']").click
        fill_in ' First name',  with: "First name"
        fill_in ' Last name', with: "Last name"
        click_on 'Create User'
        expect(page).to have_content ('First name')
        expect(page).to have_content ('Last name')
      end

      it 'Editing user' do
         visit "/"
         assert page.has_content?("All Users")
         within(find(:xpath,"//tr[td//text()[contains(., 'testname1')]]")) do
           click_link 'Edit'
         end
         fill_in ' First name', with: 'testname1Modify'
         fill_in ' Last name', with: 'testLast name1Modify'
         click_button 'Update User'
         assert page.has_content?("All Users")
         expect(page).to have_content ('testname1Modify')
         expect(page).to have_content ('testLast name1Modify')
       end

       it 'Destroy of the user' do
         visit "/"
         assert page.has_content?("All Users")
         within(find(:xpath,"//tr[td//text()[contains(., 'testname')]]")) do
           click_link 'Destroy'
         end
         expect(page).not_to have_content ('testname1')
         expect(page).not_to have_content ('testLast name1')
       end

  end

  context 'Validation test for CRUD' do

      it 'Fail to create user with empty field' do
        visit "/"
        assert page.has_content?("All Users")
        find(:xpath,"//A[@class='btn btn-primary'][text()='New User']").click
        fill_in ' First name', with: ''
        fill_in ' Last name', with: ''
        click_on 'Create User'
        assert page.has_content?("New User")
        expect(page).to have_content ("can't be blank")
      end


      it 'Fail to create duplicate user' do
        visit "/"
        assert page.has_content?("All Users")
        find(:xpath,"//A[@class='btn btn-primary'][text()='New User']").click
        fill_in ' First name',  with: "First name"
        fill_in ' Last name', with: "Last name"
        click_on 'Create User'
        assert page.has_content?("All Users")
        expect(page).to have_content ('First name')
        expect(page).to have_content ('Last name')
        find(:xpath,"//A[@class='btn btn-primary'][text()='New User']").click
        fill_in ' First name',  with: "First name"
        fill_in ' Last name', with: "Last name"
        click_on 'Create User'
        assert page.has_content?("New User")
        expect(page).to have_content ('has already been taken')
      end
    end

    context 'Pairs generator logic validation' do
      it 'Check whether pairs generator correctly works' do
        (1..5).each do |user|
          FactoryGirl.create(:user, first_name: "#{user}", last_name: "#{user}")
        end
        visit "/"
        assert page.has_content?("All Users")
        find(:xpath,"(//A[@href='/users/generate_pairs'][text()='Generator'][text()='Generator'])[1]").click
        assert page.has_content?("1 Pair")
        result = 0
        (1..100).each do
          user = all("tr td")[0].text
          if user == "1 1"
            result +=1
          end
          click_on('Generate')
        end
        result = (result/100.0).round(2)
        if result > 0.2 #|| result < 0.16
          raise Exception.new('Your pairs generator is very very BAAAAAD!')
        end
      end
     end
end
