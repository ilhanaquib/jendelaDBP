require 'jwt'

key_file = 'AuthKey_3ZZ57R5AQ4.p8'
team_id = 'M976Y2ZX74'
client_id = 'my.jendeladbp.mobilebookreader'
key_id = '3ZZ57R5AQ4'

ecdsa_key = OpenSSL::PKey::EC.new IO.read key_file

headers = {
  'kid' => key_id
}

claims = {
	'iss' => team_id,
	'iat' => Time.now.to_i,
	'exp' => Time.now.to_i + 86400*180,
	'aud' => 'https://appleid.apple.com',
	'sub' => client_id,
}

token = JWT.encode claims, ecdsa_key, 'ES256', headers

puts token