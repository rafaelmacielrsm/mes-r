require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe "#link_back" do
    context 'when a valid url is received' do
      let(:target){ url_for(controller: :batches, action: :index) }

      it 'has a btn-floating class' do
        expect(helper.link_back target).to match(/class=\"btn-floating/)
      end

      it 'has the return-btn id' do
        expect(helper.link_back target).to match(/id=\"return-btn\"/)
      end

      it 'has a icon' do
        expect(helper.link_back target).to match(/<i.*arrow/)
      end
    end
  end
end
