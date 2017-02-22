shared_context "record finder" do
  it 'calls the find method' do
    allow( described_class.controller_path.classify.constantize  ).
      to receive(:find).and_return( record_dbl )
    expect( described_class.controller_path.classify.constantize ).to receive(:find)
    send_request
  end

  it "raises RecordNotFound when the id doesn't exists" do
    expect{ send_request }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
