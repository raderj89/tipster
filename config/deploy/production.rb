set :stage, :production

role :app, %w{tipster.nycdevshop.com}
role :web, %w{tipster.nycdevshop.com}
role :db,  %w{tipster.nycdevshop.com}

server 'tipster.nycdevshop.com',
  user: 'jared',
  roles: %w{web app},
  ssh_options: {
    user: 'jared',
    keys: %w(/home/jared/.ssh/id_rsa),
    forward_agent: false,
    auth_methods: %w(password),
    password: '123'
  }