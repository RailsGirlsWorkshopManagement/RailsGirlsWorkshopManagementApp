require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit admin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "signin" do
    before { visit admin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      it { should have_link('Sign out',    href: signout_path) }
      describe "after visiting home" do
        before { click_link "Home" }
        it { should have_link('Home') }
      end
      describe "after visiting workshops" do
        before { click_link "Workshops" }
        it { should have_content('Listing workshops') }
        describe "after clicking New Workshop" do
          before { click_link "New Workshop" }
          it { should have_content('New workshop') }
          # describe "create new workshop" do
          #   let(:workshop) { FactoryGirl.create(:workshop) }
          #   before do
          #     fill_in "Name",    with: workshop.name
          #     fill_in "Date", with: workshop.date
          #     fill_in "Description", with: workshop.description
          #     fill_in "Venue", with: workshop.venue
          #     click_button "Create Workshop"
          #   end
          #   it { should have_content('Demo Workshop') }
          # end
        end
      end
      describe "after visiting show registrations" do
        before { click_link "Show Registrations" }
        it { should have_content('Listing Registrations') }
      end
      describe "after signout" do
        before { click_link "Sign out" }
        it { should have_link('Home') }
      end
    end
  end

end