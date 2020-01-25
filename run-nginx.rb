#!/usr/bin/env ruby
require 'aws-sdk-s3'

s3 = Aws::S3::Client.new()
File.open('/etc/nginx/conf.d/default.conf', 'w') do |io|
  s3.get_object(
    bucket: ENV.fetch('S3_CONFIG_BUCKET'),
    key: ENV.fetch('S3_CONFIG_KEY'),
    response_target: io,
  )
end

resolvers = ENV.fetch('RESOLVERS') do
  File.readlines('/etc/resolv.conf').each_with_object([]) do |l, nameservers|
    l = l.chomp.split(/\s+/, 2)
    nameservers << l[1] if l[0] == 'nameserver'
  end.join(?\s)
end
File.write('/etc/nginx/resolver', "resolver #{resolvers};\n")

exec('nginx', '-g', 'daemon off;')
