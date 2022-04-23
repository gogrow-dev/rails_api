# GoGrow Rails API boilerplate

This is Gogrow's Rails API boilerplate.

## Usage

1. Fork the repository
2. Run the setup wizard by running `bin/setup` and following the instructions.

## Test helpers

1. `json_response`: Picks up the `response` object and parses the json body content into a hash with indifferent access.

```ruby
it 'returns an error in the email attribute' do
  post users_path, params: { user: { email: 'wrong' }}, as: :json

  expect(json_response).to eq([:email])
end
```

2. `error_details`: Picks up the `response` object and parses the errors hash into an array containing all the response errors.

```ruby
it 'returns an error in the email attribute' do
  post users_path, params: { user: { email: 'wrong' }}, as: :json

  expect(error_details).to eq(['Email is not an email'])
end
```

3. `error_attributes`: Picks up the `response` object and parses the error hash, plucking all the attrbiutes that contain errors.

```ruby
it 'returns an error in the email attribute' do
  post users_path, params: { user: { email: 'wrong' }}, as: :json

  expect(error_attributes).to eq([:email])
end
```
