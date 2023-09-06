FROM ruby:3.1.2

RUN useradd --create-home appuser
USER appuser
WORKDIR /home/appuser/code

COPY --chown=appuser . /home/appuser/code

RUN bundle install

EXPOSE 3000

# default command, you can overwrite it in compose file
CMD ["bundle", "exec", "shotgun", "--host=0.0.0.0", "--port=3000", "./config.ru"]
