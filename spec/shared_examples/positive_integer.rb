shared_examples_for('a positive integer') do
    # This shared example needs:
    # subject => as a valid object
    # field_name => positive integer the field name
    def set_field_value(val)
      subject.send("#{field_name}=", val)
    end

    let!(:field) { field_name.to_sym }
    let(:error_type) { subject.errors.details[field].first[:error] }

    context 'when the field is nil' do
      it 'includes the field symbol in the error hash' do
        set_field_value( nil )
        expect {subject.valid?}.to \
          change{subject.errors.include?(field)}.from(false).to(true)
      end

      it 'invalidates with not_a_number error'do
        set_field_value( nil )
        subject.valid?
        expect(error_type).to be(:not_a_number)
      end
    end

    context 'when the field value is zero' do
      it 'invalidates with a greater_than error' do
        set_field_value( 0 )
        subject.valid?
        expect(error_type).to be(:greater_than)
      end
    end

    context 'when the field value is a floating point' do
      it 'invalidates with a not_an_integer error' do
        set_field_value( 3.55 )
        subject.valid?
        expect(error_type).to be(:not_an_integer)
      end
    end
    context 'when the field has a negative value' do
      it 'invalidates with a greater_than error' do
        set_field_value( -10 )
        subject.valid?
        expect(error_type).to be(:greater_than)
      end
    end
end # shared_examples_for('positive integer')
