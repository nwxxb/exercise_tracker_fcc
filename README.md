## Commands

```bash
# install all depedendencies
bundle install

# please edit env file for both test (.env.test) and development (.env.development)
# run test
rspec ./spec/

# run code linter
# see .rubocop.yml to see all excluded rules
bundle exec rubocop

# generate new tags file
bundle exec ripper-tags -R --extra=q .

# run server
bundle exec shotgun config.ru
```

## Docker
you can also use docker to run this api
```bash
# execute only one time...
# or if you add any new gems, please rebuild the image
docker compose build

# please edit env file for both test (.env.test) and development (.env.development)
# then...
docker compose up # turn the docker on

docker exec -it basic_stat_api <command>

docker compose down # turn the docker off
```
