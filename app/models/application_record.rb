class ApplicationRecord < ActiveRecord::Base
  # Handle any custom attributes stored against any model. 
  # Any model inherited from ApplicationRecord and has t.text (or t.string with length) :custom_attributes field
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
  # >> ActiveRecord::Base.connection.execute(sql)

  store :custom_attributes	
  self.abstract_class = true
end
