PATH = '/home/ds/rails/demo/drink/'

worker_processes 2
preload_app true
timeout 30

working_directory PATH
pid               PATH+'tmp/pids/unicorn.pid'
stderr_path       PATH+'log/unicorn.log'
stdout_path       PATH+'log/unicorn.log'
listen            '/tmp/unicorn.drink.sock', backlog: 64


# sudo service nginx start
# sudo service unicorn.drink start
