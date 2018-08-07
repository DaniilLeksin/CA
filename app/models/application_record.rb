class ApplicationRecord < ActiveRecord::Base
  # Handle any custom attributes stored against any model. 
  # Any model inherited from ApplicationRecord and with t.text (or t.string with length) :custom_attributes field
  # is able to store custom attributes as hash.
  #
  # e.g. Model Partner
  #
  # class CreatePartners < ActiveRecord::Migration[5.2]
  #   def change
  #     create_table :partners do |t|
  #       t.text :custom_attributes <<-- allows to store custom attributes
  #       t.string :name
  #       t.string :address
  #       t.timestamps
  #     end
  #   end
  # end
  #
  # >> p = Partner.new(name: 'p_name', address: 'p_address')
  # >> p.custom_attributes[:email]='p_email'
  # >> p.save
  # >> Partner.last.custom_attributes
  # => {"email"=>"p_email"}
  # >> Partner.last.custom_attributes[:email]
  # => "p_email"
  #
  # Query via pure SQL (find record by custom attribute)
  # >> sql = "SELECT * FROM partners WHERE custom_attributes LIKE '%email: p_email%';"
  # >> ActiveRecord::Base.connection.execute(sql).last
  # The dificulty I was faced that sql query results with ActiveSupport::HashWithIndifferentAccess
  # => {"id"=>1, "custom_attributes"=>"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nemail: p_email\n", "created_at"=>...
  # If the customer is trying to query custom attribute by some other custom attribute
  # additional manipilations will require
  # e.g. (in continuing of above)
  # >> p.custom_attributes[:district]='p_district'
  # >> p.save
  # >> sql = "SELECT * FROM partners WHERE custom_attributes LIKE '%email: p_email%';"
  # >> q = ActiveRecord::Base.connection.execute(sql).last
  # => {"id"=>1, "custom_attributes"=>"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nemail: p_email\ndistrict: p_district\n"
  # >> partner = Partner.find(q['id'])
  # >> partner.custom_attributes[:district]
  # => "p_district"

  store :custom_attributes	
  self.abstract_class = true
end
