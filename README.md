# Storing Custom Attributes

### Problem Statement:
> Implement a solution that can handle ***any*** custom attributes stored against ***any*** model. 

### Implementation

  - generate new rails application with SQLite
  - using [ActiveRecord::Store](https://api.rubyonrails.org/classes/ActiveRecord/Store.html) module to store hashes in a single column (here-> https://github.com/DaniilLeksin/CA/blob/master/app/models/application_record.rb#L44)
  - tests are not required


### Usage (e.g. Model Partner)

Model inherited from ApplicationRecord and with `t.text` (or `t.string` with length) `:custom_attributes` field is able to store custom attributes as hash.

1. Add migration for `Partner` with the field for custom attributes `t.text :custom_attributes`:
```ruby
  class CreatePartners < ActiveRecord::Migration[5.2]
    def change
      create_table :partners do |t|
        t.text :custom_attributes # <<-- allows to store custom attributes
        t.string :name
        t.string :address
        t.timestamps
      end
    end
  end
```
2. Create new instance of the Partner:
```sh
  >> p = Partner.new(name: 'p_name', address: 'p_address')
```
3. Save custom attribures:
```sh
  >> p.custom_attributes[:email]='p_email'
  >> p.save
  >> Partner.last.custom_attributes
  => {"email"=>"p_email"}
  >> Partner.last.custom_attributes[:email]
  => "p_email"
```
4. Query records. 
```sh
  >> sql = "SELECT * FROM partners WHERE custom_attributes LIKE '%email: p_email%';"
  >> ActiveRecord::Base.connection.execute(sql).last
```

### Feature:
The dificulty I was faced that sql query results with `ActiveSupport::HashWithIndifferentAccess`

```sh
  >> ActiveRecord::Base.connection.execute(sql).last
  => {"id"=>1, "custom_attributes"=>"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nemail: p_email\n", "created_at"=>...
```
If we try to query custom attribute by some other custom attribute, additional manipilations will require:

```sh
  >> p.custom_attributes[:district]='p_district'
  >> p.save
  >> sql = "SELECT * FROM partners WHERE custom_attributes LIKE '%email: p_email%';"
  >> q = ActiveRecord::Base.connection.execute(sql).last
  => {"id"=>1, "custom_attributes"=>"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nemail: p_email\ndistrict: p_district\n"
  >> partner = Partner.find(q['id'])
  >> partner.custom_attributes[:district]
  => "p_district"
```

### Todos

 - Write Tests
 - Get more then 2-3 hours for all the staff

License
----

None


**Free Software, Yeah! It is free**
