all: build

build:
	@docker build -t ${USER}/redis -—no-cache .
