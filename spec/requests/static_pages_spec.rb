require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit home_path }

    it { should have_link('Home') }
    it { should_not have_title('| Home') }
  end
end
