FROM ruby:2.7-slim-buster

RUN apt-get update && apt-get install -y \
  build-essential \
  # gcloud reqs
  python \
  curl

# install gcloud cli
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin

# ubuntu gcloud compat hack  ¯\_(ツ)_/¯
RUN mkdir -p /snap/bin
RUN ln -s /root/google-cloud-sdk/bin/gcloud /snap/bin/gcloud


WORKDIR /code
