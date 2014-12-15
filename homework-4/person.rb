require 'json'

module Printer

  module ClassMethods

    def printer_methods(*params)

      define_method params[0] do
        p "Profile of the person."
      end

      define_method params[1] do
        p "First Name: #{self.person_info['name']}"
        p "Last Name: #{self.person_info['last_name']}"
        p "Gender: #{self.person_info['gender']}"
        p "Year of birth: #{self.person_info['birth_year']}"
        p "Year of death: #{self.person_info['death_year']}"
        years = self.person_info['death_year'].to_i - self.person_info['birth_year'].to_i
        p "Years: #{years}"
      end

      define_method params[2] do
        puts
        p "Awards:"
        self.prizes.select {
          |item|
          p "#{self.prizes[item]["name"]} got in the #{self.prizes[item]["year"]} year"
        }
      end

      define_method params[3] do
        puts
        p "#{self.person_info['name']} #{self.person_info['last_name']} was member in the #{self.membership.join ", "}"
      end

      define_method params[4] do
        puts
        p "Hobbies: #{self.hobbies.join ", "}"
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end

RESPONSE = '{ "person":
                    { "person_info":
                                  { "name": "Richard",
                                    "last_name": "Faynman",
                                    "gender": "male",
                                    "birth_year": 1918,
                                    "death_year": 1988,
                                    "nationality": "american"
                                  },
                      "prizes":
                            { "nobel": { "name": "Nobel Prize",
                                "year": 1965 },
                              "einstein": { "name": "Albert Einstein prize",
                                "year": 1954 },
                              "ernest": { "name": "Ernest Orlando Lourens prize",
                                "year": 1962 },
                              "golden_medal": { "name": "International golden medal named Nils Born",
                                "year": 1973 }
                            },
                      "membership": ["American Physical Society", "Brazilian Academy of Sciences", "Royal Society"],
                      "hobbies": [ "psychology", "biology", "dances", "bongo" ]
                    }
             }'

response = JSON.parse(RESPONSE)

if response.key?("person")

  scientist = Struct.new("Scientist", *response["person"].keys.collect(&:to_sym))

  Struct::Scientist.class_eval do

    include Printer

    printer_methods :show_profile_header, :show_main_info, :show_prizes, :show_membership, :show_hobbies

  end

  scientist_object = Struct::Scientist.new(*response["person"].values)
  scientist_object.show_profile_header
  scientist_object.show_main_info
  scientist_object.show_prizes
  scientist_object.show_membership
  scientist_object.show_hobbies

end