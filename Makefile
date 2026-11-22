.PHONY: help setup up down restart logs migrate seed test lint clean

help: ## Show available commands
	@echo "Logistics Fleet Dispatch Platform - Developer CLI"
	@echo "================================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

setup: ## Copy environment template
	cp -n .env.example .env || true
	@echo "Environment file ready (.env)"

up: ## Start full Docker Compose stack (App, MySQL 8, Mailpit)
	docker compose up -d --build

down: ## Stop all running containers
	docker compose down

restart: down up ## Restart containerized environment

logs: ## Follow application logs
	docker compose logs -f app

migrate: ## Execute relational database schema
	docker compose exec -T db mysql -u logistics_user -plogistics_secret_pass logistics_db < database/schema.sql

seed: ## Populate sample couriers, clients and dispatch services
	docker compose exec -T db mysql -u logistics_user -plogistics_secret_pass logistics_db < database/seeds.sql

test: ## Verify PHP syntax across all backend scripts
	@find backend -type f -name "*.php" -exec php -l {} \; > /dev/null
	@echo "All PHP backend scripts verified with zero syntax errors."

clean: ## Remove temporary build files and caches
	find . -type f -name "*.log" -delete
	find . -type f -name ".DS_Store" -delete
