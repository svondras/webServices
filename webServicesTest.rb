require "httparty"
print "enter enviroment: "

enviro = gets.chomp

ENV['SSL_CERT_FILE'] = File.expand_path(File.dirname(__FILE__)) + "/cacert.pem"

body = %q[<Security xmlns="http://schemas.ost.com/oml/security/1.0"><RootCredentials username="ust_Asurint" password="" /></Security>]

response = HTTParty.post( "https://api-#{enviro}.asurint.com/gw1/SecurityService.svc/xml/authenticate" ,
:body => body,
:headers => {"User-Agent" => "Fiddler", "Content-Type" => "text/xml;charset=utf-8", "Content-Length" => "1987", "Host" => "aws-#{enviro}.asurint.com"}
)

puts "body #{response.body}" 
puts "code #{response.code}"
puts "message #{response.message}"
puts "headers.inspect #{response.headers.inspect}"

my_match = /<UserToken>(.*)<\/UserToken>/.match(response.body.to_s)

  body2 = %q[<?xml version="1.0" encoding="utf-8"?><Order xmlns:package="http://schemas.ost.com/oml/package/1.0" xmlns:meta="http://schemas.ost.com/oml/metadata/1.0" xmlns:batch="http://schemas.ost.com/oml/batch/1.0" intendedUse="0" package:uri="0b901005-b9dd-4248-90f5-16ab602ee19f" reference2="" reference1="" batch:transactionId="00000000-0000-0000-0000-000000000000" batch:customerId="0" batch:userId="0" batch:enabled="false" batch:priority="Low" batch:frequency="0" batch:recordCount="0" batch:executionPeriod="Once" xmlns="http://schemas.ost.com/oml/base/1.0">
  <Input><Subjects><Subject key="" package-uri="" role="Default"><FirstName>Firsty</FirstName><LastName>Lasty</LastName><SSN>123456789</SSN><DOB>01/01/1980</DOB><MiddleName /><DLState /><DLNumber /><DPPAPurpose /><Address /><City /><State /><ZipCode /></Subject></Subjects><Products /><Addresses><Address role="Primary"><StreetLine1>123 Main Street</StreetLine1><City>Sharon</City><StateProvinceCode>PA</StateProvinceCode><ZipCode5>16146</ZipCode5></Address></Addresses><Criteria><Item name="Gender" value="M" scope="Auto" /></Criteria>
  <Annotations xmlns="http://schemas.ost.com/oml/client/1.0"><Annotation title="Previous Convictions" weight="0">N</Annotation><Annotation title="Self-Declared Convictions" weight="0">This subject has not disclosed any offenses</Annotation></Annotations><Documents /></Input></Order>]
  
  response2 = HTTParty.put("https://api-#{enviro}.asurint.com/gw1/OrderingService.svc/xml/order",
  :body => body2,
  :headers => {"User-Agent" => "Fiddler", "Content-Type" => "text/xml;charset=utf-8", "Content-Length" => "1373", "X-Asurint-UserToken" => my_match[1]}
  ) 
  my_match2 = /<OrderID>(.*)<\/OrderID>/.match(response2.body.to_s)
  puts "OrderID: #{my_match2[1]}"

puts "body #{response2.body}" 
puts "code #{response2.code}"
puts "message #{response2.message}"
puts "headers.inspect #{response2.headers.inspect}"


