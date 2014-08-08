module NestedParamsHelper
  def property_params_hash
    { name: 'Trump Tower',
      address: '165 Central Avenue',
      city: 'New York',
      state: 'NY',
      zip: '11221',
      property_employees_attributes:
        { "0"=>
          { title_attributes: { title: 'Super' },
            employee_attributes:
            { invitation_token: manager_invitation.token,
              is_admin: true,
              first_name: 'Jared',
              last_name: 'Rader',
              nickname: 'Jay Rad',
              email: 'raderj89+10@gmail.com',
              password: 'password',
              password_confirmation: 'password' }
            }
          }
     }
  end

  def invalid_property_params_hash
    { name: '',
      address: '',
      city: '',
      state: '',
      zip: '',
      property_employees_attributes:
        { "0"=>
          { title_attributes: { title: '' },
            employee_attributes:
            { invitation_token: '',
              is_admin: false,
              first_name: '',
              last_name: '',
              nickname: '',
              email: '',
              password: '',
              password_confirmation: '' }
            }
          }
     }
  end
end

RSpec.configure do |config|
  config.include NestedParamsHelper, type: :controller
end