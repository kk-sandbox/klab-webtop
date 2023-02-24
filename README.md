# Run Ubuntu minimal desktop in docker container

### Pull webtop
	docker push kribakarans/ubuntu-webtop:latest

### Run Ubuntu webtop
	docker run -it --name ubuntu-webtop -p 5901:5901 -p 6901:6901 -v $HOME/Public:/data kribakarans/ubuntu-webtop:latest
