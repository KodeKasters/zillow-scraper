Build the docker image
``` 
sudo docker build --platform=linux/amd64 -t zillow-scraper . 
```

Run the container
```
docker run --rm -t zillow-scraper
```