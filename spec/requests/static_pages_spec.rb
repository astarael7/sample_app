require 'spec_helper'

describe "Static pages" do

  subject { page }

describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1', text: 'Bloggle') }
    it { should have_selector('title', text: '') }
    it { should_not have_selector 'title', text: '| Home' }
  end

  shared_examples_for "all static pages" do
    it { should have_title(title) }
  end

  describe "About page" do
    before { visit about_path }
    let(:title)     { 'About This' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:title)  { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About This')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
    click_link "Bloggle"
    page.should have_selector 'title', text: full_title('')
  end
end