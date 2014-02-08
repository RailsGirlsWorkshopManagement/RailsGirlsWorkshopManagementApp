require 'spec_helper'

describe "Workshops" do
  subject { page }
  describe "View Workshops when logged out" do
    before { visit workshops_path }

    it { should have_content('Only for Admins available! Please sign in.') }
  end
end
