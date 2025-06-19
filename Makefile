.PHONY: help build test dev stop clean

IMAGE_NAME = kubsu/brattain-crud

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "%-15s %s\n", $$1, $$2}'

build:
	docker build -t $(IMAGE_NAME) .

test:
	docker-compose up -d db
	@sleep 5
	docker run --rm --network host \
		-e DATABASE_URL="postgresql+psycopg://kubsu:kubsu@localhost:5432/kubsu" \
		$(IMAGE_NAME) python -m pytest -v tests/
	docker-compose down

dev:
	docker-compose up --build

stop:
	docker-compose down

clean:
	docker-compose down -v
	docker system prune -f 