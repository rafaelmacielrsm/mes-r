module ApplicationHelper
  def link_back(target)
    link_to target, class: 'btn-floating btn-large waves-effect waves-light',
      id: 'return-btn' do
        fa_icon 'arrow-left'
    end
  end
end
