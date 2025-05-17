Prerequisites:

* Environment variables set
  * `DROPBOX_TIMELAPSEPICS_TOKEN`
  * `CAM_URL`
  * `CAM_USERNAME`
  * `CAM_PASSWORD`
* Ruby 3.4.4 installed
* Firefox installed
* Packages installed `bundle install`

Execute with:
```
bundle exec ruby run.rb
```

```
docker build -t timelapse_pics .

docker run --rm -e DROPBOX_TIMELAPSEPICS_TOKEN=$DROPBOX_TIMELAPSEPICS_TOKEN -e CAM_URL=$CAM_URL -e CAM_USERNAME=$CAM_USERNAME -e CAM_PASSWORD=$CAM_PASSWORD timelapse_pics
```

FIXME: Dockerized firefox does not save the file for some reason.
