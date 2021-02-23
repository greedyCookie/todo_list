RSpec.shared_context 'integration', :shared_context => :metadata  do
  let(:data)        { JSON.parse(response_body) }
  let(:meta)        { parsed_body['meta'] }
  let(:errors)      { data['error'] }

  #==================================================================

  shared_examples_for 'when user not authenticated' do
    example 'failure not authenticated' do
      do_request

      http_status = 302 # expect authenticated to redirect to sign_in
      expect(status).to eq(http_status)
    end
  end
end
